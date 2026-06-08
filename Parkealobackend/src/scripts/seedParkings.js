require("dotenv").config({ quiet: true });

const mongoose = require("mongoose");

const { connectDb } = require("../config/db");
const defaultParkings = require("../data/defaultParkings");
const Parking = require("../models/Parking");

async function seedParkings() {
  await connectDb();

  const operations = defaultParkings.map((parking) => ({
    updateOne: {
      filter: { slug: parking.slug },
      update: { $set: parking },
      upsert: true,
    },
  }));

  await Parking.bulkWrite(operations);
  console.log(`${defaultParkings.length} parking lots seeded`);
  await mongoose.disconnect();
}

seedParkings().catch(async (error) => {
  console.error("Failed to seed parking lots:", error.message);
  await mongoose.disconnect();
  process.exit(1);
});
