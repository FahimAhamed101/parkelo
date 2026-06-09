const mongoose = require("mongoose");

const Booking = require("../models/Booking");
const HostBankAccount = require("../models/HostBankAccount");
const HostWithdrawal = require("../models/HostWithdrawal");
const Parking = require("../models/Parking");
const { HttpError } = require("../utils/httpError");
const { formatMoney, roundMoney } = require("../utils/pricing");

const serviceLabels = {
  covered: "Covered",
  camera: "Cameras",
  cameras: "Cameras",
  open_24_7: "24/7",
  controlled_access: "Controlled access",
  easy_access: "Controlled access",
  attendant: "Staff",
  staff: "Staff",
  ev_charging: "EV charging",
  valet: "Valet",
  private: "Private",
  wifi: "Wi-Fi",
  accessible: "Accessible",
  motorcycles: "Motorcycles",
  motorcycle: "Motorcycles",
  bathrooms: "Bathrooms",
};

const bankOptions = [
  "Banco Popular",
  "BanReservas",
  "BHD Leon",
  "Banco Santa Cruz",
  "Scotiabank",
  "APAP",
  "Bancamerica",
  "Banesco",
];

function asyncHandler(handler) {
  return (req, res, next) => Promise.resolve(handler(req, res, next)).catch(next);
}

function cleanString(value) {
  return typeof value === "string" ? value.trim() : undefined;
}

function isEnabled(value) {
  return value === true || value === "true" || value === 1 || value === "1";
}

function toNumber(value, fallback = 0) {
  const number = Number(value);
  return Number.isFinite(number) ? number : fallback;
}

function slugify(value) {
  return String(value || "parking")
    .toLowerCase()
    .normalize("NFKD")
    .replace(/[\u0300-\u036f]/g, "")
    .replace(/[^a-z0-9]+/g, "-")
    .replace(/^-+|-+$/g, "")
    .slice(0, 70) || "parking";
}

function generateInviteCode(user) {
  const namePart = slugify(`${user.firstName || "host"}-${user.lastName || ""}`)
    .replace(/-/g, "")
    .slice(0, 4)
    .toUpperCase()
    .padEnd(4, "X");
  const randomPart = Math.random().toString(36).slice(2, 6).toUpperCase();
  return `${namePart}-${randomPart}`;
}

function generateHostCode() {
  const randomPart = Math.random().toString(36).slice(2, 6).toUpperCase();
  return `HOST-${randomPart}`;
}

async function ensureHostProfile(user) {
  if (user.role === "user") {
    user.role = "host";
  }

  user.hostProfile = {
    ...(user.hostProfile?.toObject ? user.hostProfile.toObject() : user.hostProfile || {}),
    onboardingCompleted: true,
    inviteCode: user.hostProfile?.inviteCode || generateInviteCode(user),
    inviteRewardAmount: user.hostProfile?.inviteRewardAmount || 500,
    defaultReservationMode: user.hostProfile?.defaultReservationMode || "automatic",
  };

  await user.save({ validateBeforeSave: false });
  return user.hostProfile;
}

function getCoordinates(body) {
  const latitude = toNumber(body.latitude ?? body.lat ?? body.location?.latitude ?? body.location?.lat, null);
  const longitude = toNumber(body.longitude ?? body.lng ?? body.location?.longitude ?? body.location?.lng, null);

  if (latitude === null || longitude === null) {
    return null;
  }

  return [longitude, latitude];
}

function normalizePhone(value) {
  const phone = cleanString(value);
  return phone ? phone.replace(/[^\d+]/g, "") : undefined;
}

function normalizeAccountType(value) {
  const accountType = cleanString(value)?.toLowerCase();

  if (["checking", "corriente", "current"].includes(accountType)) {
    return "checking";
  }

  if (["savings", "saving", "ahorro"].includes(accountType)) {
    return "savings";
  }

  return null;
}

function normalizeApprovalMode(value) {
  const mode = cleanString(value)?.toLowerCase();

  if (["manual", "host_approval", "host approval"].includes(mode)) {
    return "host_approval";
  }

  return "automatic";
}

function normalizeServiceCode(value) {
  const code = cleanString(value)
    ?.toLowerCase()
    .replace(/[\s-]+/g, "_");

  if (!code) {
    return null;
  }

  const aliases = {
    cameras: "camera",
    ctrl_access: "controlled_access",
    control_access: "controlled_access",
    personnel: "staff",
    person: "staff",
    charge_ev: "ev_charging",
    disabled: "accessible",
    motos: "motorcycles",
    motos_allowed: "motorcycles",
    bath: "bathrooms",
  };

  return aliases[code] || code;
}

function normalizeServices(value) {
  if (!value) {
    return [];
  }

  if (Array.isArray(value)) {
    return value
      .map((item) => {
        const code = normalizeServiceCode(typeof item === "string" ? item : item.code);
        return code ? { code, label: cleanString(item.label) || serviceLabels[code] || code } : null;
      })
      .filter(Boolean);
  }

  if (typeof value === "object") {
    return Object.entries(value)
      .filter(([, enabled]) => isEnabled(enabled))
      .map(([key]) => {
        const code = normalizeServiceCode(key);
        return code ? { code, label: serviceLabels[code] || code } : null;
      })
      .filter(Boolean);
  }

  return String(value)
    .split(",")
    .map(normalizeServiceCode)
    .filter(Boolean)
    .map((code) => ({ code, label: serviceLabels[code] || code }));
}

function normalizeImageList(value) {
  if (!value) {
    return [];
  }

  const values = Array.isArray(value) ? value : String(value).split(",");
  return values.map(cleanString).filter(Boolean);
}

function createSpaceIdentifiers(totalSpaces) {
  return Array.from({ length: totalSpaces }, (_, index) => String(index + 1));
}

