const QRCode = require("qrcode");
const Stripe = require("stripe");

const Booking = require("../models/Booking");
const Parking = require("../models/Parking");
const { buildBookingWindow, formatDuration, formatTimer, normalizeBookingDate } = require("../utils/bookingTime");
const { HttpError } = require("../utils/httpError");
const { calculateBookingPricing, calculateExtensionPricing, formatMoney, roundMoney } = require("../utils/pricing");

const activeStatuses = ["pending_checkin", "in_progress"];
const requestStatuses = ["pending_host_approval"];
const historyStatuses = ["completed", "cancelled", "declined", "expired"];
let stripeClient;

const statusLabels = {
  pending_host_approval: "Pending approval",
  pending_checkin: "Pending check-in",
  in_progress: "In parking",
  completed: "Completed",
  cancelled: "Cancelled",
  declined: "Declined",
  expired: "Expired",
};

function asyncHandler(handler) {
  return (req, res, next) => Promise.resolve(handler(req, res, next)).catch(next);
}

function cleanString(value) {
  return typeof value === "string" ? value.trim() : undefined;
}

function cleanEnv(name) {
  return cleanString(process.env[name]);
}

function getStripeClient() {
  const secretKey = cleanEnv("STRIPE_SECRET_KEY");

  if (!secretKey) {
    throw new HttpError(503, "Stripe is not configured on the server");
  }

  if (!stripeClient) {
    stripeClient = Stripe(secretKey);
  }

  return stripeClient;
}

function getStripePublishableKey() {
  return cleanEnv("STRIPE_PUBLISHABLE_KEY");
}

function getStripeCurrency(pricing) {
  return (cleanEnv("STRIPE_CURRENCY") || pricing.currency || "DOP").toLowerCase();
}

function toStripeAmount(amount, currency) {
  const zeroDecimalCurrencies = new Set([
    "bif",
    "clp",
    "djf",
    "gnf",
    "jpy",
    "kmf",
    "krw",
    "mga",
    "pyg",
    "rwf",
    "ugx",
    "vnd",
    "vuv",
    "xaf",
    "xof",
    "xpf",
  ]);
  return Math.round(Number(amount || 0) * (zeroDecimalCurrencies.has(currency) ? 1 : 100));
}

function isEnabled(value) {
  return value === true || value === "true";
}

function normalizeVehiclePlate(value) {
  const vehiclePlate = cleanString(value);
  return vehiclePlate ? vehiclePlate.toUpperCase() : undefined;
}

function normalizePaymentMethod(value) {
  const paymentMethod = cleanString(value || "card");

  if (paymentMethod === "credit_card" || paymentMethod === "debit_card") {
    return "card";
  }

  if (paymentMethod === "cash_at_parking") {
    return "cash";
  }

  return paymentMethod;
}

function parseScannedParkingId(value) {
  const raw = cleanString(value);

  if (!raw) {
    return undefined;
  }

  if (/^[a-f\d]{24}$/i.test(raw)) {
    return raw;
  }

  try {
    const decoded = JSON.parse(raw);
    if (decoded && typeof decoded === "object" && decoded.type === "parkealo_host_parking") {
      return cleanString(decoded.parkingId);
    }
  } catch (_) {
    return undefined;
  }

  return undefined;
}

function extractCardLast4(body) {
  const cardLast4 = cleanString(body.cardLast4 || (body.payment && body.payment.cardLast4));

  if (cardLast4 && /^\d{4}$/.test(cardLast4)) {
    return cardLast4;
  }

  const cardNumber = cleanString(body.cardNumber || (body.payment && body.payment.cardNumber));

  if (!cardNumber) {
    return undefined;
  }

  const digits = cardNumber.replace(/\D/g, "");
  return digits.length >= 4 ? digits.slice(-4) : undefined;
}

