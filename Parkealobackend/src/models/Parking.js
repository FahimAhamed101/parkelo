const mongoose = require("mongoose");

const serviceSchema = new mongoose.Schema(
  {
    code: {
      type: String,
      required: true,
      trim: true,
      lowercase: true,
    },
    label: {
      type: String,
      required: true,
      trim: true,
    },
  },
  { _id: false },
);

const parkingSchema = new mongoose.Schema(
  {
    hostUser: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "User",
      index: true,
      sparse: true,
    },
    hostCode: {
      type: String,
      trim: true,
      uppercase: true,
      sparse: true,
      index: true,
    },
    name: {
      type: String,
      required: [true, "Parking name is required"],
      trim: true,
      maxlength: [120, "Parking name cannot exceed 120 characters"],
    },
    slug: {
      type: String,
      required: true,
      trim: true,
      lowercase: true,
      unique: true,
    },
    description: {
      type: String,
      trim: true,
      maxlength: [1000, "Description cannot exceed 1000 characters"],
    },
    zone: {
      type: String,
      required: true,
      trim: true,
    },
    sector: {
      type: String,
      trim: true,
    },
    address: {
      line1: { type: String, required: true, trim: true },
      line2: { type: String, trim: true },
      city: { type: String, required: true, trim: true },
      state: { type: String, trim: true },
      country: { type: String, required: true, trim: true },
      postalCode: { type: String, trim: true },
    },
    location: {
      type: {
        type: String,
        enum: ["Point"],
        default: "Point",
      },
      coordinates: {
        type: [Number],
        required: true,
        validate: {
          validator(value) {
            return Array.isArray(value) && value.length === 2;
          },
          message: "Coordinates must be [longitude, latitude]",
        },
      },
    },
    accessType: {
      type: String,
      enum: ["public", "private"],
      default: "public",
    },
    parkingType: {
      type: String,
      enum: ["public", "private"],
      default: "public",
    },
    approvalMode: {
      type: String,
      enum: ["automatic", "host_approval"],
      default: "automatic",
    },
    vehicleTypes: {
      type: [String],
      enum: ["car", "motorcycle", "van", "truck"],
      default: ["car"],
    },
    services: {
      type: [serviceSchema],
      default: [],
    },
    rate: {
      hourly: { type: Number, required: true, min: 0 },
      daily: { type: Number, default: 0, min: 0 },
      weekly: { type: Number, default: 0, min: 0 },
      currency: { type: String, default: "DOP" },
      currencySymbol: { type: String, default: "RD$" },
      serviceFee: { type: Number, default: 25, min: 0 },
      taxRate: { type: Number, default: 0.18, min: 0 },
    },
    pricingMode: {
      type: String,
      enum: ["global", "per_section"],
      default: "global",
    },
    dynamicPricing: {
      enabled: { type: Boolean, default: false },
      occupancyThresholdPercent: { type: Number, default: 80, min: 1, max: 100 },
      peakIncreasePercent: { type: Number, default: 20, min: 0 },
    },
    overtime: {
      multiplier: { type: Number, default: 1.5, min: 1 },
      graceMinutes: { type: Number, default: 0, min: 0 },
    },
    sections: {
      type: [
        {
          code: { type: String, required: true, trim: true, uppercase: true },
          name: { type: String, required: true, trim: true },
          description: { type: String, trim: true },
          enabled: { type: Boolean, default: true },
          spaces: { type: [String], default: [] },
          rate: {
            hourly: { type: Number, default: 0, min: 0 },
            daily: { type: Number, default: 0, min: 0 },
            weekly: { type: Number, default: 0, min: 0 },
          },
        },
      ],
      default: [],
    },
    insurance: {
      available: { type: Boolean, default: true },
      fee: { type: Number, default: 25, min: 0 },
      title: { type: String, default: "Parking insurance" },
      description: {
        type: String,
        default: "Protects your vehicle during the reservation window.",
      },
    },
    rating: {
      average: { type: Number, default: 0, min: 0, max: 5 },
      reviewsCount: { type: Number, default: 0, min: 0 },
    },
    availability: {
      totalSpaces: { type: Number, default: 0, min: 0 },
      availableSpaces: { type: Number, default: 0, min: 0 },
      floors: { type: Number, default: 1, min: 1 },
      assignedAtArrival: { type: Boolean, default: true },
    },
    host: {
      name: { type: String, default: "Parkealo" },
      verified: { type: Boolean, default: true },
      verifiedReservations: { type: Number, default: 0, min: 0 },
      responseTimeMinutes: { type: Number, default: 10, min: 0 },
      contactPhone: { type: String, trim: true },
      instagram: { type: String, trim: true },
    },
    media: {
      heroImageUrl: { type: String, trim: true },
      thumbnailUrl: { type: String, trim: true },
      gallery: { type: [String], default: [] },
    },
    spaceIdentifiers: {
      type: [String],
      default: [],
    },
    submission: {
      status: {
        type: String,
        enum: ["draft", "under_review", "approved", "rejected"],
        default: "draft",
        index: true,
      },
      currentStep: {
        type: Number,
        default: 1,
        min: 1,
        max: 6,
      },
      submittedAt: Date,
      reviewedAt: Date,
      reviewNote: {
        type: String,
        trim: true,
      },
      estimatedReviewHours: {
        type: Number,
        default: 2,
        min: 1,
      },
    },
    rules: {
      safetyNotice: {
        type: String,
        default: "Do not leave valuable objects visible inside your vehicle.",
      },
      cancellationPolicy: {
        type: String,
        default: "Free cancellation before the reservation starts.",
      },
    },
    bookingSettings: {
      maxDurationHours: { type: Number, default: 24, min: 1 },
      maxExtensionHours: { type: Number, default: 3, min: 0 },
      arrivalTimes: {
        type: [String],
        default: ["7:00 AM", "7:30 AM", "8:00 AM", "8:30 AM"],
      },
      durations: {
        type: [Number],
        default: [1, 2, 4, 6, 8, 24],
      },
    },
    status: {
      type: String,
      enum: ["draft", "under_review", "active", "inactive", "rejected"],
      default: "draft",
    },
  },
  { timestamps: true },
);

parkingSchema.index({ location: "2dsphere" });
parkingSchema.index({ name: "text", zone: "text", "address.city": "text" });
parkingSchema.index({ accessType: 1, status: 1 });
parkingSchema.index({ hostUser: 1, "submission.status": 1 });

module.exports = mongoose.model("Parking", parkingSchema);