function buildDefaultSections(totalSpaces, floors, parking) {
  const spaces = parking.spaceIdentifiers?.length
    ? parking.spaceIdentifiers
    : createSpaceIdentifiers(totalSpaces);

  return [
    {
      code: "A",
      name: floors > 1 ? "Ground Floor" : "Level 1",
      description: floors > 1 ? "Section A1 - A10" : "Section A",
      enabled: true,
      spaces,
      rate: {
        hourly: parking.rate.hourly || 150,
        daily: parking.rate.daily || 800,
        weekly: parking.rate.weekly || 4500,
      },
    },
  ];
}

function presentRate(rate = {}, currencySymbol = "RD$") {
  return {
    hourly: rate.hourly || 0,
    daily: rate.daily || 0,
    weekly: rate.weekly || 0,
    hourlyLabel: formatMoney(rate.hourly || 0, currencySymbol),
    dailyLabel: formatMoney(rate.daily || 0, currencySymbol),
    weeklyLabel: formatMoney(rate.weekly || 0, currencySymbol),
  };
}

function getCompletedSteps(parking) {
  return {
    location: Boolean(parking.name && parking.zone && parking.address?.line1 && parking.location?.coordinates?.length === 2),
    details: Boolean(parking.parkingType && parking.availability?.totalSpaces > 0 && parking.description),
    spaces: Boolean(parking.spaceIdentifiers?.length),
    services: Boolean(parking.services?.length),
    photos: Boolean(parking.media?.heroImageUrl || parking.media?.gallery?.length),
  };
}

function presentHostParking(parking) {
  const completedSteps = getCompletedSteps(parking);
  const completedCount = Object.values(completedSteps).filter(Boolean).length;
  const status = parking.submission?.status || "draft";
  const coordinates = parking.location?.coordinates || [];
  const currencySymbol = parking.rate?.currencySymbol || "RD$";

  return {
    id: parking._id.toString(),
    code: parking.hostCode || parking.slug,
    name: parking.name,
    slug: parking.slug,
    description: parking.description || "",
    status: parking.status,
    submissionStatus: status,
    submissionLabel: {
      draft: "Draft",
      under_review: "Under review",
      approved: "Approved",
      rejected: "Rejected",
    }[status] || status,
    review: {
      submittedAt: parking.submission?.submittedAt || null,
      estimatedReviewHours: parking.submission?.estimatedReviewHours || 2,
      note: parking.submission?.reviewNote || null,
    },
    zone: parking.zone,
    sector: parking.sector || null,
    address: parking.address,
    coordinates: coordinates.length === 2
      ? { longitude: coordinates[0], latitude: coordinates[1] }
      : null,
    parkingType: parking.parkingType || parking.accessType,
    approvalMode: parking.approvalMode,
    reservationMode: parking.approvalMode === "automatic" ? "automatic" : "manual",
    spaces: {
      total: parking.availability?.totalSpaces || 0,
      available: parking.availability?.availableSpaces || 0,
      floors: parking.availability?.floors || 1,
      identifiers: parking.spaceIdentifiers || [],
    },
    services: (parking.services || []).map((service) => ({
      code: service.code,
      label: service.label,
    })),
    rules: parking.rules?.safetyNotice || "",
    pricing: {
      mode: parking.pricingMode || "global",
      global: presentRate(parking.rate, currencySymbol),
      dynamicPricing: parking.dynamicPricing,
      overtime: parking.overtime,
      sections: (parking.sections || []).map((section) => ({
        id: section._id?.toString(),
        code: section.code,
        name: section.name,
        description: section.description,
        enabled: section.enabled,
        spaces: section.spaces,
        rate: presentRate(section.rate, currencySymbol),
      })),
    },
    media: parking.media,
    progress: {
      currentStep: parking.submission?.currentStep || 1,
      completedSteps,
      completedCount,
      totalSteps: 5,
      percent: Math.round((completedCount / 5) * 100),
    },
    createdAt: parking.createdAt,
    updatedAt: parking.updatedAt,
  };
}

function getOwnedParkingQuery(userId, parkingId) {
  if (!mongoose.Types.ObjectId.isValid(parkingId)) {
    throw new HttpError(404, "Host parking not found");
  }

  return { _id: parkingId, hostUser: userId };
}

async function findOwnedParking(userId, parkingId) {
  const parking = await Parking.findOne(getOwnedParkingQuery(userId, parkingId));

  if (!parking) {
    throw new HttpError(404, "Host parking not found");
  }

  return parking;
}

async function buildUniqueSlug(name, excludeId) {
  const base = slugify(name);
  let slug = base;
  let index = 2;

  while (await Parking.exists({ slug, ...(excludeId ? { _id: { $ne: excludeId } } : {}) })) {
    slug = `${base}-${index}`;
    index += 1;
  }

  return slug;
}

async function getHostParkingIds(userId) {
  const parkings = await Parking.find({ hostUser: userId }).select("_id");
  return parkings.map((parking) => parking._id);
}

function getStartOfDay(date = new Date()) {
  return new Date(date.getFullYear(), date.getMonth(), date.getDate());
}

function getStartOfMonth(date = new Date()) {
  return new Date(date.getFullYear(), date.getMonth(), 1);
}

function sumBookings(bookings, selector = () => true) {
  return roundMoney(
    bookings.reduce((sum, booking) => (selector(booking) ? sum + (booking.pricing?.paidTotal || 0) : sum), 0),
  );
}