function generateConfirmationCode() {
  const timestamp = Date.now().toString(36).toUpperCase();
  const random = Math.random().toString(36).slice(2, 6).toUpperCase();
  return `PKL-${timestamp}-${random}`;
}

function getEndTimeLabel(endAt) {
  const date = new Date(endAt);
  const hour = date.getUTCHours();
  const minute = String(date.getUTCMinutes()).padStart(2, "0");
  const suffix = hour >= 12 ? "PM" : "AM";
  const hour12 = hour % 12 || 12;
  return `${hour12}:${minute} ${suffix}`;
}

function getTabForStatus(status) {
  if (activeStatuses.includes(status)) {
    return "active";
  }

  if (requestStatuses.includes(status)) {
    return "requests";
  }

  return "history";
}

function getBookingActions(booking) {
  return {
    canCheckIn: booking.status === "pending_checkin",
    canNotifyHost: booking.status === "pending_checkin",
    canExtend: booking.status === "in_progress",
    canCheckOut: booking.status === "in_progress",
    canOpenDirections: ["pending_checkin", "in_progress", "completed"].includes(booking.status),
    chatAvailable: ["pending_host_approval", "pending_checkin", "in_progress"].includes(booking.status),
  };
}

function buildParkingSnapshot(parking) {
  const [longitude, latitude] = parking.location.coordinates;
  const zone = parking.zone || parking.address.zone || parking.address.city;

  return {
    name: parking.name,
    slug: parking.slug,
    zone,
    address: parking.address,
    coordinates: { latitude, longitude },
    hourlyRate: parking.rate.hourly,
    currency: parking.rate.currency,
    currencySymbol: parking.rate.currencySymbol,
    approvalMode: parking.approvalMode,
  };
}

function buildQrPayload(booking) {
  return JSON.stringify({
    type: "parkealo_booking",
    bookingId: booking._id.toString(),
    confirmationCode: booking.confirmationCode,
    parkingId: booking.parking.toString(),
    startAt: booking.startAt,
    endAt: booking.endAt,
  });
}

function occupyFirstAvailableSpace(parking) {
  const allSpaces = parking.sections?.length
    ? parking.sections.flatMap((section) => section.spaces || [])
    : parking.spaceIdentifiers || [];
  const occupied = new Set((parking.occupancy?.occupiedSpaces || []).map(String));
  const nextSpace = allSpaces.map(String).find((space) => !occupied.has(space));

  if (!nextSpace) return;

  parking.occupancy = {
    ...(parking.occupancy?.toObject ? parking.occupancy.toObject() : parking.occupancy || {}),
    occupiedSpaces: [...occupied, nextSpace],
  };
}

async function findActiveParking(value) {
  const parkingId = cleanString(value);

  if (!parkingId) {
    throw new HttpError(400, "Parking id is required");
  }

  const query = /^[a-f\d]{24}$/i.test(parkingId)
    ? { _id: parkingId, status: "active" }
    : { slug: parkingId.toLowerCase(), status: "active" };
  const parking = await Parking.findOne(query);

  if (!parking) {
    throw new HttpError(404, "Parking lot not found");
  }

  return parking;
}

function extractPaymentIntentId(body) {
  const rawId =
    cleanString(body.paymentIntentId) ||
    cleanString(body.stripePaymentIntentId) ||
    cleanString(body.payment && (body.payment.paymentIntentId || body.payment.stripePaymentIntentId));

  if (rawId) {
    return rawId;
  }

  const clientSecret = cleanString(body.paymentIntentClientSecret || (body.payment && body.payment.clientSecret));
  return clientSecret && clientSecret.includes("_secret_") ? clientSecret.split("_secret_")[0] : undefined;
}

