const mongoose = require("mongoose");

const pricingSchema = new mongoose.Schema(
  {
    hourlyRate: { type: Number, required: true, min: 0 },
    durationSubtotal: { type: Number, required: true, min: 0 },
    extensionSubtotal: { type: Number, default: 0, min: 0 },
    insuranceFee: { type: Number, default: 0, min: 0 },
    taxRate: { type: Number, required: true, min: 0 },
    taxAmount: { type: Number, required: true, min: 0 },
    serviceFee: { type: Number, required: true, min: 0 },
    total: { type: Number, required: true, min: 0 },
    paidTotal: { type: Number, default: 0, min: 0 },
    currency: { type: String, default: "DOP" },
    currencySymbol: { type: String, default: "RD$" },
  },
  { _id: false },
);

const paymentSchema = new mongoose.Schema(
  {
    method: {
      type: String,
      enum: ["card", "cash"],
      required: true,
    },
    status: {
      type: String,
      enum: ["paid", "cash_due", "refunded"],
      default: "paid",
    },
    cardLast4: {
      type: String,
      trim: true,
      maxlength: 4,
    },
    provider: {
      type: String,
      enum: ["stripe"],
    },
    stripePaymentIntentId: {
      type: String,
      trim: true,
    },
    stripeChargeId: {
      type: String,
      trim: true,
    },
    cardBrand: {
      type: String,
      trim: true,
    },
    chargedAmount: {
      type: Number,
      min: 0,
    },
    currency: {
      type: String,
      trim: true,
      uppercase: true,
    },
    paidAt: Date,
  },
  { _id: false },
);

const extensionSchema = new mongoose.Schema(
  {
    hours: { type: Number, required: true, min: 1 },
    subtotal: { type: Number, required: true, min: 0 },
    taxAmount: { type: Number, required: true, min: 0 },
    serviceFee: { type: Number, required: true, min: 0 },
    total: { type: Number, required: true, min: 0 },
    paymentMethod: {
      type: String,
      enum: ["card", "cash"],
      required: true,
    },
    status: {
      type: String,
      enum: ["paid", "cash_due"],
      default: "paid",
    },
    createdAt: {
      type: Date,
      default: Date.now,
    },
  },
  { _id: true },
);

const bookingSchema = new mongoose.Schema(
  {
    confirmationCode: {
      type: String,
      required: true,
      unique: true,
      trim: true,
      uppercase: true,
    },
    user: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "User",
      required: true,
      index: true,
    },
    parking: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "Parking",
      required: true,
      index: true,
    },
    parkingSnapshot: {
      name: { type: String, required: true },
      slug: { type: String, required: true },
      zone: { type: String, required: true },
      address: {
        line1: String,
        line2: String,
        city: String,
        state: String,
        country: String,
        postalCode: String,
      },
      coordinates: {
        latitude: Number,
        longitude: Number,
      },
      hourlyRate: Number,
      currency: String,
      currencySymbol: String,
      approvalMode: String,
    },
    status: {
      type: String,
      enum: [
        "pending_host_approval",
        "pending_checkin",
        "in_progress",
        "completed",
        "cancelled",
        "declined",
        "expired",
      ],
      default: "pending_checkin",
      index: true,
    },
    approvalMode: {
      type: String,
      enum: ["automatic", "host_approval"],
      default: "automatic",
    },
    date: {
      type: String,
      required: true,
    },
    arrivalTime: {
      type: String,
      required: true,
    },
    durationHours: {
      type: Number,
      required: true,
      min: 1,
    },
    startAt: {
      type: Date,
      required: true,
    },
    endAt: {
      type: Date,
      required: true,
    },
    checkedInAt: Date,
    checkedOutAt: Date,
    actualParkingDurationSeconds: {
      type: Number,
      default: 0,
      min: 0,
    },
    actualParkingDurationLabel: {
      type: String,
      trim: true,
    },
    vehiclePlate: {
      type: String,
      required: true,
      trim: true,
      uppercase: true,
    },
    bookForOther: {
      type: Boolean,
      default: false,
    },
    otherDriverName: {
      type: String,
      trim: true,
    },
    pricing: {
      type: pricingSchema,
      required: true,
    },
    payment: {
      type: paymentSchema,
      required: true,
    },
    insuranceIncluded: {
      type: Boolean,
      default: false,
    },
    safety: {
      leavingValuables: { type: Boolean, default: false },
      acknowledgedAt: Date,
      hostNotifiedAt: Date,
      checkInLocation: {
        latitude: Number,
        longitude: Number,
        distanceMeters: Number,
        verifiedAt: Date,
      },
    },
    extensions: {
      type: [extensionSchema],
      default: [],
    },
    qrPayload: {
      type: String,
      trim: true,
    },
  },
  { timestamps: true },
);

bookingSchema.index({ user: 1, status: 1, startAt: -1 });
bookingSchema.index({ parking: 1, startAt: 1, endAt: 1 });

module.exports = mongoose.model("Booking", bookingSchema);
