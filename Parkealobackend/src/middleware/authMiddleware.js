const User = require("../models/User");
const { HttpError } = require("../utils/httpError");
const { verifyJwt } = require("../utils/tokens");

async function requireAuth(req, res, next) {
  try {
    const authorization = req.headers.authorization || "";
    const [scheme, token] = authorization.split(" ");

    if (scheme !== "Bearer" || !token) {
      throw new HttpError(401, "Authentication token is required");
    }

    const payload = verifyJwt(token);

    if (payload.purpose) {
      throw new HttpError(401, "Invalid authentication token");
    }

    const user = await User.findById(payload.sub);

    if (!user) {
      throw new HttpError(401, "User no longer exists");
    }

    req.user = user;
    req.auth = payload;
    return next();
  } catch (error) {
    if (error.name === "JsonWebTokenError" || error.name === "TokenExpiredError") {
      return next(new HttpError(401, "Invalid or expired authentication token"));
    }

    return next(error);
  }
}

module.exports = { requireAuth };