async function verifyStripePayment(body, quote, userId) {
  const paymentIntentId = extractPaymentIntentId(body);

  if (!paymentIntentId) {
    throw new HttpError(400, "Stripe payment intent is required for card payments");
  }

  const currency = getStripeCurrency(quote.pricing);
  const expectedAmount = toStripeAmount(quote.pricing.total, currency);
  const stripe = getStripeClient();
  const paymentIntent = await stripe.paymentIntents.retrieve(paymentIntentId, {
    expand: ["latest_charge.payment_method_details"],
  });

  if (paymentIntent.status !== "succeeded") {
    throw new HttpError(402, "Card payment was not completed");
  }

  if (paymentIntent.amount !== expectedAmount || paymentIntent.currency !== currency) {
    throw new HttpError(400, "Stripe payment amount does not match this booking");
  }

  if (paymentIntent.metadata?.userId && paymentIntent.metadata.userId !== userId.toString()) {
    throw new HttpError(403, "Stripe payment does not belong to this user");
  }

  if (paymentIntent.metadata?.parkingId && paymentIntent.metadata.parkingId !== quote.parking._id.toString()) {
    throw new HttpError(400, "Stripe payment does not belong to this parking");
  }

  const charge = paymentIntent.latest_charge && typeof paymentIntent.latest_charge === "object"
    ? paymentIntent.latest_charge
    : undefined;
  const card = charge?.payment_method_details?.card;

  return {
    provider: "stripe",
    stripePaymentIntentId: paymentIntent.id,
    stripeChargeId: charge?.id,
    cardBrand: card?.brand,
    cardLast4: card?.last4 || extractCardLast4(body),
    chargedAmount: quote.pricing.total,
    currency: quote.pricing.currency,
  };
}

async function buildPayment(body, pricing, quote, userId) {
  const method = normalizePaymentMethod(body.paymentMethod || (body.payment && body.payment.method));

  if (!["card", "cash"].includes(method)) {
    throw new HttpError(400, "Payment method must be card or cash");
  }

  const payment = {
    method,
    status: method === "cash" ? "cash_due" : "paid",
    paidAt: method === "cash" ? undefined : new Date(),
  };

  if (method === "card") {
    Object.assign(payment, await verifyStripePayment(body, quote, userId));
  }

  pricing.paidTotal = method === "cash" ? 0 : pricing.total;
  return payment;
}

async function buildQuoteFromRequest(body) {
  const parking = await findActiveParking(body.parkingId || body.parking);
  const date = normalizeBookingDate(body.date);
  const durationHours = Number(body.durationHours || 2);
  const arrivalTime = cleanString(body.arrivalTime) || parking.bookingSettings.arrivalTimes[0];

  if (!date) {
    throw new HttpError(400, "Date must use YYYY-MM-DD format");
  }

  if (!Number.isFinite(durationHours) || durationHours < 1 || durationHours > parking.bookingSettings.maxDurationHours) {
    throw new HttpError(400, `Duration must be between 1 and ${parking.bookingSettings.maxDurationHours} hours`);
  }

  const bookingWindow = buildBookingWindow(date, arrivalTime, durationHours);

  if (!bookingWindow) {
    throw new HttpError(400, "Arrival time must use HH:mm or h:mm AM/PM format");
  }

  const insuranceIncluded = isEnabled(body.insuranceIncluded);
  const pricing = calculateBookingPricing(parking, durationHours, insuranceIncluded);

  return {
    parking,
    date,
    durationHours,
    arrivalTime: bookingWindow.arrivalTime,
    startAt: bookingWindow.startAt,
    endAt: bookingWindow.endAt,
    timeRange: bookingWindow.timeRange,
    insuranceIncluded,
    pricing,
  };
}

