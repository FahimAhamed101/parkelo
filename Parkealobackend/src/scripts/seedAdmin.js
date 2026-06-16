require("dotenv").config({ quiet: true });

const mongoose = require("mongoose");

const User = require("../models/User");

async function seedAdmin() {
  if (!process.env.MONGODB_URI) {
    throw new Error("MONGODB_URI is required");
  }

  await mongoose.connect(process.env.MONGODB_URI, {
    ...(process.env.MONGODB_DB ? { dbName: process.env.MONGODB_DB } : {}),
  });

  const email = process.env.ADMIN_EMAIL || "admin@admin.com";
  const password = process.env.ADMIN_PASSWORD || "admin1234";
  let user = await User.findOne({ email }).select("+password");

  if (!user) {
    user = new User({
      firstName: "Parkealo",
      lastName: "Admin",
      email,
      phoneNumber: process.env.ADMIN_PHONE || "+10000000000",
      vehiclePlate: process.env.ADMIN_VEHICLE_PLATE || "ADMIN1",
      role: "admin",
      authProvider: "local",
      isEmailVerified: true,
      isPhoneVerified: true,
    });
  }

  user.firstName = user.firstName || "Parkealo";
  user.lastName = user.lastName || "Admin";
  user.role = "admin";
  user.authProvider = "local";
  user.isEmailVerified = true;
  user.password = password;

  await user.save({ validateBeforeSave: false });

  console.log(`Admin user ready: ${email} / ${password}`);
  await mongoose.disconnect();
}

seedAdmin().catch(async (error) => {
  console.error("Failed to seed admin user:", error.message);
  await mongoose.disconnect().catch(() => {});
  process.exit(1);
});
