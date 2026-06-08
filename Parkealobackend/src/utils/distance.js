function toNumber(value) {
  const number = Number(value);
  return Number.isFinite(number) ? number : null;
}

function getCoordinatesFromQuery(query) {
  const latitude = toNumber(query.lat || query.latitude);
  const longitude = toNumber(query.lng || query.longitude);

  if (latitude === null || longitude === null) {
    return null;
  }

  return { latitude, longitude };
}

function getDistanceMeters(origin, parking) {
  const coordinates = parking.location && parking.location.coordinates;

  if (!origin || !Array.isArray(coordinates) || coordinates.length !== 2) {
    return null;
  }

  const [longitude, latitude] = coordinates;
  const earthRadiusMeters = 6371000;
  const toRadians = (degrees) => (degrees * Math.PI) / 180;
  const deltaLatitude = toRadians(latitude - origin.latitude);
  const deltaLongitude = toRadians(longitude - origin.longitude);
  const originLatitude = toRadians(origin.latitude);
  const parkingLatitude = toRadians(latitude);

  const a =
    Math.sin(deltaLatitude / 2) * Math.sin(deltaLatitude / 2) +
    Math.cos(originLatitude) *
      Math.cos(parkingLatitude) *
      Math.sin(deltaLongitude / 2) *
      Math.sin(deltaLongitude / 2);
  const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));

  return Math.round(earthRadiusMeters * c);
}

function formatDistance(meters) {
  if (meters === null || meters === undefined) {
    return null;
  }

  if (meters < 1000) {
    return `${meters} m`;
  }

  return `${(meters / 1000).toFixed(1)} km`;
}

module.exports = {
  formatDistance,
  getCoordinatesFromQuery,
  getDistanceMeters,
};