function presentQuote(quote) {
  return {
    parking: {
      id: quote.parking._id.toString(),
      name: quote.parking.name,
      zone: quote.parking.zone || quote.parking.address.zone || quote.parking.address.city,
      approvalMode: quote.parking.approvalMode,
    },
    reservation: {
      date: quote.date,
      arrivalTime: quote.arrivalTime,
      timeRange: quote.timeRange,
      durationHours: quote.durationHours,
      durationLabel: formatDuration(quote.durationHours),
      startAt: quote.startAt,
      endAt: quote.endAt,
      space: quote.parking.availability.assignedAtArrival ? "Assigned at arrival" : "Assigned by parking",
    },
    pricing: {
      ...quote.pricing,
      lineItems: [
        {
          label: `Booking (${formatDuration(quote.durationHours)})`,
          amount: quote.pricing.durationSubtotal,
          displayAmount: formatMoney(quote.pricing.durationSubtotal, quote.pricing.currencySymbol),
        },
        {
          label: "Insurance",
          amount: quote.pricing.insuranceFee,
          displayAmount: formatMoney(quote.pricing.insuranceFee, quote.pricing.currencySymbol),
        },
        {
          label: `Tax (${Math.round(quote.pricing.taxRate * 100)}%)`,
          amount: quote.pricing.taxAmount,
          displayAmount: formatMoney(quote.pricing.taxAmount, quote.pricing.currencySymbol),
        },
        {
          label: "Service fee",
          amount: quote.pricing.serviceFee,
          displayAmount: formatMoney(quote.pricing.serviceFee, quote.pricing.currencySymbol),
        },
      ],
      displayTotal: formatMoney(quote.pricing.total, quote.pricing.currencySymbol),
    },
  };
}

async function presentBooking(booking, options = {}) {
  const value = booking.toObject ? booking.toObject() : booking;
  const timeRange = `${value.arrivalTime} - ${getEndTimeLabel(value.endAt)}`;
  const parkedMilliseconds = value.checkedInAt
    ? (value.checkedOutAt ? new Date(value.checkedOutAt).getTime() : Date.now()) -
      new Date(value.checkedInAt).getTime()
    : 0;
  const response = {
    id: value._id.toString(),
    confirmationCode: value.confirmationCode,
    status: value.status,
    statusLabel: statusLabels[value.status],
    tab: getTabForStatus(value.status),
    approvalMode: value.approvalMode,
    parking: {
      id: value.parking.toString(),
      ...value.parkingSnapshot,
    },
    reservation: {
      date: value.date,
      arrivalTime: value.arrivalTime,
      timeRange,
      durationHours: value.durationHours,
      durationLabel: formatDuration(value.durationHours),
      startAt: value.startAt,
      endAt: value.endAt,
      checkedInAt: value.checkedInAt,
      checkedOutAt: value.checkedOutAt,
      parkingTimer: value.checkedInAt ? formatTimer(parkedMilliseconds) : null,
      space: "Assigned at arrival",
      vehiclePlate: value.vehiclePlate,
      bookForOther: value.bookForOther,
      otherDriverName: value.otherDriverName,
    },
    pricing: {
      ...value.pricing,
      displayTotal: formatMoney(value.pricing.total, value.pricing.currencySymbol),
      displayPaidTotal: formatMoney(value.pricing.paidTotal, value.pricing.currencySymbol),
    },
    payment: value.payment,
    insuranceIncluded: value.insuranceIncluded,
    safety: value.safety,
    extensions: value.extensions,
    actions: getBookingActions(value),
    qrPayload: value.qrPayload,
    createdAt: value.createdAt,
    updatedAt: value.updatedAt,
  };

  if (options.includeQr && value.qrPayload) {
    response.qrCodeDataUrl = await QRCode.toDataURL(value.qrPayload, {
      margin: 1,
      width: 240,
    });
  }

  return response;
}

async function findOwnedBooking(userId, bookingId) {
  if (!/^[a-f\d]{24}$/i.test(bookingId)) {
    throw new HttpError(404, "Booking not found");
  }

  const booking = await Booking.findOne({ _id: bookingId, user: userId });

  if (!booking) {
    throw new HttpError(404, "Booking not found");
  }

  return booking;
}

const quoteBooking = asyncHandler(async (req, res) => {
  const quote = await buildQuoteFromRequest(req.body);

  res.json({
    success: true,
    message: "Booking quote calculated",
    quote: presentQuote(quote),
  });
});

