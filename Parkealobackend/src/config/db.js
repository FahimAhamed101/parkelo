const mongoose = require("mongoose");

async function connectDb() {
  const mongoUri = process.env.MONGODB_URI;
  const dbName = process.env.MONGODB_DB;

  if (!mongoUri) {
    throw new Error("MONGODB_URI is required");
  }

  mongoose.set("strictQuery", true);

  await mongoose.connect(mongoUri, {
    ...(dbName ? { dbName } : {}),
  });

  console.log(`MongoDB connected${dbName ? ` to ${dbName}` : ""}`);
}

module.exports = { connectDb };
