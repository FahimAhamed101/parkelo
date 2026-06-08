const validator = require("validator");

const User = require("../models/User");
const { HttpError } = require("../utils/httpError");
const {
  generateOtp,
  generateResetTokenId,
  getResetCodeExpiresAt,
  getResetTokenExpiresAt,
  hashValue,
  sanitizeUser,
  signAccessToken,
  signResetToken,
  verifyJwt,
} = require("../utils/tokens");

const allowedSocialProviders = ["google", "apple", "facebook"];

function asyncHandler(handler) {
  return (req, res, next) => Promise.resolve(handler(req, res, next)).catch(next);
}

function cleanString(value) {
  return typeof value === "string" ? value.trim() : undefined;
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

function validatePassword(password, confirmPassword) {
  if (!password || typeof password !== "string") {
    throw new HttpError(400, "Password is required");
  }

  if (password.length < 6) {
    throw new HttpError(400, "Password must be at least 6 characters");
  }

  if (confirmPassword !== undefined && password !== confirmPassword) {
    throw new HttpError(400, "Passwords do not match");
  }
}

function validateEmail(email) {
  if (!email || !validator.isEmail(email)) {
    throw new HttpError(400, "A valid email is required");
  }
}

function isTermsAccepted(value) {
  return value === true || value === "true";
}

function isEnabled(value) {
  return value === true || value === "true";
}

async function issueResetCode(email) {
  const user = await User.findOne({ email }).select(
    "+resetPasswordOtpHash +resetPasswordOtpExpiresAt +resetPasswordAttempts +resetPasswordTokenHash +resetPasswordTokenExpiresAt",
  );

  if (!user) {
    return null;
  }

  const code = generateOtp();

  user.resetPasswordOtpHash = hashValue(code);
  user.resetPasswordOtpExpiresAt = getResetCodeExpiresAt();
  user.resetPasswordAttempts = 0;
  user.resetPasswordTokenHash = undefined;
  user.resetPasswordTokenExpiresAt = undefined;
  await user.save({ validateBeforeSave: false });

  if (process.env.NODE_ENV !== "production") {
    console.log(`Password reset code for ${email}: ${code}`);
  }

  return code;
}

function buildResetCodeResponse(code) {
  const response = {
    success: true,
    message: "If an account exists for that email, a reset code has been sent",
  };

  if (process.env.NODE_ENV !== "production" && code) {
    response.devResetCode = code;
  }

  return response;
}

const signup = asyncHandler(async (req, res) => {
  const firstName = cleanString(req.body.firstName);
  const lastName = cleanString(req.body.lastName || req.body.surname);
  const email = normalizeEmail(req.body.email);
  const phoneNumber = normalizePhoneNumber(req.body.phoneNumber);
  const vehiclePlate = normalizeVehiclePlate(req.body.vehiclePlate);
  const { password, confirmPassword } = req.body;

  if (!isTermsAccepted(req.body.termsAccepted)) {
    throw new HttpError(400, "Terms and conditions must be accepted");
  }

  if (!firstName || !lastName) {
    throw new HttpError(400, "First name and last name are required");
  }

  if (email && !validator.isEmail(email)) {
    throw new HttpError(400, "Email is invalid");
  }

  if (!phoneNumber || phoneNumber.length < 7) {
    throw new HttpError(400, "A valid phone number is required");
  }

  if (!vehiclePlate) {
    throw new HttpError(400, "Vehicle plate is required");
  }

  validatePassword(password, confirmPassword);

  const duplicateQueries = [{ phoneNumber }, { vehiclePlate }];

  if (email) {
    duplicateQueries.push({ email });
  }

  const existingUser = await User.findOne({ $or: duplicateQueries });

  if (existingUser) {
    if (email && existingUser.email === email) {
      throw new HttpError(409, "Email already exists");
    }

    if (existingUser.phoneNumber === phoneNumber) {
      throw new HttpError(409, "Phone number already exists");
    }

    throw new HttpError(409, "Vehicle plate already exists");
  }

  const user = await User.create({
    firstName,
    lastName,
    email,
    phoneNumber,
    vehiclePlate,
    password,
    authProvider: "local",
  });

  const token = signAccessToken(user);

  res.status(201).json({
    success: true,
    message: "Account created successfully",
    token,
    user: sanitizeUser(user),
  });
});

const signin = asyncHandler(async (req, res) => {
  const rawIdentifier = cleanString(req.body.identifier || req.body.emailOrPhone || req.body.email || req.body.phoneNumber);
  const { password } = req.body;

  if (!rawIdentifier || !password) {
    throw new HttpError(400, "Email/phone and password are required");
  }

  const identifier = validator.isEmail(rawIdentifier)
    ? normalizeEmail(rawIdentifier)
    : normalizePhoneNumber(rawIdentifier);

  const query = validator.isEmail(rawIdentifier)
    ? { email: identifier }
    : { phoneNumber: identifier };

  const user = await User.findOne(query).select("+password");

  if (!user || !user.password || !(await user.comparePassword(password))) {
    throw new HttpError(401, "Invalid email/phone or password");
  }

  const token = signAccessToken(user, isEnabled(req.body.rememberMe));

  res.json({
    success: true,
    message: "Signed in successfully",
    token,
    user: sanitizeUser(user),
  });
});

const forgotPassword = asyncHandler(async (req, res) => {
  const email = normalizeEmail(req.body.email);
  validateEmail(email);

  const code = await issueResetCode(email);

  res.json(buildResetCodeResponse(code));
});

const resendResetCode = asyncHandler(async (req, res) => {
  const email = normalizeEmail(req.body.email);
  validateEmail(email);

  const code = await issueResetCode(email);

  res.json(buildResetCodeResponse(code));
});

const verifyResetCode = asyncHandler(async (req, res) => {
  const email = normalizeEmail(req.body.email);
  const code = cleanString(req.body.code);

  validateEmail(email);

  if (!code || !/^\d{6}$/.test(code)) {
    throw new HttpError(400, "A valid 6-digit code is required");
  }

  const user = await User.findOne({ email }).select(
    "+resetPasswordOtpHash +resetPasswordOtpExpiresAt +resetPasswordAttempts +resetPasswordTokenHash +resetPasswordTokenExpiresAt",
  );

  if (!user || !user.resetPasswordOtpHash || !user.resetPasswordOtpExpiresAt) {
    throw new HttpError(400, "Invalid or expired verification code");
  }

  if (user.resetPasswordOtpExpiresAt.getTime() < Date.now()) {
    user.resetPasswordOtpHash = undefined;
    user.resetPasswordOtpExpiresAt = undefined;
    user.resetPasswordAttempts = 0;
    await user.save({ validateBeforeSave: false });
    throw new HttpError(400, "Invalid or expired verification code");
  }

  if (user.resetPasswordAttempts >= 5) {
    throw new HttpError(429, "Too many invalid attempts. Please request a new code");
  }

  if (hashValue(code) !== user.resetPasswordOtpHash) {
    user.resetPasswordAttempts += 1;
    await user.save({ validateBeforeSave: false });
    throw new HttpError(400, "Invalid or expired verification code");
  }

  const resetTokenId = generateResetTokenId();

  user.resetPasswordOtpHash = undefined;
  user.resetPasswordOtpExpiresAt = undefined;
  user.resetPasswordAttempts = 0;
  user.resetPasswordTokenHash = hashValue(resetTokenId);
  user.resetPasswordTokenExpiresAt = getResetTokenExpiresAt();
  await user.save({ validateBeforeSave: false });

  res.json({
    success: true,
    message: "Verification code accepted",
    resetToken: signResetToken(user, resetTokenId),
  });
});

const resetPassword = asyncHandler(async (req, res) => {
  const resetToken = cleanString(req.body.resetToken || req.body.token);
  const { newPassword, confirmPassword } = req.body;

  if (!resetToken) {
    throw new HttpError(400, "Reset token is required");
  }

  validatePassword(newPassword, confirmPassword);

  let payload;

  try {
    payload = verifyJwt(resetToken);
  } catch (error) {
    throw new HttpError(400, "Invalid or expired reset token");
  }

  if (payload.purpose !== "password_reset" || !payload.resetTokenId) {
    throw new HttpError(400, "Invalid or expired reset token");
  }

  const user = await User.findById(payload.sub).select(
    "+resetPasswordTokenHash +resetPasswordTokenExpiresAt +password",
  );

  if (
    !user ||
    !user.resetPasswordTokenHash ||
    !user.resetPasswordTokenExpiresAt ||
    user.resetPasswordTokenExpiresAt.getTime() < Date.now() ||
    hashValue(payload.resetTokenId) !== user.resetPasswordTokenHash
  ) {
    throw new HttpError(400, "Invalid or expired reset token");
  }

  user.password = newPassword;
  user.resetPasswordTokenHash = undefined;
  user.resetPasswordTokenExpiresAt = undefined;
  await user.save();

  res.json({
    success: true,
    message: "Password updated successfully",
  });
});

const socialSignin = asyncHandler(async (req, res) => {
  const provider = cleanString(req.body.provider);
  const providerUserId = cleanString(req.body.providerUserId);
  const email = normalizeEmail(req.body.email);
  const firstName = cleanString(req.body.firstName) || "Parkealo";
  const lastName = cleanString(req.body.lastName || req.body.surname) || "User";
  const phoneNumber = normalizePhoneNumber(req.body.phoneNumber);
  const vehiclePlate = normalizeVehiclePlate(req.body.vehiclePlate);

  if (!allowedSocialProviders.includes(provider)) {
    throw new HttpError(400, "Provider must be google, apple, or facebook");
  }

  if (!providerUserId) {
    throw new HttpError(400, "Provider user id is required");
  }

  if (email && !validator.isEmail(email)) {
    throw new HttpError(400, "Email is invalid");
  }

  let user = await User.findOne({ authProvider: provider, providerUserId });

  if (!user && email) {
    user = await User.findOne({ email });
  }

  if (!user) {
    user = await User.create({
      firstName,
      lastName,
      email,
      phoneNumber,
      vehiclePlate,
      authProvider: provider,
      providerUserId,
      isEmailVerified: Boolean(email),
    });
  } else if (user.authProvider === "local") {
    user.authProvider = provider;
    user.providerUserId = providerUserId;
    await user.save({ validateBeforeSave: false });
  }

  const token = signAccessToken(user, true);

  res.json({
    success: true,
    message: "Signed in successfully",
    token,
    user: sanitizeUser(user),
  });
});

const getMe = asyncHandler(async (req, res) => {
  res.json({
    success: true,
    user: sanitizeUser(req.user),
  });
});

module.exports = {
  forgotPassword,
  getMe,
  resendResetCode,
  resetPassword,
  signin,
  signup,
  socialSignin,
  verifyResetCode,
};
