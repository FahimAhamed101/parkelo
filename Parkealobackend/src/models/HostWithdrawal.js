const mongoose = require("mongoose");

const hostWithdrawalSchema = new mongoose.Schema(
  {
    user: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "User",
      required: true,
      index: true,
    },
    bankAccount: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "HostBankAccount",
      required: true,
    },
    amount: {
      type: Number,
      required: true,
      min: 1,
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
      enum: ["requested", "processing", "paid", "cancelled"],
      default: "requested",
      index: true,
    },
    requestedAt: {
      type: Date,
      default: Date.now,
    },
    processedAt: Date,
  },
  { timestamps: true },
);

hostWithdrawalSchema.index({ user: 1, status: 1, requestedAt: -1 });

module.exports = mongoose.model("HostWithdrawal", hostWithdrawalSchema);