const safetyCheck = asyncHandler(async (req, res) => {
  const requiresAcknowledgement = isEnabled(req.body.leavingValuables);

  res.json({
    success: true,
    requiresAcknowledgement,
    title: "Safety notice",
    message: requiresAcknowledgement
      ? "Remember not to leave valuable objects visible inside your vehicle. Parkealo is not responsible for loss or damage caused by items left in view."
      : "No safety acknowledgement is required.",
    actions: requiresAcknowledgement ? ["Cancel", "I understand"] : [],
  });
});

const createPaymentIntent = asyncHandler(async (req, res) => {
  const quote = await buildQuoteFromRequest(req.body);
  const currency = getStripeCurrency(quote.pricing);
  const amount = toStripeAmount(quote.pricing.total, currency);
  const publishableKey = getStripePublishableKey();

  if (!publishableKey) {
    throw new HttpError(503, "Stripe publishable key is not configured on the server");
  }

  const paymentIntent = await getStripeClient().paymentIntents.create({
    amount,
    currency,
    automatic_payment_methods: { enabled: true },
    metadata: {
      userId: req.user._id.toString(),
      parkingId: quote.parking._id.toString(),
      date: quote.date,
      arrivalTime: quote.arrivalTime,
      durationHours: String(quote.durationHours),
      insuranceIncluded: String(quote.insuranceIncluded),
    },
  });

  res.status(201).json({
    success: true,
    message: "Stripe payment intent created",
    publishableKey,
    paymentIntentId: paymentIntent.id,
    clientSecret: paymentIntent.client_secret,
    amount,
    currency: currency.toUpperCase(),
    quote: presentQuote(quote),
  });
});

const createBooking = asyncHandler(async (req, res) => {
  const quote = await buildQuoteFromRequest(req.body);
  const vehiclePlate = normalizeVehiclePlate(req.body.vehiclePlate) || req.user.vehiclePlate;
  const leavingValuables = isEnabled(req.body.leavingValuables);

  if (!vehiclePlate) {
    throw new HttpError(400, "Vehicle plate is required");
  }

  if (leavingValuables && !isEnabled(req.body.safetyAcknowledged)) {
    throw new HttpError(400, "Safety notice must be acknowledged before booking");
  }

  const payment = await buildPayment(req.body, quote.pricing, quote, req.user._id);
  const status = quote.parking.approvalMode === "host_approval" ? "pending_host_approval" : "pending_checkin";
  let reservedParking = null;

  if (quote.parking.approvalMode === "automatic") {
    reservedParking = await Parking.findOneAndUpdate(
      {
        _id: quote.parking._id,
        status: "active",
        "availability.availableSpaces": { $gt: 0 },
      },
      { $inc: { "availability.availableSpaces": -1 } },
      { returnDocument: "after" },
    );

    if (!reservedParking) {
      throw new HttpError(409, "No parking spaces are currently available");
    }

    occupyFirstAvailableSpace(reservedParking);
    await reservedParking.save();
  }

  try {
    const booking = await Booking.create({
      confirmationCode: generateConfirmationCode(),
      user: req.user._id,
      parking: quote.parking._id,
      parkingSnapshot: buildParkingSnapshot(quote.parking),
      status,
      approvalMode: quote.parking.approvalMode,
      date: quote.date,
      arrivalTime: quote.arrivalTime,
      durationHours: quote.durationHours,
      startAt: quote.startAt,
      endAt: quote.endAt,
      vehiclePlate,
      bookForOther: isEnabled(req.body.bookForOther),
      otherDriverName: cleanString(req.body.otherDriverName),
      pricing: quote.pricing,
      payment,
      insuranceIncluded: quote.insuranceIncluded,
      safety: {
        leavingValuables,
        acknowledgedAt: leavingValuables ? new Date() : undefined,
      },
    });

    booking.qrPayload = buildQrPayload(booking);
    await booking.save({ validateBeforeSave: false });

    res.status(201).json({
      success: true,
      message:
        status === "pending_host_approval"
          ? "Booking request sent to the host"
          : "Booking confirmed successfully",
      booking: await presentBooking(booking, { includeQr: true }),
    });
  } catch (error) {
    if (reservedParking) {
      await Parking.updateOne({ _id: reservedParking._id }, { $inc: { "availability.availableSpaces": 1 } });
    }

    throw error;
  }
});