async function getHostFinancials(userId) {
  const parkingIds = await getHostParkingIds(userId);

  if (!parkingIds.length) {
    return {
      parkingIds,
      bookings: [],
      totals: {
        availableForWithdrawal: 0,
        pendingToClear: 0,
        withdrawnThisMonth: 0,
        revenueThisMonth: 0,
        revenueToday: 0,
      },
    };
  }

  const now = new Date();
  const startOfDay = getStartOfDay(now);
  const startOfMonth = getStartOfMonth(now);
  const [bookings, withdrawals] = await Promise.all([
    Booking.find({ parking: { $in: parkingIds } }).sort({ createdAt: -1 }),
    HostWithdrawal.find({ user: userId }).sort({ requestedAt: -1 }),
  ]);
  const withdrawnTotal = roundMoney(
    withdrawals
      .filter((withdrawal) => ["requested", "processing", "paid"].includes(withdrawal.status))
      .reduce((sum, withdrawal) => sum + withdrawal.amount, 0),
  );
  const withdrawnThisMonth = roundMoney(
    withdrawals
      .filter((withdrawal) => withdrawal.requestedAt >= startOfMonth && withdrawal.status !== "cancelled")
      .reduce((sum, withdrawal) => sum + withdrawal.amount, 0),
  );
  const completedRevenue = sumBookings(bookings, (booking) => booking.status === "completed");
  const pendingToClear = sumBookings(bookings, (booking) =>
    ["pending_checkin", "in_progress", "pending_host_approval"].includes(booking.status),
  );
  const revenueThisMonth = sumBookings(bookings, (booking) => booking.createdAt >= startOfMonth);
  const revenueToday = sumBookings(bookings, (booking) => booking.createdAt >= startOfDay);

  return {
    parkingIds,
    bookings,
    withdrawals,
    totals: {
      availableForWithdrawal: Math.max(roundMoney(completedRevenue - withdrawnTotal), 0),
      pendingToClear,
      withdrawnThisMonth,
      revenueThisMonth,
      revenueToday,
    },
  };
}

function buildHourlyChart(bookings) {
  const buckets = ["6am", "9am", "12pm", "3pm", "6pm", "9pm"];
  const values = Object.fromEntries(buckets.map((bucket) => [bucket, 0]));

  for (const booking of bookings) {
    const hour = new Date(booking.startAt || booking.createdAt).getHours();
    if (hour < 9) values["6am"] += 1;
    else if (hour < 12) values["9am"] += 1;
    else if (hour < 15) values["12pm"] += 1;
    else if (hour < 18) values["3pm"] += 1;
    else if (hour < 21) values["6pm"] += 1;
    else values["9pm"] += 1;
  }

  return buckets.map((label) => ({ label, bookings: values[label] }));
}

function presentBankAccount(account) {
  if (!account) {
    return null;
  }

  return {
    id: account._id.toString(),
    bankName: account.bankName,
    accountType: account.accountType,
    accountNumberMasked: `****${account.accountNumberLast4}`,
    accountHolderName: account.accountHolderName,
    identityDocument: account.identityDocument,
    status: account.status,
    updatedAt: account.updatedAt,
  };
}

function presentWithdrawal(withdrawal) {
  return {
    id: withdrawal._id.toString(),
    amount: withdrawal.amount,
    amountLabel: formatMoney(withdrawal.amount, withdrawal.currencySymbol),
    currency: withdrawal.currency,
    status: withdrawal.status,
    requestedAt: withdrawal.requestedAt,
    processedAt: withdrawal.processedAt || null,
  };
}

function formatTimeAgo(date) {
  const value = new Date(date);
  const diffMinutes = Math.max(Math.round((Date.now() - value.getTime()) / 60000), 0);

  if (diffMinutes < 1) {
    return "just now";
  }

  if (diffMinutes < 60) {
    return `${diffMinutes} min ago`;
  }

  const diffHours = Math.round(diffMinutes / 60);

  if (diffHours < 24) {
    return `${diffHours}h ago`;
  }

  const diffDays = Math.round(diffHours / 24);
  return diffDays === 1 ? "1 day ago" : `${diffDays} days ago`;
}

function buildHostAlert(booking) {
  const createdAt = booking.createdAt || booking.updatedAt || new Date();
  const parkingName = booking.parkingSnapshot?.name || "parking";

  if (booking.status === "pending_host_approval") {
    return {
      id: `${booking._id.toString()}-request`,
      type: "request",
      severity: "info",
      message: `New private request - ${booking.vehiclePlate || booking.confirmationCode}`,
      time: formatTimeAgo(createdAt),
      createdAt,
    };
  }

  if (booking.status === "pending_checkin") {
    return {
      id: `${booking._id.toString()}-confirmed`,
      type: "booking",
      severity: "success",
      message: `Booking confirmed - ${booking.confirmationCode} - ${booking.arrivalTime}`,
      time: formatTimeAgo(createdAt),
      createdAt,
    };
  }

  if (booking.status === "in_progress") {
    const endAt = booking.endAt ? new Date(booking.endAt) : null;
    const overtimeMinutes = endAt ? Math.max(Math.round((Date.now() - endAt.getTime()) / 60000), 0) : 0;

    if (overtimeMinutes > 0) {
      return {
        id: `${booking._id.toString()}-overtime`,
        type: "overtime",
        severity: "warning",
        message: `Overtime detected - ${booking.parkingSnapshot?.slug || parkingName} (+${overtimeMinutes} min)`,
        time: formatTimeAgo(endAt || createdAt),
        createdAt: endAt || createdAt,
      };
    }
  }

  if (booking.status === "completed") {
    return {
      id: `${booking._id.toString()}-completed`,
      type: "booking",
      severity: "success",
      message: `User ${booking.vehiclePlate || booking.confirmationCode} finished their time in ${parkingName}`,
      time: formatTimeAgo(createdAt),
      createdAt,
    };
  }

  return {
    id: booking._id.toString(),
    type: "booking",
    severity: "info",
    message: `${booking.confirmationCode} - ${parkingName}`,
    time: formatTimeAgo(createdAt),
    createdAt,
  };
}

