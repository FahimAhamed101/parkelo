const express = require("express");

const {
  createHostParking,
  approveManualRequest,
  getBankAccount,
  getHostAlerts,
  getDashboard,
  getHostOptions,
  getHostParking,
  getHostSummary,
  getIncome,
  getManualRequests,
  getPricing,
  getReview,
  getParkingQr,
  listHostParkings,
  declineManualRequest,
  requestWithdrawal,
  saveBankAccount,
  savePricing,
  startOnboarding,
  submitParking,
  updateDetailsStep,
  updateLocationStep,
  updatePhotosStep,
  updateServicesStep,
  updateSpacesStep,
} = require("../controllers/hostController");
const { requireAuth } = require("../middleware/authMiddleware");

const router = express.Router();

router.use(requireAuth);

router.get("/summary", getHostSummary);
router.post("/onboarding", startOnboarding);
router.get("/options", getHostOptions);
router.get("/dashboard", getDashboard);
router.get("/income", getIncome);
router.get("/alerts", getHostAlerts);
router.get("/manual-requests", getManualRequests);
router.post("/withdrawals", requestWithdrawal);
router.get("/bank-account", getBankAccount);
router.put("/bank-account", saveBankAccount);
router.get("/parkings", listHostParkings);
router.post("/parkings", createHostParking);
router.get("/parkings/:id", getHostParking);
router.get("/parkings/:id/qr", getParkingQr);
router.patch("/parkings/:id/location", updateLocationStep);
router.patch("/parkings/:id/details", updateDetailsStep);
router.patch("/parkings/:id/spaces", updateSpacesStep);
router.patch("/parkings/:id/services", updateServicesStep);
router.patch("/parkings/:id/photos", updatePhotosStep);
router.get("/parkings/:id/review", getReview);
router.post("/parkings/:id/submit", submitParking);
router.get("/parkings/:id/pricing", getPricing);
router.put("/parkings/:id/pricing", savePricing);
router.post("/requests/:bookingId/approve", approveManualRequest);
router.post("/requests/:bookingId/decline", declineManualRequest);

module.exports = router;
