const Favorite = require("../models/Favorite");
const Parking = require("../models/Parking");
const { HttpError } = require("../utils/httpError");
const { presentParking } = require("./parkingController");

function asyncHandler(handler) {
  return (req, res, next) => Promise.resolve(handler(req, res, next)).catch(next);
}

function cleanString(value) {
  return typeof value === "string" ? value.trim() : undefined;
}

async function findParking(value) {
  const parkingId = cleanString(value);

  if (!parkingId) {
    throw new HttpError(400, "Parking id is required");
  }

  const query = /^[a-f\d]{24}$/i.test(parkingId)
    ? { _id: parkingId, status: "active" }
    : { slug: parkingId.toLowerCase(), status: "active" };
  const parking = await Parking.findOne(query);

  if (!parking) {
    throw new HttpError(404, "Parking lot not found");
  }

  return parking;
}

const listFavorites = asyncHandler(async (req, res) => {
  const favorites = await Favorite.find({ user: req.user._id })
    .sort({ createdAt: -1 })
    .populate("parking");
  const activeFavorites = favorites.filter((favorite) => favorite.parking && favorite.parking.status === "active");

  res.json({
    success: true,
    message: activeFavorites.length
      ? `${activeFavorites.length} favorite parking lots found`
      : "You do not have favorites yet",
    count: activeFavorites.length,
    parkings: activeFavorites.map((favorite) => presentParking(favorite.parking)),
  });
});

const addFavorite = asyncHandler(async (req, res) => {
  const parking = await findParking(req.params.parkingId || req.body.parkingId);
  await Favorite.updateOne(
    { user: req.user._id, parking: parking._id },
    { $setOnInsert: { user: req.user._id, parking: parking._id } },
    { upsert: true },
  );

  res.status(201).json({
    success: true,
    message: "Parking lot added to favorites",
    parking: presentParking(parking),
  });
});

const removeFavorite = asyncHandler(async (req, res) => {
  const parking = await findParking(req.params.parkingId || req.body.parkingId);
  await Favorite.deleteOne({ user: req.user._id, parking: parking._id });

  res.json({
    success: true,
    message: "Parking lot removed from favorites",
  });
});

module.exports = {
  addFavorite,
  listFavorites,
  removeFavorite,
};
