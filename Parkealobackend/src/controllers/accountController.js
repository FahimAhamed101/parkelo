const crypto = require("crypto");
const validator = require("validator");

const PaymentMethod = require("../models/PaymentMethod");
const Referral = require("../models/Referral");
const SupportTicket = require("../models/SupportTicket");
const User = require("../models/User");
const Vehicle = require("../models/Vehicle");
const { HttpError } = require("../utils/httpError");
const { formatMoney } = require("../utils/pricing");
const { sanitizeUser } = require("../utils/tokens");

const vehicleTypes = [
  { code: "sedan", label: "Sedan" },
  { code: "suv_4x4", label: "SUV / 4x4" },
  { code: "pickup", label: "Pickup" },
  { code: "coupe", label: "Coupe" },
  { code: "minivan_van", label: "Minivan / Van" },
  { code: "motorcycle", label: "Motorcycle" },
];

const supportOptions = [
  {
    code: "chat",
    label: "Support chat",
    description: "Average response in 5 minutes",
  },
  {
    code: "complaint",
    label: "File a complaint",
    description: "Refunds and disputes",
  },
  {
    code: "email",
    label: "Send email",
    description: "support@parkealo.com",
  },
  {
    code: "support_call",
    label: "Call support",
    description: "+1 (809) 000-0000",
  },
  {
    code: "faq",
    label: "Frequently asked questions",
    description: "Help center",
  },
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

function normalizePhoneNumber(value) {
  const phoneNumber = cleanString(value);
  return phoneNumber ? phoneNumber.replace(/[^\d+]/g, "") : undefined;
}

function normalizePlate(value) {
  const plate = cleanString(value);
  return plate ? plate.toUpperCase().replace(/\s+/g, "") : undefined;
}

function normalizeVehicleType(value) {
  const type = cleanString(value)?.toLowerCase().replace(/[\s-]+/g, "_");

  if (type === "suv" || type === "4x4") {
    return "suv_4x4";
  }

  if (type === "minivan" || type === "van") {
    return "minivan_van";
  }

  return type;
}

function parseFullName(value) {
  const fullName = cleanString(value);

  if (!fullName) {
    return null;
  }

  const parts = fullName.split(/\s+/);
  return {
    firstName: parts.shift(),
    lastName: parts.join(" ") || "User",
  };
}

function generateReferralCode(user) {
  const namePart = `${user.firstName || "PARK"}${user.lastName || ""}`
    .replace(/[^a-z0-9]/gi, "")
    .slice(0, 4)
    .toUpperCase()
    .padEnd(4, "X");
  const randomPart = crypto.randomBytes(3).toString("hex").toUpperCase();
  return `PARK-${namePart}${randomPart}`.slice(0, 11);
}

async function ensureReferralProfile(user) {
  if (user.referralProfile?.code) {
    return user.referralProfile;
  }

  let code;
  let attempts = 0;

  do {
    code = generateReferralCode(user);
    attempts += 1;
  } while (attempts < 5 && (await User.exists({ "referralProfile.code": code })));

  user.referralProfile = {
    ...(user.referralProfile?.toObject ? user.referralProfile.toObject() : user.referralProfile || {}),
    code,
    earnedAmount: user.referralProfile?.earnedAmount || 0,
    referredCount: user.referralProfile?.referredCount || 0,
    rewardPerReferral: user.referralProfile?.rewardPerReferral || 50,
  };
  await user.save({ validateBeforeSave: false });
  return user.referralProfile;
}

function detectCardBrand(cardNumber) {
  const digits = String(cardNumber || "").replace(/\D/g, "");

  if (/^4/.test(digits)) return "visa";
  if (/^(5[1-5]|2[2-7])/.test(digits)) return "mastercard";
  if (/^3[47]/.test(digits)) return "amex";
  if (/^6(?:011|5)/.test(digits)) return "discover";
  return "unknown";
}

function getCardLast4(body) {
  const direct = cleanString(body.cardLast4);

  if (direct && /^\d{4}$/.test(direct)) {
    return direct;
  }

  const digits = String(body.cardNumber || "").replace(/\D/g, "");
  return digits.length >= 4 ? digits.slice(-4) : null;
}

function parseExpiry(body) {
  const expiry = cleanString(body.expiry || body.expiration);

  if (expiry) {
    const match = expiry.match(/^(\d{1,2})\s*\/\s*(\d{2}|\d{4})$/);

    if (match) {
      const month = Number(match[1]);
      const rawYear = Number(match[2]);
      return {
        expiryMonth: month,
        expiryYear: rawYear < 100 ? 2000 + rawYear : rawYear,
      };
    }
  }

  return {
    expiryMonth: Number(body.expiryMonth),
    expiryYear: Number(body.expiryYear),
  };
}

function presentVehicle(vehicle) {
  return {
    id: vehicle._id.toString(),
    type: vehicle.type,
    typeLabel: vehicleTypes.find((item) => item.code === vehicle.type)?.label || vehicle.type,
    plate: vehicle.plate,
    brand: vehicle.brand,
    model: vehicle.model,
    year: vehicle.year || null,
    color: vehicle.color || null,
    notes: vehicle.notes || "",
    isPrimary: vehicle.isPrimary,
    title: [vehicle.brand, vehicle.model].filter(Boolean).join(" "),
    subtitle: [vehicle.year, vehicle.color].filter(Boolean).join(" - "),
    createdAt: vehicle.createdAt,
    updatedAt: vehicle.updatedAt,
  };
}

function presentPaymentMethod(paymentMethod) {
  return {
    id: paymentMethod._id.toString(),
    brand: paymentMethod.brand,
    brandLabel: paymentMethod.brand === "unknown" ? "Card" : paymentMethod.brand.toUpperCase(),
    cardholderName: paymentMethod.cardholderName,
    last4: paymentMethod.last4,
    maskedNumber: `•••• •••• •••• ${paymentMethod.last4}`,
    expiryMonth: paymentMethod.expiryMonth,
    expiryYear: paymentMethod.expiryYear,
    expiryLabel: `${String(paymentMethod.expiryMonth).padStart(2, "0")}/${String(paymentMethod.expiryYear).slice(-2)}`,
    isDefault: paymentMethod.isDefault,
    status: paymentMethod.status,
    createdAt: paymentMethod.createdAt,
    updatedAt: paymentMethod.updatedAt,
  };
}

function presentReferral(referral) {
  return {
    id: referral._id.toString(),
    referredName: referral.referredName,
    amount: referral.amount,
    amountLabel: formatMoney(referral.amount, referral.currencySymbol),
    status: referral.status,
    firstReservationAt: referral.firstReservationAt || null,
    earnedAt: referral.earnedAt || null,
    createdAt: referral.createdAt,
  };
}

function presentProfile(user, primaryVehicle) {
  const sanitized = sanitizeUser(user);
  const referralProfile = user.referralProfile || {};

  return {
    ...sanitized,
    fullName: [user.firstName, user.lastName].filter(Boolean).join(" "),
    avatar: {
      initials: `${user.firstName?.[0] || ""}${user.lastName?.[0] || ""}`.toUpperCase() || "P",
      color: "#16a34a",
    },
    emailVerification: {
      isVerified: user.isEmailVerified,
      label: user.isEmailVerified ? "Verified" : "Not verified",
    },
    phoneVerification: {
      isVerified: user.isPhoneVerified,
      label: user.isPhoneVerified ? "Verified" : "Not verified",
    },
    primaryVehicle: primaryVehicle ? presentVehicle(primaryVehicle) : null,
    licensePlateStatus: primaryVehicle || user.vehiclePlate
      ? {
          registered: true,
          plate: primaryVehicle?.plate || user.vehiclePlate,
          label: primaryVehicle?.plate || user.vehiclePlate,
        }
      : {
          registered: false,
          plate: null,
          label: "No license plate registered",
        },
    referralCode: referralProfile.code || null,
  };
}

async function syncPrimaryVehicle(userId, user) {
  const primaryVehicle = await Vehicle.findOne({ user: userId, isPrimary: true });

  if (primaryVehicle) {
    user.vehiclePlate = primaryVehicle.plate;
    await user.save({ validateBeforeSave: false });
  }

  return primaryVehicle;
}

async function findOwnedVehicle(userId, vehicleId) {
  const vehicle = await Vehicle.findOne({ _id: vehicleId, user: userId });

  if (!vehicle) {
    throw new HttpError(404, "Vehicle not found");
  }

  return vehicle;
}

async function findOwnedPaymentMethod(userId, paymentMethodId) {
  const paymentMethod = await PaymentMethod.findOne({ _id: paymentMethodId, user: userId, status: "active" });

  if (!paymentMethod) {
    throw new HttpError(404, "Payment method not found");
  }

  return paymentMethod;
}

const getProfile = asyncHandler(async (req, res) => {
  await ensureReferralProfile(req.user);
  const primaryVehicle = await Vehicle.findOne({ user: req.user._id, isPrimary: true });

  res.json({
    success: true,
    profile: presentProfile(req.user, primaryVehicle),
    tabs: [
      { code: "profile", label: "Profile" },
      { code: "vehicles", label: "Vehicles" },
      { code: "payments", label: "Payments" },
    ],
    menu: [
      { code: "referrals", label: "Refer friends" },
      { code: "settings", label: "Settings" },
      { code: "notifications", label: "Notifications" },
      { code: "logout", label: "Logout" },
    ],
  });
});

const updateProfile = asyncHandler(async (req, res) => {
  const fullName = parseFullName(req.body.fullName);
  const firstName = cleanString(req.body.firstName) || fullName?.firstName;
  const lastName = cleanString(req.body.lastName || req.body.surname) || fullName?.lastName;
  const phoneNumber = normalizePhoneNumber(req.body.phoneNumber || req.body.phone);
  const email = cleanString(req.body.email)?.toLowerCase();

  if (firstName) req.user.firstName = firstName;
  if (lastName) req.user.lastName = lastName;

  if (phoneNumber) {
    if (phoneNumber.length < 7) {
      throw new HttpError(400, "Phone number must be at least 7 digits");
    }
    req.user.phoneNumber = phoneNumber;
  }

  if (email) {
    if (!validator.isEmail(email)) {
      throw new HttpError(400, "Email is invalid");
    }
    if (email !== req.user.email) {
      req.user.email = email;
      req.user.isEmailVerified = false;
    }
  }

  await req.user.save();
  const primaryVehicle = await syncPrimaryVehicle(req.user._id, req.user);

  res.json({
    success: true,
    message: "Profile updated",
    profile: presentProfile(req.user, primaryVehicle),
  });
});

const logout = asyncHandler(async (req, res) => {
  res.json({
    success: true,
    message: "Logged out successfully",
  });
});

const listVehicles = asyncHandler(async (req, res) => {
  const vehicles = await Vehicle.find({ user: req.user._id }).sort({ isPrimary: -1, createdAt: -1 });

  res.json({
    success: true,
    total: vehicles.length,
    vehicleTypes,
    vehicles: vehicles.map(presentVehicle),
  });
});

const createVehicle = asyncHandler(async (req, res) => {
  const type = normalizeVehicleType(req.body.type || req.body.vehicleType);
  const plate = normalizePlate(req.body.plate || req.body.licensePlate);
  const brand = cleanString(req.body.brand || req.body.make);
  const model = cleanString(req.body.model);
  const vehicleCount = await Vehicle.countDocuments({ user: req.user._id });

  if (!vehicleTypes.some((item) => item.code === type)) {
    throw new HttpError(400, "Vehicle type is invalid");
  }

  if (!plate) {
    throw new HttpError(400, "License plate is required");
  }

  if (!brand) {
    throw new HttpError(400, "Vehicle brand is required");
  }

  if (!model) {
    throw new HttpError(400, "Vehicle model is required");
  }

  const isPrimary = vehicleCount === 0 || isEnabled(req.body.isPrimary);

  if (isPrimary) {
    await Vehicle.updateMany({ user: req.user._id }, { isPrimary: false });
  }

  const vehicle = await Vehicle.create({
    user: req.user._id,
    type,
    plate,
    brand,
    model,
    year: req.body.year ? Number(req.body.year) : undefined,
    color: cleanString(req.body.color),
    notes: cleanString(req.body.notes),
    isPrimary,
  });

  if (isPrimary) {
    req.user.vehiclePlate = vehicle.plate;
    await req.user.save({ validateBeforeSave: false });
  }

  res.status(201).json({
    success: true,
    message: "Vehicle added",
    vehicle: presentVehicle(vehicle),
  });
});

const getVehicle = asyncHandler(async (req, res) => {
  const vehicle = await findOwnedVehicle(req.user._id, req.params.id);

  res.json({
    success: true,
    vehicle: presentVehicle(vehicle),
  });
});

const updateVehicle = asyncHandler(async (req, res) => {
  const vehicle = await findOwnedVehicle(req.user._id, req.params.id);
  const type = normalizeVehicleType(req.body.type || req.body.vehicleType);

  if (type) {
    if (!vehicleTypes.some((item) => item.code === type)) {
      throw new HttpError(400, "Vehicle type is invalid");
    }
    vehicle.type = type;
  }

  if (req.body.plate || req.body.licensePlate) {
    vehicle.plate = normalizePlate(req.body.plate || req.body.licensePlate);
  }

  if (req.body.brand || req.body.make) vehicle.brand = cleanString(req.body.brand || req.body.make);
  if (req.body.model) vehicle.model = cleanString(req.body.model);
  if (req.body.year !== undefined) vehicle.year = Number(req.body.year);
  if (req.body.color !== undefined) vehicle.color = cleanString(req.body.color);
  if (req.body.notes !== undefined) vehicle.notes = cleanString(req.body.notes);

  if (req.body.isPrimary !== undefined && isEnabled(req.body.isPrimary)) {
    await Vehicle.updateMany({ user: req.user._id, _id: { $ne: vehicle._id } }, { isPrimary: false });
    vehicle.isPrimary = true;
  }

  await vehicle.save();

  if (vehicle.isPrimary) {
    req.user.vehiclePlate = vehicle.plate;
    await req.user.save({ validateBeforeSave: false });
  }

  res.json({
    success: true,
    message: "Vehicle updated",
    vehicle: presentVehicle(vehicle),
  });
});

const setDefaultVehicle = asyncHandler(async (req, res) => {
  const vehicle = await findOwnedVehicle(req.user._id, req.params.id);

  await Vehicle.updateMany({ user: req.user._id }, { isPrimary: false });
  vehicle.isPrimary = true;
  await vehicle.save();
  req.user.vehiclePlate = vehicle.plate;
  await req.user.save({ validateBeforeSave: false });

  res.json({
    success: true,
    message: "Default vehicle updated",
    vehicle: presentVehicle(vehicle),
  });
});

const deleteVehicle = asyncHandler(async (req, res) => {
  const vehicle = await findOwnedVehicle(req.user._id, req.params.id);
  const wasPrimary = vehicle.isPrimary;

  await vehicle.deleteOne();

  if (wasPrimary) {
    const nextVehicle = await Vehicle.findOne({ user: req.user._id }).sort({ createdAt: -1 });

    if (nextVehicle) {
      nextVehicle.isPrimary = true;
      await nextVehicle.save();
      req.user.vehiclePlate = nextVehicle.plate;
    } else {
      req.user.vehiclePlate = undefined;
    }

    await req.user.save({ validateBeforeSave: false });
  }

  res.json({
    success: true,
    message: "Vehicle deleted",
  });
});

const listPaymentMethods = asyncHandler(async (req, res) => {
  const paymentMethods = await PaymentMethod.find({ user: req.user._id, status: "active" })
    .sort({ isDefault: -1, createdAt: -1 });

  res.json({
    success: true,
    total: paymentMethods.length,
    paymentMethods: paymentMethods.map(presentPaymentMethod),
  });
});

const createPaymentMethod = asyncHandler(async (req, res) => {
  const last4 = getCardLast4(req.body);
  const { expiryMonth, expiryYear } = parseExpiry(req.body);
  const cardholderName = cleanString(req.body.cardholderName || req.body.nameOnCard);

  if (!last4) {
    throw new HttpError(400, "Card number or card last four digits is required");
  }

  if (!cardholderName) {
    throw new HttpError(400, "Cardholder name is required");
  }

  if (!Number.isInteger(expiryMonth) || expiryMonth < 1 || expiryMonth > 12) {
    throw new HttpError(400, "Expiry month is invalid");
  }

  if (!Number.isInteger(expiryYear) || expiryYear < new Date().getFullYear()) {
    throw new HttpError(400, "Expiry year is invalid");
  }

  const paymentMethodCount = await PaymentMethod.countDocuments({ user: req.user._id, status: "active" });
  const isDefault = paymentMethodCount === 0 || isEnabled(req.body.isDefault);

  if (isDefault) {
    await PaymentMethod.updateMany({ user: req.user._id }, { isDefault: false });
  }

  const paymentMethod = await PaymentMethod.create({
    user: req.user._id,
    brand: cleanString(req.body.brand)?.toLowerCase() || detectCardBrand(req.body.cardNumber),
    cardholderName,
    last4,
    expiryMonth,
    expiryYear,
    isDefault,
  });

  res.status(201).json({
    success: true,
    message: "Payment method saved",
    paymentMethod: presentPaymentMethod(paymentMethod),
  });
});

const setDefaultPaymentMethod = asyncHandler(async (req, res) => {
  const paymentMethod = await findOwnedPaymentMethod(req.user._id, req.params.id);

  await PaymentMethod.updateMany({ user: req.user._id }, { isDefault: false });
  paymentMethod.isDefault = true;
  await paymentMethod.save();

  res.json({
    success: true,
    message: "Default payment method updated",
    paymentMethod: presentPaymentMethod(paymentMethod),
  });
});

const deletePaymentMethod = asyncHandler(async (req, res) => {
  const paymentMethod = await findOwnedPaymentMethod(req.user._id, req.params.id);
  const wasDefault = paymentMethod.isDefault;

  paymentMethod.status = "disabled";
  paymentMethod.isDefault = false;
  await paymentMethod.save();

  if (wasDefault) {
    const nextPaymentMethod = await PaymentMethod.findOne({ user: req.user._id, status: "active" }).sort({ createdAt: -1 });

    if (nextPaymentMethod) {
      nextPaymentMethod.isDefault = true;
      await nextPaymentMethod.save();
    }
  }

  res.json({
    success: true,
    message: "Payment method removed",
  });
});

const getReferrals = asyncHandler(async (req, res) => {
  const referralProfile = await ensureReferralProfile(req.user);
  const referrals = await Referral.find({ owner: req.user._id }).sort({ createdAt: -1 });
  const earnedAmount = referrals
    .filter((referral) => ["earned", "paid"].includes(referral.status))
    .reduce((sum, referral) => sum + referral.amount, 0);

  res.json({
    success: true,
    referral: {
      code: referralProfile.code,
      rewardPerReferral: referralProfile.rewardPerReferral || 50,
      rewardPerReferralLabel: formatMoney(referralProfile.rewardPerReferral || 50),
      earnedAmount,
      earnedAmountLabel: formatMoney(earnedAmount),
      referredCount: referrals.length,
      shareLinks: {
        whatsapp: `https://wa.me/?text=Use%20my%20Parkealo%20code%20${encodeURIComponent(referralProfile.code)}`,
        facebook: `https://www.facebook.com/sharer/sharer.php?u=https://parkealo.com/ref/${encodeURIComponent(referralProfile.code)}`,
      },
      steps: [
        "Share your code with friends",
        "Your friend signs up with your code",
        "Both earn the reward after their first reservation",
      ],
      referrals: referrals.map(presentReferral),
    },
  });
});

const createReferral = asyncHandler(async (req, res) => {
  await ensureReferralProfile(req.user);
  const referredName = cleanString(req.body.referredName || req.body.name);
  const status = cleanString(req.body.status) || "pending";

  if (!referredName) {
    throw new HttpError(400, "Referred friend name is required");
  }

  if (!["pending", "earned", "paid"].includes(status)) {
    throw new HttpError(400, "Referral status is invalid");
  }

  const amount = Number(req.body.amount) || req.user.referralProfile.rewardPerReferral || 50;
  const referral = await Referral.create({
    owner: req.user._id,
    referredName,
    amount,
    status,
    earnedAt: ["earned", "paid"].includes(status) ? new Date() : undefined,
    firstReservationAt: ["earned", "paid"].includes(status) ? new Date() : undefined,
  });

  req.user.referralProfile.referredCount = await Referral.countDocuments({ owner: req.user._id });
  req.user.referralProfile.earnedAmount = await Referral.find({ owner: req.user._id, status: { $in: ["earned", "paid"] } })
    .then((items) => items.reduce((sum, item) => sum + item.amount, 0));
  await req.user.save({ validateBeforeSave: false });

  res.status(201).json({
    success: true,
    message: "Referral saved",
    referral: presentReferral(referral),
  });
});

const getSettings = asyncHandler(async (req, res) => {
  res.json({
    success: true,
    app: {
      name: "Parkealo",
      version: "1.0.0",
      build: "100",
      company: "Parkealo SRL",
      location: "Santo Domingo, RD",
    },
    preferences: req.user.preferences,
    legal: [
      { code: "terms", label: "Terms and conditions", url: "/api/account/legal/terms" },
      { code: "privacy", label: "Privacy policy", url: "/api/account/legal/privacy" },
    ],
    support: supportOptions,
  });
});

const updateSettings = asyncHandler(async (req, res) => {
  const notifications = req.body.notifications || {};

  req.user.preferences = {
    ...(req.user.preferences?.toObject ? req.user.preferences.toObject() : req.user.preferences || {}),
    language: cleanString(req.body.language) || req.user.preferences?.language || "en",
    notifications: {
      bookingUpdates: notifications.bookingUpdates === undefined
        ? req.user.preferences?.notifications?.bookingUpdates !== false
        : isEnabled(notifications.bookingUpdates),
      promotions: notifications.promotions === undefined
        ? req.user.preferences?.notifications?.promotions !== false
        : isEnabled(notifications.promotions),
      referrals: notifications.referrals === undefined
        ? req.user.preferences?.notifications?.referrals !== false
        : isEnabled(notifications.referrals),
      hostUpdates: notifications.hostUpdates === undefined
        ? req.user.preferences?.notifications?.hostUpdates !== false
        : isEnabled(notifications.hostUpdates),
    },
  };
  await req.user.save({ validateBeforeSave: false });

  res.json({
    success: true,
    message: "Settings updated",
    preferences: req.user.preferences,
  });
});

const getLegalIndex = asyncHandler(async (req, res) => {
  res.json({
    success: true,
    documents: [
      { code: "terms", title: "Terms and conditions", version: "1.0", url: "/api/account/legal/terms" },
      { code: "privacy", title: "Privacy policy", version: "1.0", url: "/api/account/legal/privacy" },
    ],
  });
});

const getTerms = asyncHandler(async (req, res) => {
  res.json({
    success: true,
    document: {
      code: "terms",
      title: "Terms and conditions",
      version: "1.0",
      sections: [
        {
          title: "Use of Parkealo",
          content: "Users must provide accurate account, vehicle, booking, and payment information.",
        },
        {
          title: "Reservations",
          content: "Reservations are subject to parking availability, host rules, and payment confirmation.",
        },
        {
          title: "Vehicles and belongings",
          content: "Do not leave valuable items visible inside your vehicle. Parkealo is not responsible for items left in view.",
        },
      ],
    },
  });
});

const getPrivacy = asyncHandler(async (req, res) => {
  res.json({
    success: true,
    document: {
      code: "privacy",
      title: "Privacy policy",
      version: "1.0",
      sections: [
        {
          title: "Information we collect",
          content: "We collect account, vehicle, booking, payment method metadata, and support request information.",
        },
        {
          title: "How we use information",
          content: "We use information to manage reservations, provide support, improve safety, and operate the platform.",
        },
        {
          title: "Payment data",
          content: "Parkealo stores only card metadata such as brand, expiration, and last four digits. Full card numbers are not stored.",
        },
      ],
    },
  });
});

const getSupport = asyncHandler(async (req, res) => {
  const recentTickets = await SupportTicket.find({ user: req.user._id }).sort({ createdAt: -1 }).limit(10);

  res.json({
    success: true,
    support: {
      options: supportOptions,
      faq: [
        {
          question: "How do I cancel a booking?",
          answer: "Open your booking details and use the available cancellation action before the reservation starts.",
        },
        {
          question: "How do I add another vehicle?",
          answer: "Open Account, select Vehicles, and use Add vehicle.",
        },
      ],
      recentTickets: recentTickets.map((ticket) => ({
        id: ticket._id.toString(),
        type: ticket.type,
        subject: ticket.subject,
        status: ticket.status,
        createdAt: ticket.createdAt,
      })),
    },
  });
});

const createSupportTicket = asyncHandler(async (req, res) => {
  const type = cleanString(req.body.type) || "chat";
  const subject = cleanString(req.body.subject);
  const message = cleanString(req.body.message);

  if (!supportOptions.some((option) => option.code === type)) {
    throw new HttpError(400, "Support request type is invalid");
  }

  if (!subject) {
    throw new HttpError(400, "Subject is required");
  }

  if (!message) {
    throw new HttpError(400, "Message is required");
  }

  const ticket = await SupportTicket.create({
    user: req.user._id,
    type,
    subject,
    message,
  });

  res.status(201).json({
    success: true,
    message: "Support request created",
    ticket: {
      id: ticket._id.toString(),
      type: ticket.type,
      subject: ticket.subject,
      status: ticket.status,
      createdAt: ticket.createdAt,
    },
  });
});

module.exports = {
  createPaymentMethod,
  createReferral,
  createSupportTicket,
  createVehicle,
  deletePaymentMethod,
  deleteVehicle,
  getLegalIndex,
  getPaymentMethods: listPaymentMethods,
  getPrivacy,
  getProfile,
  getReferrals,
  getSettings,
  getSupport,
  getTerms,
  getVehicle,
  listPaymentMethods,
  listVehicles,
  logout,
  setDefaultPaymentMethod,
  setDefaultVehicle,
  updateProfile,
  updateSettings,
  updateVehicle,
};