const listBookings = asyncHandler(async (req, res) => {
  const tab = cleanString(req.query.tab);
  const type = cleanString(req.query.type || req.query.filter);
  const filter = { user: req.user._id };

  if (tab === "active") {
    filter.status = { $in: activeStatuses };
  } else if (tab === "requests") {
    filter.status = { $in: requestStatuses };
  } else if (tab === "history") {
    filter.status = { $in: historyStatuses };
  }

  if (type === "rapid" || type === "automatic") {
    filter.approvalMode = "automatic";
  }

  if (type === "pending") {
    filter.status = { $in: ["pending_host_approval", "pending_checkin"] };
  }

  const bookings = await Booking.find(filter).sort({ startAt: tab === "history" ? -1 : 1 });
  const [allCount, rapidCount, pendingCount, activeCount, requestCount, historyCount] = await Promise.all([
    Booking.countDocuments({ user: req.user._id }),
    Booking.countDocuments({ user: req.user._id, approvalMode: "automatic" }),
    Booking.countDocuments({ user: req.user._id, status: { $in: ["pending_host_approval", "pending_checkin"] } }),
    Booking.countDocuments({ user: req.user._id, status: { $in: activeStatuses } }),
    Booking.countDocuments({ user: req.user._id, status: { $in: requestStatuses } }),
    Booking.countDocuments({ user: req.user._id, status: { $in: historyStatuses } }),
  ]);

  res.json({
    success: true,
    message: `${bookings.length} bookings found`,
    counts: {
      all: allCount,
      rapid: rapidCount,
      pending: pendingCount,
      active: activeCount,
      requests: requestCount,
      history: historyCount,
    },
    bookings: await Promise.all(bookings.map((booking) => presentBooking(booking))),
  });
});

const getBooking = asyncHandler(async (req, res) => {
  const booking = await findOwnedBooking(req.user._id, req.params.id);

  res.json({
    success: true,
    booking: await presentBooking(booking, { includeQr: true }),
  });
});

const notifyHost = asyncHandler(async (req, res) => {
  const booking = await findOwnedBooking(req.user._id, req.params.id);

  if (!["pending_checkin", "in_progress"].includes(booking.status)) {
    throw new HttpError(400, "Host notification is only available for active bookings");
  }

  booking.safety.hostNotifiedAt = new Date();
  await booking.save({ validateBeforeSave: false });

  res.json({
    success: true,
    message: "Notification sent",
    detail: "The host has been notified and will review the situation. Check again in a few minutes.",
    booking: await presentBooking(booking),
  });
});

const checkInBooking = asyncHandler(async (req, res) => {
  const booking = await findOwnedBooking(req.user._id, req.params.id);
  const confirmationCode = cleanString(req.body.confirmationCode);
  const scannedParkingId = parseScannedParkingId(req.body.qrPayload || req.body.scannedCode || req.body.parkingQr);

  if (booking.status !== "pending_checkin") {
    throw new HttpError(400, "Booking is not ready for check-in");
  }

  if (confirmationCode && confirmationCode.toUpperCase() !== booking.confirmationCode) {
    throw new HttpError(400, "Invalid check-in code");
  }

  if (!scannedParkingId) {
    throw new HttpError(400, "Parking QR code is required for check-in");
  }

  if (scannedParkingId !== booking.parking.toString()) {
    throw new HttpError(400, "This QR code does not match your booking parking");
  }

  booking.status = "in_progress";
  booking.checkedInAt = new Date();
  await booking.save();

  res.json({
    success: true,
    message: "Check-in successful",
    booking: await presentBooking(booking, { includeQr: true }),
  });
});

