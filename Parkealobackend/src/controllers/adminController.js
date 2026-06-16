const mongoose = require("mongoose");

const Booking = require("../models/Booking");
const Favorite = require("../models/Favorite");
const HostWithdrawal = require("../models/HostWithdrawal");
const Parking = require("../models/Parking");
const PaymentMethod = require("../models/PaymentMethod");
const Referral = require("../models/Referral");
const SupportTicket = require("../models/SupportTicket");
const User = require("../models/User");
const Vehicle = require("../models/Vehicle");
const { HttpError } = require("../utils/httpError");
const { formatMoney, roundMoney } = require("../utils/pricing");

function asyncHandler(handler) {
  return (req, res, next) => Promise.resolve(handler(req, res, next)).catch(next);
}

function cleanString(value) {
  return typeof value === "string" ? value.trim() : undefined;
}

function ensureObjectId(id, label = "Record") {
  if (!mongoose.Types.ObjectId.isValid(id)) {
    throw new HttpError(404, `${label} not found`);
  }
}

function createRegex(value) {
  const query = cleanString(value);
  return query ? new RegExp(query.replace(/[.*+?^${}()|[\]\\]/g, "\\$&"), "i") : null;
}

function statusCounts(items, selector) {
  return items.reduce((counts, item) => {
    const key = selector(item) || "unknown";
    counts[key] = (counts[key] || 0) + 1;
    return counts;
  }, {});
}

function presentUser(user) {
  return {
    id: user._id.toString(),
    name: [user.firstName, user.lastName].filter(Boolean).join(" ") || "Parkealo User",
    firstName: user.firstName,
    lastName: user.lastName,
    email: user.email || null,
    phoneNumber: user.phoneNumber || null,
    vehiclePlate: user.vehiclePlate || null,
    role: user.role,
    authProvider: user.authProvider,
    isEmailVerified: user.isEmailVerified,
    isPhoneVerified: user.isPhoneVerified,
    hostProfile: user.hostProfile,
    createdAt: user.createdAt,
    updatedAt: user.updatedAt,
  };
}

function presentHostUser(user, stats = {}) {
  return {
    ...presentUser(user),
    hostStats: {
      businessName: stats.businessName || `${user.firstName || "Host"} ${user.lastName || ""}`.trim(),
      spaces: stats.spaces || 0,
      activeSpaces: stats.activeSpaces || 0,
      revenue: roundMoney(stats.revenue || 0),
      revenueLabel: formatMoney(stats.revenue || 0),
      rating: roundMoney(stats.rating || 0),
      verification: user.isEmailVerified && user.isPhoneVerified
        ? "verified"
        : user.isEmailVerified || user.isPhoneVerified
          ? "pending"
          : "rejected",
    },
  };
}

function normalizeEmail(value) {
  const email = cleanString(value);
  return email ? email.toLowerCase() : undefined;
}

function normalizePhoneNumber(value) {
  const phoneNumber = cleanString(value);
  return phoneNumber ? phoneNumber.replace(/[^\d+]/g, "") : undefined;
}

function normalizeVehiclePlate(value) {
  const vehiclePlate = cleanString(value);
  return vehiclePlate ? vehiclePlate.toUpperCase() : undefined;
}

function presentParking(parking) {
  return {
    id: parking._id.toString(),
    name: parking.name,
    slug: parking.slug,
    hostUser: parking.hostUser?.toString() || null,
    hostName: parking.host?.name || "Host",
    zone: parking.zone,
    city: parking.address?.city || "",
    status: parking.status,
    submissionStatus: parking.submission?.status || "draft",
    approvalMode: parking.approvalMode,
    spaces: {
      total: parking.availability?.totalSpaces || 0,
      available: parking.availability?.availableSpaces || 0,
      occupied: Math.max((parking.availability?.totalSpaces || 0) - (parking.availability?.availableSpaces || 0), 0),
    },
    rate: {
      hourly: parking.rate?.hourly || 0,
      daily: parking.rate?.daily || 0,
      weekly: parking.rate?.weekly || 0,
      hourlyLabel: formatMoney(parking.rate?.hourly || 0, parking.rate?.currencySymbol),
    },
    rating: parking.rating || {},
    createdAt: parking.createdAt,
    updatedAt: parking.updatedAt,
  };
}