async function getHostParkingQuery(userId) {
  return Parking.find({ hostUser: userId }).select("_id name slug hostCode");
}

async function getHostParkingBookings(userId, filter = {}) {
  const parkings = await getHostParkingQuery(userId);
  const parkingIds = parkings.map((parking) => parking._id);

  if (!parkingIds.length) {
    return [];
  }

  return Booking.find({ parking: { $in: parkingIds }, ...filter }).sort({ createdAt: -1 });
}

const getHostSummary = asyncHandler(async (req, res) => {
  const parkings = await Parking.find({ hostUser: req.user._id }).sort({ createdAt: -1 });

  res.json({
    success: true,
    host: {
      isHost: req.user.role === "host" || req.user.role === "admin",
      onboardingCompleted: Boolean(req.user.hostProfile?.onboardingCompleted),
      inviteCode: req.user.hostProfile?.inviteCode || null,
      inviteRewardAmount: req.user.hostProfile?.inviteRewardAmount || 500,
    },
    primaryAction: parkings.length ? "Open host panel" : "Add my parking",
    parkings: parkings.map(presentHostParking),
  });
});

const getHostAlerts = asyncHandler(async (req, res) => {
  const bookings = await getHostParkingBookings(req.user._id);
  const alerts = bookings
    .map(buildHostAlert)
    .filter(Boolean)
    .sort((left, right) => new Date(right.createdAt) - new Date(left.createdAt))
    .slice(0, 12);

  res.json({
    success: true,
    unreadCount: alerts.length,
    alerts,
  });
});

const getManualRequests = asyncHandler(async (req, res) => {
  const bookings = await getHostParkingBookings(req.user._id, { status: "pending_host_approval" });

  res.json({
    success: true,
    total: bookings.length,
    requests: bookings.map((booking) => ({
      id: booking._id.toString(),
      bookingId: booking._id.toString(),
      confirmationCode: booking.confirmationCode,
      vehiclePlate: booking.vehiclePlate,
      parkingName: booking.parkingSnapshot?.name || "Parking",
      message: `A driver requested to reserve ${booking.parkingSnapshot?.name || "your parking"}.`,
      time: formatTimeAgo(booking.createdAt),
      createdAt: booking.createdAt,
      actions: {
        canApprove: true,
        canDecline: true,
      },
    })),
  });
});

const getParkingQr = asyncHandler(async (req, res) => {
  const parking = await findOwnedParking(req.user._id, req.params.id);
  const payload = JSON.stringify({
    type: "parkealo_host_parking",
    parkingId: parking._id.toString(),
    code: parking.hostCode || parking.slug,
    name: parking.name,
  });

  const dataUrl = await require("qrcode").toDataURL(payload, {
    margin: 1,
    width: 280,
  });

  res.json({
    success: true,
    qr: {
      payload,
      dataUrl,
      label: parking.name,
      code: parking.hostCode || parking.slug,
    },
  });
});

const approveManualRequest = asyncHandler(async (req, res) => {
  const booking = await Booking.findById(req.params.bookingId);

  if (!booking) {
    throw new HttpError(404, "Booking not found");
  }

  const parking = await Parking.findOne({ _id: booking.parking, hostUser: req.user._id });

  if (!parking) {
    throw new HttpError(404, "Host parking not found");
  }

  if (booking.status !== "pending_host_approval") {
    throw new HttpError(400, "Only pending requests can be approved");
  }

  if ((parking.availability?.availableSpaces || 0) <= 0) {
    throw new HttpError(409, "No parking spaces are currently available");
  }

  booking.status = "pending_checkin";
  booking.approvalMode = "host_approval";
  booking.updatedAt = new Date();
  parking.availability.availableSpaces = Math.max((parking.availability.availableSpaces || 0) - 1, 0);

  await Promise.all([booking.save(), parking.save()]);

  res.json({
    success: true,
    message: "Request approved",
    booking: {
      id: booking._id.toString(),
      confirmationCode: booking.confirmationCode,
      status: booking.status,
    },
  });
});

const declineManualRequest = asyncHandler(async (req, res) => {
  const booking = await Booking.findById(req.params.bookingId);

  if (!booking) {
    throw new HttpError(404, "Booking not found");
  }

  const parking = await Parking.findOne({ _id: booking.parking, hostUser: req.user._id });

  if (!parking) {
    throw new HttpError(404, "Host parking not found");
  }

  if (booking.status !== "pending_host_approval") {
    throw new HttpError(400, "Only pending requests can be declined");
  }

  booking.status = "declined";
  booking.updatedAt = new Date();
  await booking.save();

  res.json({
    success: true,
    message: "Request declined",
    booking: {
      id: booking._id.toString(),
      confirmationCode: booking.confirmationCode,
      status: booking.status,
    },
  });
});

const startOnboarding = asyncHandler(async (req, res) => {
  const profile = await ensureHostProfile(req.user);

  res.json({
    success: true,
    message: "Host onboarding started",
    host: {
      role: req.user.role,
      onboardingCompleted: profile.onboardingCompleted,
      inviteCode: profile.inviteCode,
      inviteRewardAmount: profile.inviteRewardAmount,
    },
  });
});