function validateAdditionalHours(value, maxHours) {
  const additionalHours = Number(value || 1);

  if (!Number.isFinite(additionalHours) || additionalHours < 1 || additionalHours > maxHours) {
    throw new HttpError(400, `Additional hours must be between 1 and ${maxHours}`);
  }

  return additionalHours;
}

async function getParkingForBooking(booking) {
  const parking = await Parking.findById(booking.parking);

  if (!parking) {
    throw new HttpError(404, "Parking lot not found");
  }

  return parking;
}

const getExtensionOptions = asyncHandler(async (req, res) => {
  const booking = await findOwnedBooking(req.user._id, req.params.id);

  if (booking.status !== "in_progress") {
    throw new HttpError(400, "Only active parking sessions can be extended");
  }

  const parking = await getParkingForBooking(booking);
  const maxHours = parking.bookingSettings.maxExtensionHours;
  const options = Array.from({ length: maxHours }, (_, index) => {
    const hours = index + 1;
    const quote = calculateExtensionPricing(parking, hours);

    return {
      hours,
      label: formatDuration(hours),
      total: quote.total,
      displayTotal: formatMoney(quote.total, quote.currencySymbol),
    };
  });

  res.json({
    success: true,
    message: `Parking space is available. You can extend up to ${maxHours} hours.`,
    maxExtensionHours: maxHours,
    options,
  });
});

const quoteExtension = asyncHandler(async (req, res) => {
  const booking = await findOwnedBooking(req.user._id, req.params.id);

  if (booking.status !== "in_progress") {
    throw new HttpError(400, "Only active parking sessions can be extended");
  }

  const parking = await getParkingForBooking(booking);
  const additionalHours = validateAdditionalHours(req.body.additionalHours, parking.bookingSettings.maxExtensionHours);
  const quote = calculateExtensionPricing(parking, additionalHours);

  res.json({
    success: true,
    message: "Extension quote calculated",
    quote: {
      ...quote,
      displayTotal: formatMoney(quote.total, quote.currencySymbol),
      lineItems: [
        {
          label: `Extension (${formatDuration(additionalHours)})`,
          amount: quote.subtotal,
          displayAmount: formatMoney(quote.subtotal, quote.currencySymbol),
        },
        {
          label: `Tax (${Math.round(parking.rate.taxRate * 100)}%)`,
          amount: quote.taxAmount,
          displayAmount: formatMoney(quote.taxAmount, quote.currencySymbol),
        },
        {
          label: "Service fee",
          amount: quote.serviceFee,
          displayAmount: formatMoney(quote.serviceFee, quote.currencySymbol),
        },
      ],
    },
  });
});

