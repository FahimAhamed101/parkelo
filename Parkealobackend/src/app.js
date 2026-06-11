const express = require("express");
const cors = require("cors");
const path = require("path");

const accountRoutes = require("./routes/accountRoutes");
const authRoutes = require("./routes/authRoutes");
const bookingRoutes = require("./routes/bookingRoutes");
const favoriteRoutes = require("./routes/favoriteRoutes");
const hostRoutes = require("./routes/hostRoutes");
const parkingRoutes = require("./routes/parkingRoutes");
const { HttpError } = require("./utils/httpError");

const app = express();

const corsOrigins = process.env.CORS_ORIGIN
  ? process.env.CORS_ORIGIN.split(",").map((origin) => origin.trim()).filter(Boolean)
  : true;

function redactRequestBody(value) {
  if (!value || typeof value !== "object") {
    return value;
  }

  const sensitiveKeys = new Set([
    "authorization",
    "confirmPassword",
    "currentPassword",
    "jwt",
    "newPassword",
    "password",
    "refreshToken",
    "secret",
    "token",
  ]);

  if (Array.isArray(value)) {
    return value.map(redactRequestBody);
  }

  return Object.fromEntries(
    Object.entries(value).map(([key, item]) => [
      key,
      sensitiveKeys.has(key.toLowerCase()) ? "[REDACTED]" : redactRequestBody(item),
    ]),
  );
}

function requestLogger(req, res, next) {
  const startedAt = Date.now();
  const ip = req.ip || req.socket?.remoteAddress || "unknown";
  const query = Object.keys(req.query || {}).length ? ` query=${JSON.stringify(req.query)}` : "";

  console.log(`[request] ${req.method} ${req.originalUrl} ip=${ip}${query}`);

  res.on("finish", () => {
    const body = redactRequestBody(req.body);
    const hasBody = body && typeof body === "object" && Object.keys(body).length > 0;

    console.log(
      `[response] ${req.method} ${req.originalUrl} status=${res.statusCode} durationMs=${Date.now() - startedAt}${
        hasBody ? ` body=${JSON.stringify(body)}` : ""
      }`,
    );
  });

  next();
}

app.use(requestLogger);
app.use(cors({ origin: corsOrigins, credentials: true }));
app.use(express.json({ limit: "28mb" }));
app.use("/uploads", express.static(path.join(__dirname, "..", "uploads")));

app.get("/api/health", (req, res) => {
  res.json({
    success: true,
    message: "Parkealo API is running",
  });
});

app.use("/api/auth", authRoutes);
app.use("/api/account", accountRoutes);
app.use("/api/parkings", parkingRoutes);
app.use("/api/bookings", bookingRoutes);
app.use("/api/favorites", favoriteRoutes);
app.use("/api/host", hostRoutes);

app.use((req, res, next) => {
  next(new HttpError(404, "Route not found"));
});

app.use((error, req, res, next) => {
  const statusCode = error.statusCode || 500;
  const body = redactRequestBody(req.body);
  const hasBody = body && typeof body === "object" && Object.keys(body).length > 0;

  console.error("[error]", {
    method: req.method,
    url: req.originalUrl,
    status: statusCode,
    message: error.message,
    details: error.details,
    body: hasBody ? body : undefined,
  });

  if (error.name === "ValidationError") {
    const errors = Object.values(error.errors).map((item) => ({
      field: item.path,
      message: item.message,
    }));

    return res.status(400).json({
      success: false,
      message: "Validation failed",
      errors,
    });
  }

  if (error.code === 11000) {
    const field = Object.keys(error.keyPattern || error.keyValue || {})[0] || "field";

    return res.status(409).json({
      success: false,
      message: `${field} already exists`,
    });
  }

  if (statusCode === 500 && process.env.NODE_ENV !== "test") {
    console.error(error.stack || error);
  }

  return res.status(statusCode).json({
    success: false,
    message: statusCode === 500 ? "Internal server error" : error.message,
    ...(error.details ? { details: error.details } : {}),
  });
});

module.exports = app;