const getHostOptions = asyncHandler(async (req, res) => {
  res.json({
    success: true,
    options: {
      sectors: ["Colonial Zone", "Downtown", "Piantini", "Naco", "Gazcue"],
      parkingTypes: [
        { code: "public", label: "Public", description: "Anyone can reserve" },
        { code: "private", label: "Private", description: "Only selected users can reserve" },
      ],
      services: Object.entries(serviceLabels).map(([code, label]) => ({ code, label })),
      reservationModes: [
        { code: "automatic", label: "Automatic confirmation" },
        { code: "manual", label: "Manual approval" },
      ],
      banks: bankOptions,
      accountTypes: [
        { code: "checking", label: "Checking" },
        { code: "savings", label: "Savings" },
      ],
      overtimeMultipliers: [1, 1.5, 2, 2.5],
    },
  });
});

const listHostParkings = asyncHandler(async (req, res) => {
  const parkings = await Parking.find({ hostUser: req.user._id }).sort({ createdAt: -1 });

  res.json({
    success: true,
    total: parkings.length,
    parkings: parkings.map(presentHostParking),
  });
});

const createHostParking = asyncHandler(async (req, res) => {
  await ensureHostProfile(req.user);

  const name = cleanString(req.body.name || req.body.parkingName || req.body.hostName) || "Untitled parking";
  const slug = await buildUniqueSlug(name);
  const totalSpaces = Math.max(toNumber(req.body.totalSpaces || req.body.spacesCount, 10), 1);
  const coordinates = getCoordinates(req.body) || [0, 0];
  const zone = cleanString(req.body.zone || req.body.sector) || "Unassigned zone";
  const parking = await Parking.create({
    hostUser: req.user._id,
    hostCode: generateHostCode(),
    name,
    slug,
    description: cleanString(req.body.description) || "",
    zone,
    sector: cleanString(req.body.sector) || zone,
    address: {
      line1: cleanString(req.body.addressLine || req.body.address?.line1) || "Address pending",
      line2: cleanString(req.body.address?.line2),
      city: cleanString(req.body.city || req.body.address?.city) || "Santo Domingo",
      state: cleanString(req.body.state || req.body.address?.state) || "Distrito Nacional",
      country: cleanString(req.body.country || req.body.address?.country) || "Dominican Republic",
    },
    location: {
      type: "Point",
      coordinates,
    },
    accessType: "public",
    parkingType: "public",
    approvalMode: "automatic",
    rate: {
      hourly: toNumber(req.body.hourlyRate, 150),
      daily: toNumber(req.body.dailyRate, 800),
      weekly: toNumber(req.body.weeklyRate, 4500),
      currency: "DOP",
      currencySymbol: "RD$",
      serviceFee: 25,
      taxRate: 0.18,
    },
    availability: {
      totalSpaces,
      availableSpaces: totalSpaces,
      floors: Math.max(toNumber(req.body.floors, 1), 1),
      assignedAtArrival: true,
    },
    host: {
      name,
      verified: false,
      verifiedReservations: 0,
      responseTimeMinutes: 10,
      contactPhone: normalizePhone(req.body.contactPhone || req.user.phoneNumber),
      instagram: cleanString(req.body.instagram),
    },
    spaceIdentifiers: createSpaceIdentifiers(totalSpaces),
    submission: {
      status: "draft",
      currentStep: 1,
    },
    status: "draft",
  });

  parking.sections = buildDefaultSections(totalSpaces, parking.availability.floors, parking);
  await parking.save({ validateBeforeSave: false });

  res.status(201).json({
    success: true,
    message: "Host parking draft created",
    parking: presentHostParking(parking),
  });
});

const getHostParking = asyncHandler(async (req, res) => {
  const parking = await findOwnedParking(req.user._id, req.params.id);

  res.json({
    success: true,
    parking: presentHostParking(parking),
  });
});

const updateLocationStep = asyncHandler(async (req, res) => {
  const parking = await findOwnedParking(req.user._id, req.params.id);
  const name = cleanString(req.body.name || req.body.parkingName || req.body.hostName);
  const coordinates = getCoordinates(req.body);

  if (name) {
    parking.name = name;
    parking.slug = await buildUniqueSlug(name, parking._id);
    parking.host.name = name;
  }

  if (coordinates) {
    parking.location = { type: "Point", coordinates };
  }

  parking.zone = cleanString(req.body.zone || req.body.sector) || parking.zone;
  parking.sector = cleanString(req.body.sector) || parking.sector || parking.zone;
  parking.address = {
    ...parking.address.toObject?.() || parking.address,
    line1: cleanString(req.body.addressLine || req.body.address?.line1) || parking.address.line1,
    line2: cleanString(req.body.address?.line2) || parking.address.line2,
    city: cleanString(req.body.city || req.body.address?.city) || parking.address.city,
    state: cleanString(req.body.state || req.body.address?.state) || parking.address.state,
    country: cleanString(req.body.country || req.body.address?.country) || parking.address.country,
    postalCode: cleanString(req.body.postalCode || req.body.address?.postalCode) || parking.address.postalCode,
  };
  parking.host.contactPhone = normalizePhone(req.body.contactPhone) || parking.host.contactPhone;
  parking.host.instagram = cleanString(req.body.instagram) || parking.host.instagram;
  parking.submission.currentStep = Math.max(parking.submission.currentStep || 1, 2);
  await parking.save();

  res.json({
    success: true,
    message: "Location step saved",
    parking: presentHostParking(parking),
  });
});

