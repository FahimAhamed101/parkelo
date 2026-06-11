const express = require("express");

const {
  checkInBooking,
  checkOutBooking,
  createBooking,
  createPaymentIntent,
  extendBooking,
  getBooking,
  getDirections,
  getExtensionOptions,
  listBookings,
  notifyHost,
  quoteBooking,
  quoteExtension,
  safetyCheck,
} = require("../controllers/bookingController");
const { requireAuth } = require("../middleware/authMiddleware");

const router = express.Router();

router.post("/quote", quoteBooking);
router.post("/safety-check", safetyCheck);

router.use(requireAuth);

router.get("/", listBookings);
router.post("/payment-intent", createPaymentIntent);
router.post("/", createBooking);
router.get("/:id", getBooking);
router.post("/:id/notify-host", notifyHost);
router.post("/:id/check-in", checkInBooking);
router.post("/:id/check-out", checkOutBooking);
router.get("/:id/extension-options", getExtensionOptions);
router.post("/:id/extension-quote", quoteExtension);
router.post("/:id/extend", extendBooking);
router.get("/:id/directions", getDirections);

module.exports = router;
