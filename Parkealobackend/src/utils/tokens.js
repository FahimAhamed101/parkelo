const crypto = require("crypto");
const jwt = require("jsonwebtoken");

function getJwtSecret() {
  if (process.env.JWT_SECRET) {
    return process.env.JWT_SECRET;
  }

  if (process.env.NODE_ENV === "production") {
    throw new Error("JWT_SECRET is required in production");
  }

  return "parkealo-development-secret-change-me";
}

function getPositiveIntegerEnv(name, fallback) {
  const value = Number.parseInt(process.env[name], 10);
  return Number.isInteger(value) && value > 0 ? value : fallback;
}

function signAccessToken(user, rememberMe = false) {
  return jwt.sign(
    {
      sub: user._id.toString(),
      role: user.role,
    },
    getJwtSecret(),
    {
      expiresIn: rememberMe
        ? process.env.JWT_REMEMBER_EXPIRES_IN || "30d"
        : process.env.JWT_EXPIRES_IN || "7d",
    },
  );
}

function signResetToken(user, resetTokenId) {
  const resetTokenTtlMinutes = getPositiveIntegerEnv("RESET_TOKEN_TTL_MINUTES", 10);

  return jwt.sign(
    {
      sub: user._id.toString(),
      purpose: "password_reset",
      resetTokenId,
    },
    getJwtSecret(),
    {
      expiresIn: `${resetTokenTtlMinutes}m`,
    },
  );
}

function verifyJwt(token) {
  return jwt.verify(token, getJwtSecret());
}

function generateOtp() {
  return crypto.randomInt(100000, 1000000).toString();
}

function generateResetTokenId() {
  return crypto.randomBytes(32).toString("hex");
}

function hashValue(value) {
  return crypto.createHash("sha256").update(String(value)).digest("hex");
}

function getResetCodeExpiresAt() {
  const ttlMinutes = getPositiveIntegerEnv("RESET_CODE_TTL_MINUTES", 10);
  return new Date(Date.now() + ttlMinutes * 60 * 1000);
}

function getResetTokenExpiresAt() {
  const ttlMinutes = getPositiveIntegerEnv("RESET_TOKEN_TTL_MINUTES", 10);
  return new Date(Date.now() + ttlMinutes * 60 * 1000);
}

function sanitizeUser(user) {
  const value = user.toObject ? user.toObject() : user;

  return {
    id: value._id.toString(),
    firstName: value.firstName,
    lastName: value.lastName,
    email: value.email,
    phoneNumber: value.phoneNumber,
    vehiclePlate: value.vehiclePlate,
    authProvider: value.authProvider,
    role: value.role,
    isEmailVerified: value.isEmailVerified,
    isPhoneVerified: value.isPhoneVerified,
    createdAt: value.createdAt,
    updatedAt: value.updatedAt,
  };
}

module.exports = {
  generateOtp,
  generateResetTokenId,
  getResetCodeExpiresAt,
  getResetTokenExpiresAt,
  hashValue,
  sanitizeUser,
  signAccessToken,
  signResetToken,
  verifyJwt,
};