function presentBooking(booking) {
  return {
    id: booking._id.toString(),
    confirmationCode: booking.confirmationCode,
    user: booking.user?.toString() || null,
    parking: booking.parking?.toString() || null,
    parkingName: booking.parkingSnapshot?.name || "Parking",
    vehiclePlate: booking.vehiclePlate,
    status: booking.status,
    approvalMode: booking.approvalMode,
    date: booking.date,
    arrivalTime: booking.arrivalTime,
    durationHours: booking.durationHours,
    startAt: booking.startAt,
    endAt: booking.endAt,
    paidTotal: booking.pricing?.paidTotal || 0,
    paidTotalLabel: formatMoney(booking.pricing?.paidTotal || 0, booking.pricing?.currencySymbol),
    paymentStatus: booking.payment?.status || "unknown",
    paymentMethod: booking.payment?.method || "unknown",
    createdAt: booking.createdAt,
    updatedAt: booking.updatedAt,
  };
}

function presentWithdrawal(withdrawal) {
  return {
    id: withdrawal._id.toString(),
    user: withdrawal.user?.toString() || null,
    amount: withdrawal.amount,
    amountLabel: formatMoney(withdrawal.amount, withdrawal.currencySymbol),
    currency: withdrawal.currency,
    status: withdrawal.status,
    requestedAt: withdrawal.requestedAt,
    processedAt: withdrawal.processedAt || null,
    createdAt: withdrawal.createdAt,
  };
}

function presentTicket(ticket) {
  return {
    id: ticket._id.toString(),
    user: ticket.user?.toString() || null,
    type: ticket.type,
    subject: ticket.subject,
    message: ticket.message,
    status: ticket.status,
    createdAt: ticket.createdAt,
    updatedAt: ticket.updatedAt,
  };
}

const getDashboard = asyncHandler(async (req, res) => {
  const [
    users,
    parkings,
    bookings,
    withdrawals,
    supportTickets,
    vehiclesCount,
    favoritesCount,
    paymentMethodsCount,
    referralsCount,
  ] = await Promise.all([
    User.find({}).sort({ createdAt: -1 }),
    Parking.find({}).sort({ createdAt: -1 }),
    Booking.find({}).sort({ createdAt: -1 }).limit(100),
    HostWithdrawal.find({}).sort({ requestedAt: -1 }).limit(100),
    SupportTicket.find({}).sort({ createdAt: -1 }).limit(100),
    Vehicle.countDocuments(),
    Favorite.countDocuments(),
    PaymentMethod.countDocuments(),
    Referral.countDocuments(),
  ]);

  const paidRevenue = bookings.reduce((sum, booking) => sum + (booking.pricing?.paidTotal || 0), 0);
  const pendingPayouts = withdrawals
    .filter((withdrawal) => ["requested", "processing"].includes(withdrawal.status))
    .reduce((sum, withdrawal) => sum + withdrawal.amount, 0);
  const now = new Date();
  const today = new Date(now.getFullYear(), now.getMonth(), now.getDate());

  res.json({
    success: true,
    admin: presentUser(req.user),
    summary: {
      users: users.length,
      drivers: users.filter((user) => user.role === "user").length,
      hosts: users.filter((user) => user.role === "host").length,
      admins: users.filter((user) => user.role === "admin").length,
      parkings: parkings.length,
      activeParkings: parkings.filter((parking) => parking.status === "active").length,
      bookings: bookings.length,
      bookingsToday: bookings.filter((booking) => booking.createdAt >= today).length,
      revenue: roundMoney(paidRevenue),
      revenueLabel: formatMoney(paidRevenue),
      pendingPayouts: roundMoney(pendingPayouts),
      pendingPayoutsLabel: formatMoney(pendingPayouts),
      supportOpen: supportTickets.filter((ticket) => ticket.status !== "closed").length,
      vehicles: vehiclesCount,
      favorites: favoritesCount,
      paymentMethods: paymentMethodsCount,
      referrals: referralsCount,
    },
    breakdowns: {
      usersByRole: statusCounts(users, (user) => user.role),
      parkingsByStatus: statusCounts(parkings, (parking) => parking.status),
      submissionsByStatus: statusCounts(parkings, (parking) => parking.submission?.status || "draft"),
      bookingsByStatus: statusCounts(bookings, (booking) => booking.status),
      withdrawalsByStatus: statusCounts(withdrawals, (withdrawal) => withdrawal.status),
      supportByStatus: statusCounts(supportTickets, (ticket) => ticket.status),
    },
    recent: {
      users: users.slice(0, 8).map(presentUser),
      parkings: parkings.slice(0, 8).map(presentParking),
      bookings: bookings.slice(0, 8).map(presentBooking),
      withdrawals: withdrawals.slice(0, 8).map(presentWithdrawal),
      supportTickets: supportTickets.slice(0, 8).map(presentTicket),
    },
  });
});

