const mongoose = require("mongoose");

const Parking = require("../models/Parking");
const { formatDistance, getCoordinatesFromQuery, getDistanceMeters } = require("../utils/distance");
const { HttpError } = require("../utils/httpError");
const { formatMoney } = require("../utils/pricing");

function asyncHandler(handler) {
  return (req, res, next) => Promise.resolve(handler(req, res, next)).catch(next);
}

function cleanString(value) {
  return typeof value === "string" ? value.trim() : undefined;
}

function escapeRegex(value) {
  return value.replace(/[.*+?^${}()|[\]\\]/g, "\\$&");
}

function parseList(value) {
  if (!value) {
    return [];
  }

  return String(value)
    .split(",")
    .map((item) => item.trim().toLowerCase())
    .filter(Boolean);
}

function getParkingCoordinates(parking) {
  const coordinates = parking.location && parking.location.coordinates;

  if (!Array.isArray(coordinates) || coordinates.length !== 2) {
    return null;
  }

  return {
    latitude: coordinates[1],
    longitude: coordinates[0],
  };
}

function presentParking(parking, options = {}) {
  const distanceMeters = getDistanceMeters(options.origin, parking);
  const coordinates = getParkingCoordinates(parking);
  const services = (parking.services || []).map((service) => ({
    code: service.code,
    label: service.label,
  }));

  const response = {
    id: parking._id.toString(),
    name: parking.name,
    slug: parking.slug,
    description: parking.description,
    zone: parking.zone,
    address: parking.address,
    coordinates,
    accessType: parking.accessType,
    approvalMode: parking.approvalMode,
    vehicleTypes: parking.vehicleTypes,
    services,
    rate: {
      hourly: parking.rate.hourly,
      currency: parking.rate.currency,
      currencySymbol: parking.rate.currencySymbol,
      label: `${formatMoney(parking.rate.hourly, parking.rate.currencySymbol)}/hour`,
    },
    rating: parking.rating,
    availability: parking.availability,
    host: parking.host,
    media: parking.media,
    distance: {
      meters: distanceMeters,
      label: formatDistance(distanceMeters),
    },
    badges: [
      parking.accessType === "public" ? "Public" : "Private",
      parking.approvalMode === "automatic" ? "Automatic" : "Host approval",
    ],
  };

  if (options.includeDetails) {
    response.rules = parking.rules;
    response.insurance = parking.insurance;
    response.bookingOptions = {
      arrivalTimes: parking.bookingSettings.arrivalTimes,
      durations: parking.bookingSettings.durations.map((hours) => ({
        hours,
        label: hours === 24 ? "All day" : `${hours}h`,
      })),
      maxDurationHours: parking.bookingSettings.maxDurationHours,
      maxExtensionHours: parking.bookingSettings.maxExtensionHours,
      paymentMethods: [
        { code: "card", label: "Credit card / debit card" },
        { code: "cash", label: "Cash at parking" },
      ],
      safetyNotice: parking.rules.safetyNotice,
    };
  }

  return response;
}

async function findParkingByIdOrSlug(value) {
  const idOrSlug = cleanString(value);

  if (!idOrSlug) {
    return null;
  }

  if (mongoose.Types.ObjectId.isValid(idOrSlug)) {
    return Parking.findOne({
      $or: [{ _id: idOrSlug }, { slug: idOrSlug.toLowerCase() }],
      status: "active",
    });
  }

  return Parking.findOne({ slug: idOrSlug.toLowerCase(), status: "active" });
}

const listParkings = asyncHandler(async (req, res) => {
  const origin = getCoordinatesFromQuery(req.query);
  const search = cleanString(req.query.search || req.query.q);
  const accessType = cleanString(req.query.accessType);
  const vehicleType = cleanString(req.query.vehicleType);
  const services = parseList(req.query.services || req.query.service);
  const page = Math.max(Number.parseInt(req.query.page, 10) || 1, 1);
  const limit = Math.min(Math.max(Number.parseInt(req.query.limit, 10) || 20, 1), 100);
  const sort = cleanString(req.query.sort) || "recommended";
  const filter = { status: "active" };

  if (search) {
    const regex = new RegExp(escapeRegex(search), "i");
    filter.$or = [{ name: regex }, { zone: regex }, { "address.city": regex }];
  }

  if (accessType) {
    filter.accessType = accessType.toLowerCase();
  }

  if (vehicleType) {
    filter.vehicleTypes = vehicleType.toLowerCase();
  }

  if (services.length) {
    filter["services.code"] = { $all: services };
  }

  let parkings = await Parking.find(filter);

  if (sort === "nearest" && origin) {
    parkings = parkings.sort((left, right) => {
      const leftDistance = getDistanceMeters(origin, left) ?? Number.MAX_SAFE_INTEGER;
      const rightDistance = getDistanceMeters(origin, right) ?? Number.MAX_SAFE_INTEGER;
      return leftDistance - rightDistance;
    });
  } else if (sort === "price_low") {
    parkings = parkings.sort((left, right) => left.rate.hourly - right.rate.hourly);
  } else if (sort === "price_high") {
    parkings = parkings.sort((left, right) => right.rate.hourly - left.rate.hourly);
  } else if (sort === "available") {
    parkings = parkings.sort(
      (left, right) => right.availability.availableSpaces - left.availability.availableSpaces,
    );
  } else if (sort === "rating") {
    parkings = parkings.sort((left, right) => right.rating.average - left.rating.average);
  } else {
    parkings = parkings.sort((left, right) => {
      const leftScore = left.rating.average * 10 + left.availability.availableSpaces;
      const rightScore = right.rating.average * 10 + right.availability.availableSpaces;
      return rightScore - leftScore;
    });
  }

  const total = parkings.length;
  const pagedParkings = parkings.slice((page - 1) * limit, page * limit);
  const results = pagedParkings.map((parking) => presentParking(parking, { origin }));

  res.json({
    success: true,
    message: `${total} parking ${total === 1 ? "lot" : "lots"} found`,
    page,
    limit,
    total,
    parkings: results,
    mapMarkers: results.map((parking) => ({
      id: parking.id,
      name: parking.name,
      coordinates: parking.coordinates,
      hourlyRate: parking.rate.hourly,
      priceLabel: parking.rate.label,
      accessType: parking.accessType,
      availableSpaces: parking.availability.availableSpaces,
    })),
  });
});

const getParking = asyncHandler(async (req, res) => {
  const parking = await findParkingByIdOrSlug(req.params.id);

  if (!parking) {
    throw new HttpError(404, "Parking lot not found");
  }

  res.json({
    success: true,
    parking: presentParking(parking, {
      origin: getCoordinatesFromQuery(req.query),
      includeDetails: true,
    }),
  });
});

module.exports = {
  findParkingByIdOrSlug,
  getParking,
  listParkings,
  presentParking,
};