const updateDetailsStep = asyncHandler(async (req, res) => {
  const parking = await findOwnedParking(req.user._id, req.params.id);
  const totalSpaces = Math.max(toNumber(req.body.totalSpaces || req.body.spacesCount, parking.availability.totalSpaces), 1);
  const floors = Math.max(toNumber(req.body.floors || req.body.levels, parking.availability.floors), 1);

  parking.parkingType = cleanString(req.body.parkingType || req.body.accessType) === "private" ? "private" : "public";
  parking.accessType = parking.parkingType;
  parking.description = cleanString(req.body.description) || parking.description;
  parking.rules.safetyNotice = cleanString(req.body.rules || req.body.parkingRules) || parking.rules.safetyNotice;
  parking.availability.totalSpaces = totalSpaces;
  parking.availability.availableSpaces = Math.min(parking.availability.availableSpaces || totalSpaces, totalSpaces);
  parking.availability.floors = floors;

  if (isEnabled(req.body.open24Hours) || req.body.scheduleMode === "24_7") {
    parking.services = [
      ...parking.services.filter((service) => service.code !== "open_24_7"),
      { code: "open_24_7", label: "24/7" },
    ];
  } else if (req.body.open24Hours !== undefined || req.body.scheduleMode) {
    parking.services = parking.services.filter((service) => service.code !== "open_24_7");
  }

  if (!parking.spaceIdentifiers?.length || parking.spaceIdentifiers.length !== totalSpaces) {
    parking.spaceIdentifiers = createSpaceIdentifiers(totalSpaces);
  }

  if (!parking.sections?.length) {
    parking.sections = buildDefaultSections(totalSpaces, floors, parking);
  }

  parking.submission.currentStep = Math.max(parking.submission.currentStep || 1, 3);
  await parking.save();

  res.json({
    success: true,
    message: "Details step saved",
    parking: presentHostParking(parking),
  });
});

const updateSpacesStep = asyncHandler(async (req, res) => {
  const parking = await findOwnedParking(req.user._id, req.params.id);
  const identifiers = Array.isArray(req.body.identifiers || req.body.spaces)
    ? (req.body.identifiers || req.body.spaces).map(cleanString).filter(Boolean)
    : createSpaceIdentifiers(toNumber(req.body.totalSpaces, parking.availability.totalSpaces));

  if (!identifiers.length) {
    throw new HttpError(400, "At least one parking space is required");
  }

  parking.spaceIdentifiers = identifiers;
  parking.availability.totalSpaces = identifiers.length;
  parking.availability.availableSpaces = Math.min(parking.availability.availableSpaces || identifiers.length, identifiers.length);
  parking.availability.floors = Math.max(toNumber(req.body.floors || req.body.levels, parking.availability.floors), 1);

  if (!parking.sections?.length) {
    parking.sections = buildDefaultSections(identifiers.length, parking.availability.floors, parking);
  } else {
    parking.sections[0].spaces = identifiers;
  }

  parking.submission.currentStep = Math.max(parking.submission.currentStep || 1, 4);
  await parking.save();

  res.json({
    success: true,
    message: "Spaces step saved",
    parking: presentHostParking(parking),
  });
});

const updateServicesStep = asyncHandler(async (req, res) => {
  const parking = await findOwnedParking(req.user._id, req.params.id);

  parking.services = normalizeServices(req.body.services);
  parking.submission.currentStep = Math.max(parking.submission.currentStep || 1, 5);
  await parking.save();

  res.json({
    success: true,
    message: "Services step saved",
    parking: presentHostParking(parking),
  });
});

const updatePhotosStep = asyncHandler(async (req, res) => {
  const parking = await findOwnedParking(req.user._id, req.params.id);
  const gallery = normalizeImageList(req.body.gallery || req.body.photos);
  const heroImageUrl = cleanString(req.body.heroImageUrl || req.body.mainPhoto) || gallery[0] || parking.media.heroImageUrl;

  parking.media.heroImageUrl = heroImageUrl;
  parking.media.thumbnailUrl = cleanString(req.body.thumbnailUrl) || heroImageUrl || parking.media.thumbnailUrl;
  parking.media.gallery = gallery.length ? gallery : parking.media.gallery;
  parking.submission.currentStep = Math.max(parking.submission.currentStep || 1, 6);
  await parking.save();

  res.json({
    success: true,
    message: "Photos step saved",
    parking: presentHostParking(parking),
  });
});

const getReview = asyncHandler(async (req, res) => {
  const parking = await findOwnedParking(req.user._id, req.params.id);

  res.json({
    success: true,
    parking: presentHostParking(parking),
    next: {
      title: "What happens next?",
      items: [
        "The Parkealo team will review your parking in up to 2 hours.",
        "After approval, it will appear on the map and users can reserve it.",
        "You will receive booking notifications in the host panel.",
      ],
    },
  });
});

const submitParking = asyncHandler(async (req, res) => {
  const parking = await findOwnedParking(req.user._id, req.params.id);
  const completedSteps = getCompletedSteps(parking);
  const missingSteps = Object.entries(completedSteps)
    .filter(([, completed]) => !completed)
    .map(([step]) => step);

  if (missingSteps.length) {
    throw new HttpError(400, "Complete all required steps before submitting", { missingSteps });
  }

  parking.status = "under_review";
  parking.submission.status = "under_review";
  parking.submission.submittedAt = new Date();
  parking.submission.estimatedReviewHours = toNumber(req.body.estimatedReviewHours, 2);
  req.user.hostProfile = {
    ...(req.user.hostProfile?.toObject ? req.user.hostProfile.toObject() : req.user.hostProfile || {}),
    onboardingCompleted: true,
    firstParkingSubmitted: true,
    inviteCode: req.user.hostProfile?.inviteCode || generateInviteCode(req.user),
  };
  if (req.user.role === "user") {
    req.user.role = "host";
  }

  await Promise.all([
    parking.save(),
    req.user.save({ validateBeforeSave: false }),
  ]);

  res.json({
    success: true,
    message: "Parking submitted for review",
    parking: presentHostParking(parking),
    notice: {
      title: "Request sent",
      message: `${parking.name} is being reviewed by the Parkealo team.`,
      estimatedReviewHours: parking.submission.estimatedReviewHours,
      actionLabel: "Go to admin panel",
    },
  });
});

