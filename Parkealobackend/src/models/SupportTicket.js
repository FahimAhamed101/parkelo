const mongoose = require("mongoose");

const supportTicketSchema = new mongoose.Schema(
  {
    user: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "User",
      required: true,
      index: true,
    },
    type: {
      type: String,
      enum: ["chat", "complaint", "email", "support_call", "faq"],
      required: true,
    },
    subject: {
      type: String,
      required: true,
      trim: true,
      maxlength: 120,
    },
    message: {
      type: String,
      required: true,
      trim: true,
      maxlength: 1000,
    },
    status: {
      type: String,
      enum: ["open", "in_progress", "closed"],
      default: "open",
      index: true,
    },
  },
  { timestamps: true },
);

supportTicketSchema.index({ user: 1, createdAt: -1 });

module.exports = mongoose.model("SupportTicket", supportTicketSchema);