const extendBooking = asyncHandler(async (req, res) => {
  const booking = await findOwnedBooking(req.user._id, req.params.id);

  if (booking.status !== "in_progress") {
    throw new HttpError(400, "Only active parking sessions can be extended");
  }

  const parking = await getParkingForBooking(booking);
  const additionalHours = validateAdditionalHours(req.body.additionalHours, parking.bookingSettings.maxExtensionHours);
  const quote = calculateExtensionPricing(parking, additionalHours);
  const paymentMethod = normalizePaymentMethod(req.body.paymentMethod || (req.body.payment && req.body.payment.method));

  if (!["card", "cash"].includes(paymentMethod)) {
    throw new HttpError(400, "Payment method must be card or cash");
  }

  booking.durationHours += additionalHours;
  booking.endAt = new Date(booking.endAt.getTime() + additionalHours * 60 * 60 * 1000);
  booking.pricing.extensionSubtotal = roundMoney(booking.pricing.extensionSubtotal + quote.subtotal);
  booking.pricing.taxAmount = roundMoney(booking.pricing.taxAmount + quote.taxAmount);
  booking.pricing.serviceFee = roundMoney(booking.pricing.serviceFee + quote.serviceFee);
  booking.pricing.total = roundMoney(booking.pricing.total + quote.total);
  booking.pricing.paidTotal =
    paymentMethod === "cash" ? booking.pricing.paidTotal : roundMoney(booking.pricing.paidTotal + quote.total);
  booking.extensions.push({
    hours: additionalHours,
    subtotal: quote.subtotal,
    taxAmount: quote.taxAmount,
    serviceFee: quote.serviceFee,
    total: quote.total,
    paymentMethod,
    status: paymentMethod === "cash" ? "cash_due" : "paid",
  });
  booking.qrPayload = buildQrPayload(booking);
  await booking.save();

  res.json({
    success: true,
    message: "Parking time extended",
    chargedAmount: paymentMethod === "cash" ? 0 : quote.total,
    displayChargedAmount: formatMoney(paymentMethod === "cash" ? 0 : quote.total, quote.currencySymbol),
    booking: await presentBooking(booking, { includeQr: true }),
  });
});

const checkOutBooking = asyncHandler(async (req, res) => {
  const booking = await findOwnedBooking(req.user._id, req.params.id);

  if (booking.status !== "in_progress") {
    throw new HttpError(400, "Booking is not currently in parking");
  }

  booking.status = "completed";
  booking.checkedOutAt = new Date();
  await booking.save();
  const parking = await Parking.findById(booking.parking);
  if (parking) {
    const occupied = (parking.occupancy?.occupiedSpaces || []).map(String);
    parking.occupancy = {
      ...(parking.occupancy?.toObject ? parking.occupancy.toObject() : parking.occupancy || {}),
      occupiedSpaces: occupied.slice(1),
    };
    parking.availability.availableSpaces = Math.min(
      (parking.availability.availableSpaces || 0) + 1,
      parking.availability.totalSpaces || occupied.length,
    );
    await parking.save();
  }

  res.json({
    success: true,
    message: "Check-out successful",
    totalCharged: booking.pricing.paidTotal,
    displayTotalCharged: formatMoney(booking.pricing.paidTotal, booking.pricing.currencySymbol),
    booking: await presentBooking(booking),
  });
});

const getDirections = asyncHandler(async (req, res) => {
  const booking = await findOwnedBooking(req.user._id, req.params.id);
  const coordinates = booking.parkingSnapshot.coordinates;

  if (
    !coordinates ||
    typeof coordinates.latitude !== "number" ||
    typeof coordinates.longitude !== "number"
  ) {
    throw new HttpError(404, "Directions are not available for this booking");
  }

  const destination = `${coordinates.latitude},${coordinates.longitude}`;
  const name = encodeURIComponent(booking.parkingSnapshot.name);

  res.json({
    success: true,
    message: "Directions generated",
    destination: {
      name: booking.parkingSnapshot.name,
      address: booking.parkingSnapshot.address,
      coordinates,
    },
    apps: [
      {
        code: "google_maps",
        label: "Google Maps",
        description: "Open with Google Maps",
        url: `https://www.google.com/maps/search/?api=1&query=${destination}`,
      },
      {
        code: "apple_maps",
        label: "Apple Maps",
        description: "Open with Apple Maps",
        url: `https://maps.apple.com/?daddr=${destination}&q=${name}`,
      },
      {
        code: "waze",
        label: "Waze",
        description: "Open with Waze",
        url: `https://waze.com/ul?ll=${destination}&navigate=yes`,
      },
    ],
  });
});

module.exports = {
  checkInBooking,
  checkOutBooking,
  createBooking,
  createPaymentIntent,
  extendBooking,
  getBooking,
  getDirections,
  getExtensionOptions,
  listBookings,
  notifyHost,
  quoteBooking,
  quoteExtension,
  safetyCheck,
};
