const mongoose = require("mongoose");

const referralSchema = new mongoose.Schema(
  {
    owner: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "User",
      required: true,
      index: true,
    },
    referredUser: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "User",
      index: true,
      sparse: true,
    },
    referredName: {
      type: String,
      required: true,
      trim: true,
    },
    amount: {
      type: Number,
      default: 50,
      min: 0,
    },
    currency: {
      type: String,
      default: "DOP",
    },
    currencySymbol: {
      type: String,
      default: "RD$",
    },
    status: {
      type: String,
      enum: ["pending", "earned", "paid"],
      default: "pending",
      index: true,
    },
    firstReservationAt: Date,
    earnedAt: Date,
  },
  { timestamps: true },
);

referralSchema.index({ owner: 1, status: 1, createdAt: -1 });

module.exports = mongoose.model("Referral", referralSchema);
