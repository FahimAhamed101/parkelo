const bcrypt = require("bcryptjs");
const mongoose = require("mongoose");
const validator = require("validator");

const userSchema = new mongoose.Schema(
  {
    firstName: {
      type: String,
      required: [true, "First name is required"],
      trim: true,
      minlength: [2, "First name must be at least 2 characters"],
      maxlength: [50, "First name cannot exceed 50 characters"],
    },
    lastName: {
      type: String,
      required: [true, "Last name is required"],
      trim: true,
      minlength: [2, "Last name must be at least 2 characters"],
      maxlength: [50, "Last name cannot exceed 50 characters"],
    },
    email: {
      type: String,
      trim: true,
      lowercase: true,
      unique: true,
      sparse: true,
      validate: {
        validator(value) {
          return !value || validator.isEmail(value);
        },
        message: "Email is invalid",
      },
    },
    phoneNumber: {
      type: String,
      trim: true,
      unique: true,
      sparse: true,
      minlength: [7, "Phone number must be at least 7 digits"],
      maxlength: [20, "Phone number cannot exceed 20 characters"],
    },
    vehiclePlate: {
      type: String,
      trim: true,
      uppercase: true,
      unique: true,
      sparse: true,
      maxlength: [20, "Vehicle plate cannot exceed 20 characters"],
    },
    password: {
      type: String,
      select: false,
    },
    authProvider: {
      type: String,
      enum: ["local", "google", "apple", "facebook"],
      default: "local",
    },
    providerUserId: {
      type: String,
      trim: true,
      sparse: true,
    },
    role: {
      type: String,
      enum: ["user", "host", "admin"],
      default: "user",
    },
    hostProfile: {
      onboardingCompleted: {
        type: Boolean,
        default: false,
      },
      firstParkingSubmitted: {
        type: Boolean,
        default: false,
      },
      inviteCode: {
        type: String,
        trim: true,
        uppercase: true,
      },
      inviteRewardAmount: {
        type: Number,
        default: 500,
        min: 0,
      },
      defaultReservationMode: {
        type: String,
        enum: ["automatic", "manual"],
        default: "automatic",
      },
    },
    referralProfile: {
      code: {
        type: String,
        trim: true,
        uppercase: true,
        unique: true,
        sparse: true,
      },
      earnedAmount: {
        type: Number,
        default: 0,
        min: 0,
      },
      referredCount: {
        type: Number,
        default: 0,
        min: 0,
      },
      rewardPerReferral: {
        type: Number,
        default: 50,
        min: 0,
      },
    },
    preferences: {
      notifications: {
        bookingUpdates: {
          type: Boolean,
          default: true,
        },
        promotions: {
          type: Boolean,
          default: true,
        },
        referrals: {
          type: Boolean,
          default: true,
        },
        hostUpdates: {
          type: Boolean,
          default: true,
        },
      },
      language: {
        type: String,
        default: "en",
      },
    },
    isEmailVerified: {
      type: Boolean,
      default: false,
    },
    isPhoneVerified: {
      type: Boolean,
      default: false,
    },
    resetPasswordOtpHash: {
      type: String,
      select: false,
    },
    resetPasswordOtpExpiresAt: {
      type: Date,
      select: false,
    },
    resetPasswordAttempts: {
      type: Number,
      default: 0,
      select: false,
    },
    resetPasswordTokenHash: {
      type: String,
      select: false,
    },
    resetPasswordTokenExpiresAt: {
      type: Date,
      select: false,
    },
  },
  {
    timestamps: true,
  },
);

userSchema.index(
  { authProvider: 1, providerUserId: 1 },
  {
    unique: true,
    partialFilterExpression: {
      providerUserId: { $type: "string" },
    },
  },
);

userSchema.pre("save", async function hashPassword() {
  if (!this.isModified("password") || !this.password) {
    return;
  }

  this.password = await bcrypt.hash(this.password, 12);
});

userSchema.methods.comparePassword = function comparePassword(password) {
  return bcrypt.compare(password, this.password);
};

module.exports = mongoose.model("User", userSchema);