const listUsers = asyncHandler(async (req, res) => {
  const regex = createRegex(req.query.search);
  const role = cleanString(req.query.role);
  const filter = {
    ...(role && ["user", "host", "admin"].includes(role) ? { role } : {}),
    ...(regex
      ? {
          $or: [
            { firstName: regex },
            { lastName: regex },
            { email: regex },
            { phoneNumber: regex },
            { vehiclePlate: regex },
          ],
        }
      : {}),
  };
  const users = await User.find(filter).sort({ createdAt: -1 }).limit(200);

  if (role === "host") {
    const verification = cleanString(req.query.verification);
    const userIds = users.map((user) => user._id);
    const [parkings, bookings] = await Promise.all([
      Parking.find({ hostUser: { $in: userIds } }),
      Booking.find({}),
    ]);
    const statsByHost = new Map();

    for (const parking of parkings) {
      const key = parking.hostUser?.toString();
      if (!key) continue;
      const stats = statsByHost.get(key) || {
        businessName: parking.host?.name || parking.name,
        spaces: 0,
        activeSpaces: 0,
        revenue: 0,
        ratings: [],
      };
      stats.spaces += 1;
      if (parking.status === "active") stats.activeSpaces += 1;
      if (parking.rating?.average) stats.ratings.push(parking.rating.average);
      statsByHost.set(key, stats);
    }

    const parkingHostById = new Map(parkings.map((parking) => [parking._id.toString(), parking.hostUser?.toString()]));
    for (const booking of bookings) {
      const hostId = parkingHostById.get(booking.parking?.toString());
      if (!hostId) continue;
      const stats = statsByHost.get(hostId) || { spaces: 0, activeSpaces: 0, revenue: 0, ratings: [] };
      stats.revenue += booking.pricing?.paidTotal || 0;
      statsByHost.set(hostId, stats);
    }

    const presentedUsers = users.map((user) => {
      const stats = statsByHost.get(user._id.toString()) || {};
      const ratings = stats.ratings || [];
      const rating = ratings.length
        ? ratings.reduce((sum, value) => sum + value, 0) / ratings.length
        : 0;
      return presentHostUser(user, { ...stats, rating });
    });
    const filteredUsers = verification
      ? presentedUsers.filter((user) => user.hostStats.verification === verification)
      : presentedUsers;

    return res.json({
      success: true,
      total: filteredUsers.length,
      users: filteredUsers,
    });
  }

  res.json({ success: true, total: users.length, users: users.map(presentUser) });
});

const createUser = asyncHandler(async (req, res) => {
  const firstName = cleanString(req.body.firstName);
  const lastName = cleanString(req.body.lastName || req.body.surname) || "User";
  const email = normalizeEmail(req.body.email);
  const phoneNumber = normalizePhoneNumber(req.body.phoneNumber);
  const vehiclePlate = normalizeVehiclePlate(req.body.vehiclePlate);
  const password = req.body.password || "secret123";
  const role = cleanString(req.body.role) || "user";

  if (!firstName) {
    throw new HttpError(400, "First name is required");
  }

  if (!email && !phoneNumber) {
    throw new HttpError(400, "Email or phone number is required");
  }

  if (!["user", "host", "admin"].includes(role)) {
    throw new HttpError(400, "Role must be user, host, or admin");
  }

  const duplicateQueries = [
    ...(email ? [{ email }] : []),
    ...(phoneNumber ? [{ phoneNumber }] : []),
    ...(vehiclePlate ? [{ vehiclePlate }] : []),
  ];
  const duplicate = duplicateQueries.length
    ? await User.findOne({ $or: duplicateQueries })
    : null;

  if (duplicate) {
    throw new HttpError(409, "A user with that email, phone, or vehicle plate already exists");
  }

  const user = await User.create({
    firstName,
    lastName,
    email,
    phoneNumber,
    vehiclePlate,
    password,
    role,
    authProvider: "local",
    isEmailVerified: req.body.isEmailVerified === true || role === "admin",
    isPhoneVerified: req.body.isPhoneVerified === true,
    hostProfile: role === "host"
      ? {
          onboardingCompleted: true,
          firstParkingSubmitted: false,
          inviteRewardAmount: 500,
          defaultReservationMode: "automatic",
        }
      : undefined,
  });

  res.status(201).json({
    success: true,
    message: "User created",
    user: presentUser(user),
  });
});