const getDashboard = asyncHandler(async (req, res) => {
  const parkings = await Parking.find({ hostUser: req.user._id }).sort({ createdAt: -1 });
  const financials = await getHostFinancials(req.user._id);
  const todayStart = getStartOfDay();
  const bookingsToday = financials.bookings.filter((booking) => booking.createdAt >= todayStart).length;
  const totalSpaces = parkings.reduce((sum, parking) => sum + (parking.availability?.totalSpaces || 0), 0);
  const availableSpaces = parkings.reduce((sum, parking) => sum + (parking.availability?.availableSpaces || 0), 0);
  const occupiedSpaces = Math.max(totalSpaces - availableSpaces, 0);
  const ratingValues = parkings.map((parking) => parking.rating?.average || 0).filter(Boolean);
  const rating = ratingValues.length
    ? roundMoney(ratingValues.reduce((sum, value) => sum + value, 0) / ratingValues.length)
    : 0;
  const primaryParking = parkings[0] || null;

  res.json({
    success: true,
    panel: {
      title: "Host panel",
      subtitle: primaryParking ? primaryParking.name : "Add your first parking",
      primaryParking: primaryParking ? presentHostParking(primaryParking) : null,
      stats: {
        incomeToday: financials.totals.revenueToday,
        incomeTodayLabel: formatMoney(financials.totals.revenueToday),
        occupancy: {
          occupied: occupiedSpaces,
          total: totalSpaces,
          label: totalSpaces ? `${occupiedSpaces} / ${totalSpaces}` : "0 / 0",
          percent: totalSpaces ? Math.round((occupiedSpaces / totalSpaces) * 100) : 0,
        },
        bookingsToday,
        rating,
      },
      reservationMode: {
        mode: primaryParking?.approvalMode === "host_approval" ? "manual" : "automatic",
        active: true,
        description: primaryParking?.approvalMode === "host_approval"
          ? "You approve each reservation before confirmation."
          : "Reservations are confirmed automatically.",
      },
      peakHourChart: buildHourlyChart(financials.bookings),
      invite: {
        code: req.user.hostProfile?.inviteCode || generateInviteCode(req.user),
        rewardAmount: req.user.hostProfile?.inviteRewardAmount || 500,
        message: "Invite other hosts and earn a reward for each first parking published.",
      },
    },
  });
});

const getIncome = asyncHandler(async (req, res) => {
  const financials = await getHostFinancials(req.user._id);
  const bankAccount = await HostBankAccount.findOne({ user: req.user._id });
  const movements = [
    ...financials.bookings.slice(0, 10).map((booking) => ({
      type: "booking",
      label: `Booking ${booking.confirmationCode}`,
      detail: booking.parkingSnapshot?.name || "Parking booking",
      amount: booking.pricing?.paidTotal || 0,
      amountLabel: `+${formatMoney(booking.pricing?.paidTotal || 0)}`,
      createdAt: booking.createdAt,
    })),
    ...(financials.withdrawals || []).slice(0, 10).map((withdrawal) => ({
      type: "withdrawal",
      label: "Withdrawal request",
      detail: withdrawal.status,
      amount: -withdrawal.amount,
      amountLabel: `-${formatMoney(withdrawal.amount, withdrawal.currencySymbol)}`,
      createdAt: withdrawal.requestedAt,
    })),
  ].sort((left, right) => new Date(right.createdAt) - new Date(left.createdAt)).slice(0, 10);

  res.json({
    success: true,
    income: {
      availableForWithdrawal: financials.totals.availableForWithdrawal,
      availableForWithdrawalLabel: formatMoney(financials.totals.availableForWithdrawal),
      pendingToClear: financials.totals.pendingToClear,
      pendingToClearLabel: formatMoney(financials.totals.pendingToClear),
      revenueThisMonth: financials.totals.revenueThisMonth,
      revenueThisMonthLabel: formatMoney(financials.totals.revenueThisMonth),
      withdrawnThisMonth: financials.totals.withdrawnThisMonth,
      withdrawnThisMonthLabel: formatMoney(financials.totals.withdrawnThisMonth),
      bookingsThisMonth: financials.bookings.filter((booking) => booking.createdAt >= getStartOfMonth()).length,
      bankAccount: presentBankAccount(bankAccount),
      movements,
      chart: buildHourlyChart(financials.bookings),
    },
  });
});

const getBankAccount = asyncHandler(async (req, res) => {
  const account = await HostBankAccount.findOne({ user: req.user._id });

  res.json({
    success: true,
    options: {
      banks: bankOptions,
      accountTypes: [
        { code: "checking", label: "Checking" },
        { code: "savings", label: "Savings" },
      ],
    },
    bankAccount: presentBankAccount(account),
  });
});

const saveBankAccount = asyncHandler(async (req, res) => {
  await ensureHostProfile(req.user);

  const bankName = cleanString(req.body.bankName || req.body.bank);
  const accountType = normalizeAccountType(req.body.accountType);
  const accountNumber = cleanString(req.body.accountNumber);
  const accountHolderName = cleanString(req.body.accountHolderName || req.body.holderName);
  const identityDocument = cleanString(req.body.identityDocument || req.body.documentId);

  if (!bankName || !bankOptions.includes(bankName)) {
    throw new HttpError(400, "Select a valid bank");
  }

  if (!accountType) {
    throw new HttpError(400, "Account type must be checking or savings");
  }

  if (!accountNumber || accountNumber.replace(/\D/g, "").length < 4) {
    throw new HttpError(400, "A valid account number is required");
  }

  if (!accountHolderName) {
    throw new HttpError(400, "Account holder name is required");
  }

  if (!identityDocument) {
    throw new HttpError(400, "Identity document is required");
  }

  const digits = accountNumber.replace(/\D/g, "");
  const account = await HostBankAccount.findOneAndUpdate(
    { user: req.user._id },
    {
      user: req.user._id,
      bankName,
      accountType,
      accountNumberLast4: digits.slice(-4),
      accountHolderName,
      identityDocument,
      status: "pending_verification",
    },
    { upsert: true, returnDocument: "after", runValidators: true },
  );

  res.json({
    success: true,
    message: "Withdrawal account saved",
    bankAccount: presentBankAccount(account),
  });
});

