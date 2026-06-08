const mongoose = require("mongoose");

const vehicleSchema = new mongoose.Schema(
  {
    user: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "User",
      required: true,
      index: true,
    },
    type: {
      type: String,
      enum: ["sedan", "suv_4x4", "pickup", "coupe", "minivan_van", "motorcycle"],
      required: true,
    },
    plate: {
      type: String,
      required: true,
      trim: true,
      uppercase: true,
      maxlength: 20,
    },
    brand: {
      type: String,
      required: true,
      trim: true,
      maxlength: 80,
    },
    model: {
      type: String,
      required: true,
      trim: true,
      maxlength: 80,
    },
    year: {
      type: Number,
      min: 1900,
      max: 2100,
    },
    color: {
      type: String,
      trim: true,
      maxlength: 40,
    },
    notes: {
      type: String,
      trim: true,
      maxlength: 500,
    },
    isPrimary: {
      type: Boolean,
      default: false,
    },
  },
  { timestamps: true },
);

vehicleSchema.index({ user: 1, plate: 1 }, { unique: true });
vehicleSchema.index({ user: 1, isPrimary: 1 });

module.exports = mongoose.model("Vehicle", vehicleSchema);
