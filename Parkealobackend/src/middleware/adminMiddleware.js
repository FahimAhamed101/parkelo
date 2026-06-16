const { HttpError } = require("../utils/httpError");

function requireAdmin(req, res, next) {
  if (req.user?.role !== "admin") {
    return next(new HttpError(403, "Admin access is required"));
  }

  return next();
}

module.exports = { requireAdmin };