const requestWithdrawal = asyncHandler(async (req, res) => {
  const amount = roundMoney(req.body.amount);
  const [account, financials] = await Promise.all([
    HostBankAccount.findOne({ user: req.user._id }),
    getHostFinancials(req.user._id),
  ]);

  if (!account) {
    throw new HttpError(400, "Add a withdrawal account before requesting a withdrawal");
  }

  if (amount <= 0) {
    throw new HttpError(400, "Withdrawal amount must be greater than zero");
  }

  if (amount > financials.totals.availableForWithdrawal) {
    throw new HttpError(400, "Withdrawal amount exceeds available balance", {
      availableForWithdrawal: financials.totals.availableForWithdrawal,
    });
  }

  const withdrawal = await HostWithdrawal.create({
    user: req.user._id,
    bankAccount: account._id,
    amount,
    currency: "DOP",
    currencySymbol: "RD$",
  });

  res.status(201).json({
    success: true,
    message: "Withdrawal requested",
    withdrawal: presentWithdrawal(withdrawal),
  });
});

const getPricing = asyncHandler(async (req, res) => {
  const parking = await findOwnedParking(req.user._id, req.params.id);

  res.json({
    success: true,
    pricing: presentHostParking(parking).pricing,
  });
});

const savePricing = asyncHandler(async (req, res) => {
  const parking = await findOwnedParking(req.user._id, req.params.id);
  const currencySymbol = parking.rate.currencySymbol || "RD$";

  parking.pricingMode = cleanString(req.body.mode || req.body.pricingMode) === "per_section"
    ? "per_section"
    : "global";

  if (req.body.global || req.body.rate || req.body.hourlyRate !== undefined) {
    const globalRate = req.body.global || req.body.rate || req.body;
    parking.rate.hourly = roundMoney(globalRate.hourly - globalRate.hourlyRate - parking.rate.hourly);
    parking.rate.daily = roundMoney(globalRate.daily - globalRate.dailyRate - parking.rate.daily);
    parking.rate.weekly = roundMoney(globalRate.weekly - globalRate.weeklyRate - parking.rate.weekly);
  }

  if (req.body.dynamicPricing) {
    parking.dynamicPricing.enabled = isEnabled(req.body.dynamicPricing.enabled);
    parking.dynamicPricing.occupancyThresholdPercent = Math.min(
      Math.max(toNumber(req.body.dynamicPricing.occupancyThresholdPercent, parking.dynamicPricing.occupancyThresholdPercent), 1),
      100,
    );
    parking.dynamicPricing.peakIncreasePercent = Math.max(
      toNumber(req.body.dynamicPricing.peakIncreasePercent, parking.dynamicPricing.peakIncreasePercent),
      0,
    );
  }

  if (req.body.overtime) {
    parking.overtime.multiplier = Math.max(toNumber(req.body.overtime.multiplier, parking.overtime.multiplier), 1);
    parking.overtime.graceMinutes = Math.max(toNumber(req.body.overtime.graceMinutes, parking.overtime.graceMinutes), 0);
  } else if (req.body.overtimeMultiplier !== undefined) {
    parking.overtime.multiplier = Math.max(toNumber(req.body.overtimeMultiplier, parking.overtime.multiplier), 1);
  }

  if (Array.isArray(req.body.sections)) {
    parking.sections = req.body.sections.map((section, index) => ({
      code: cleanString(section.code) || String.fromCharCode(65 + index),
      name: cleanString(section.name) || `Section ${index + 1}`,
      description: cleanString(section.description),
      enabled: section.enabled === undefined ? true : isEnabled(section.enabled),
      spaces: Array.isArray(section.spaces) ? section.spaces.map(cleanString).filter(Boolean) : [],
      rate: {
        hourly: roundMoney(section.rate?.hourly - section.hourlyRate - parking.rate.hourly),
        daily: roundMoney(section.rate?.daily - section.dailyRate - parking.rate.daily),
        weekly: roundMoney(section.rate?.weekly - section.weeklyRate - parking.rate.weekly),
      },
    }));
  } else if (!parking.sections?.length) {
    parking.sections = buildDefaultSections(parking.availability.totalSpaces, parking.availability.floors, parking);
  }

  await parking.save();

  res.json({
    success: true,
    message: "Prices saved",
    pricing: {
      ...presentHostParking(parking).pricing,
      sampleOvertimeCharge: {
        description: "Example: 2 booked hours at the hourly rate, plus 30 extra minutes.",
        amount: roundMoney(parking.rate.hourly * 0.5 * parking.overtime.multiplier),
        amountLabel: formatMoney(parking.rate.hourly * 0.5 * parking.overtime.multiplier, currencySymbol),
      },
    },
  });
});

module.exports = {
  approveManualRequest,
  createHostParking,
  declineManualRequest,
  getBankAccount,
  getDashboard,
  getHostOptions,
  getHostAlerts,
  getHostParking,
  getParkingQr,
  getHostSummary,
  getIncome,
  getManualRequests,
  getPricing,
  getReview,
  listHostParkings,
  requestWithdrawal,
  saveBankAccount,
  savePricing,
  startOnboarding,
  submitParking,
  updateDetailsStep,
  updateLocationStep,
  updatePhotosStep,
  updateServicesStep,
  updateSpacesStep,
};

