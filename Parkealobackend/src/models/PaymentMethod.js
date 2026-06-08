const mongoose = require("mongoose");

const paymentMethodSchema = new mongoose.Schema(
  {
    user: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "User",
      required: true,
      index: true,
    },
    brand: {
      type: String,
      enum: ["visa", "mastercard", "amex", "discover", "unknown"],
      default: "unknown",
    },
    cardholderName: {
      type: String,
      required: true,
      trim: true,
      maxlength: 100,
    },
    last4: {
      type: String,
      required: true,
      trim: true,
      minlength: 4,
      maxlength: 4,
    },
    expiryMonth: {
      type: Number,
      required: true,
      min: 1,
      max: 12,
    },
    expiryYear: {
      type: Number,
      required: true,
      min: 2020,
      max: 2100,
    },
    isDefault: {
      type: Boolean,
      default: false,
    },
    status: {
      type: String,
      enum: ["active", "expired", "disabled"],
      default: "active",
      index: true,
    },
  },
  { timestamps: true },
);

paymentMethodSchema.index({ user: 1, last4: 1, expiryMonth: 1, expiryYear: 1 });

module.exports = mongoose.model("PaymentMethod", paymentMethodSchema);
