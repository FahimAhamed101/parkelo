const mongoose = require("mongoose");

const hostBankAccountSchema = new mongoose.Schema(
  {
    user: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "User",
      required: true,
      unique: true,
      index: true,
    },
    bankName: {
      type: String,
      required: true,
      trim: true,
    },
    accountType: {
      type: String,
      enum: ["checking", "savings"],
      required: true,
    },
    accountNumberLast4: {
      type: String,
      required: true,
      trim: true,
      maxlength: 4,
    },
    accountHolderName: {
      type: String,
      required: true,
      trim: true,
    },
    identityDocument: {
      type: String,
      required: true,
      trim: true,
    },
    status: {
      type: String,
      enum: ["pending_verification", "verified", "rejected"],
      default: "pending_verification",
    },
  },
  { timestamps: true },
);

module.exports = mongoose.model("HostBankAccount", hostBankAccountSchema);