const updateUser = asyncHandler(async (req, res) => {
  ensureObjectId(req.params.id, "User");
  const user = await User.findById(req.params.id);
  if (!user) throw new HttpError(404, "User not found");

  const role = cleanString(req.body.role);
  if (role) {
    if (!["user", "host", "admin"].includes(role)) {
      throw new HttpError(400, "Role must be user, host, or admin");
    }
    user.role = role;
  }

  const firstName = cleanString(req.body.firstName);
  if (firstName) user.firstName = firstName;

  const lastName = cleanString(req.body.lastName || req.body.surname);
  if (lastName) user.lastName = lastName;

  const email = normalizeEmail(req.body.email);
  if (email) user.email = email;

  const phoneNumber = normalizePhoneNumber(req.body.phoneNumber);
  if (phoneNumber) user.phoneNumber = phoneNumber;

  const vehiclePlate = normalizeVehiclePlate(req.body.vehiclePlate);
  if (vehiclePlate) user.vehiclePlate = vehiclePlate;

  if (req.body.password) {
    user.password = req.body.password;
  }

  if (req.body.isEmailVerified !== undefined) {
    user.isEmailVerified = req.body.isEmailVerified === true || req.body.isEmailVerified === "true";
  }

  if (req.body.isPhoneVerified !== undefined) {
    user.isPhoneVerified = req.body.isPhoneVerified === true || req.body.isPhoneVerified === "true";
  }

  await user.save({ validateBeforeSave: false });
  res.json({ success: true, message: "User updated", user: presentUser(user) });
});

const deleteUser = asyncHandler(async (req, res) => {
  ensureObjectId(req.params.id, "User");

  if (req.params.id === req.user._id.toString()) {
    throw new HttpError(400, "You cannot delete your own admin account");
  }

  const user = await User.findById(req.params.id);
  if (!user) throw new HttpError(404, "User not found");

  await Promise.all([
    Favorite.deleteMany({ user: user._id }),
    PaymentMethod.deleteMany({ user: user._id }),
    Referral.deleteMany({ owner: user._id }),
    SupportTicket.deleteMany({ user: user._id }),
    Vehicle.deleteMany({ user: user._id }),
    HostWithdrawal.deleteMany({ user: user._id }),
    Parking.updateMany(
      { hostUser: user._id },
      {
        $unset: { hostUser: "" },
        $set: { status: "inactive", "submission.status": "draft" },
      },
    ),
    User.deleteOne({ _id: user._id }),
  ]);

  res.json({
    success: true,
    message: "User deleted",
    user: presentUser(user),
  });
});

const listParkings = asyncHandler(async (req, res) => {
  const regex = createRegex(req.query.search);
  const status = cleanString(req.query.status);
  const filter = {
    ...(status ? { status } : {}),
    ...(regex
      ? {
          $or: [
            { name: regex },
            { zone: regex },
            { "address.city": regex },
            { slug: regex },
            { hostCode: regex },
          ],
        }
      : {}),
  };
  const parkings = await Parking.find(filter).sort({ createdAt: -1 }).limit(200);

  res.json({ success: true, total: parkings.length, parkings: parkings.map(presentParking) });
});

const updateParking = asyncHandler(async (req, res) => {
  ensureObjectId(req.params.id, "Parking");
  const parking = await Parking.findById(req.params.id);
  if (!parking) throw new HttpError(404, "Parking not found");

  const status = cleanString(req.body.status);
  if (status) {
    if (!["draft", "under_review", "active", "inactive", "rejected"].includes(status)) {
      throw new HttpError(400, "Invalid parking status");
    }
    parking.status = status;
  }

  const submissionStatus = cleanString(req.body.submissionStatus || req.body.submission?.status);
  if (submissionStatus) {
    if (!["draft", "under_review", "approved", "rejected"].includes(submissionStatus)) {
      throw new HttpError(400, "Invalid submission status");
    }
    parking.submission.status = submissionStatus;
    if (submissionStatus === "approved") {
      parking.submission.reviewedAt = new Date();
    }
  }

  await parking.save();
  res.json({ success: true, message: "Parking updated", parking: presentParking(parking) });
});

const listBookings = asyncHandler(async (req, res) => {
  const regex = createRegex(req.query.search);
  const status = cleanString(req.query.status);
  const filter = {
    ...(status ? { status } : {}),
    ...(regex
      ? {
          $or: [
            { confirmationCode: regex },
            { vehiclePlate: regex },
            { "parkingSnapshot.name": regex },
            { "parkingSnapshot.zone": regex },
          ],
        }
      : {}),
  };
  const bookings = await Booking.find(filter).sort({ createdAt: -1 }).limit(200);

  res.json({ success: true, total: bookings.length, bookings: bookings.map(presentBooking) });
});

const updateBooking = asyncHandler(async (req, res) => {
  ensureObjectId(req.params.id, "Booking");
  const booking = await Booking.findById(req.params.id);
  if (!booking) throw new HttpError(404, "Booking not found");

  const status = cleanString(req.body.status);
  if (!["pending_host_approval", "pending_checkin", "in_progress", "completed", "cancelled", "declined", "expired"].includes(status)) {
    throw new HttpError(400, "Invalid booking status");
  }

  booking.status = status;
  if (status === "in_progress" && !booking.checkedInAt) booking.checkedInAt = new Date();
  if (status === "completed" && !booking.checkedOutAt) booking.checkedOutAt = new Date();
  await booking.save({ validateBeforeSave: false });

  res.json({ success: true, message: "Booking updated", booking: presentBooking(booking) });
});

const listWithdrawals = asyncHandler(async (req, res) => {
  const status = cleanString(req.query.status);
  const withdrawals = await HostWithdrawal.find(status ? { status } : {})
    .sort({ requestedAt: -1 })
    .limit(200);

  res.json({ success: true, total: withdrawals.length, withdrawals: withdrawals.map(presentWithdrawal) });
});

const updateWithdrawal = asyncHandler(async (req, res) => {
  ensureObjectId(req.params.id, "Withdrawal");
  const withdrawal = await HostWithdrawal.findById(req.params.id);
  if (!withdrawal) throw new HttpError(404, "Withdrawal not found");

  const status = cleanString(req.body.status);
  if (!["requested", "processing", "paid", "cancelled"].includes(status)) {
    throw new HttpError(400, "Invalid withdrawal status");
  }

  withdrawal.status = status;
  withdrawal.processedAt = ["paid", "cancelled"].includes(status) ? new Date() : withdrawal.processedAt;
  await withdrawal.save();

  res.json({ success: true, message: "Withdrawal updated", withdrawal: presentWithdrawal(withdrawal) });
});

const listSupportTickets = asyncHandler(async (req, res) => {
  const status = cleanString(req.query.status);
  const tickets = await SupportTicket.find(status ? { status } : {})
    .sort({ createdAt: -1 })
    .limit(200);

  res.json({ success: true, total: tickets.length, supportTickets: tickets.map(presentTicket) });
});

const updateSupportTicket = asyncHandler(async (req, res) => {
  ensureObjectId(req.params.id, "Support ticket");
  const ticket = await SupportTicket.findById(req.params.id);
  if (!ticket) throw new HttpError(404, "Support ticket not found");

  const status = cleanString(req.body.status);
  if (!["open", "in_progress", "closed"].includes(status)) {
    throw new HttpError(400, "Invalid support ticket status");
  }

  ticket.status = status;
  await ticket.save();

  res.json({ success: true, message: "Support ticket updated", supportTicket: presentTicket(ticket) });
});

module.exports = {
  getDashboard,
  createUser,
  deleteUser,
  listBookings,
  listParkings,
  listSupportTickets,
  listUsers,
  listWithdrawals,
  updateBooking,
  updateParking,
  updateSupportTicket,
  updateUser,
  updateWithdrawal,
};
