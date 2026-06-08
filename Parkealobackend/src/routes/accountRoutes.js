const express = require("express");

const {
  createPaymentMethod,
  createReferral,
  createSupportTicket,
  createVehicle,
  deletePaymentMethod,
  deleteVehicle,
  getLegalIndex,
  getPrivacy,
  getProfile,
  getReferrals,
  getSettings,
  getSupport,
  getTerms,
  getVehicle,
  listPaymentMethods,
  listVehicles,
  logout,
  setDefaultPaymentMethod,
  setDefaultVehicle,
  updateProfile,
  updateSettings,
  updateVehicle,
} = require("../controllers/accountController");
const { requireAuth } = require("../middleware/authMiddleware");

const router = express.Router();

router.use(requireAuth);

router.get("/profile", getProfile);
router.patch("/profile", updateProfile);
router.post("/logout", logout);

router.get("/vehicles", listVehicles);
router.post("/vehicles", createVehicle);
router.get("/vehicles/:id", getVehicle);
router.patch("/vehicles/:id", updateVehicle);
router.patch("/vehicles/:id/default", setDefaultVehicle);
router.delete("/vehicles/:id", deleteVehicle);

router.get("/payment-methods", listPaymentMethods);
router.post("/payment-methods", createPaymentMethod);
router.patch("/payment-methods/:id/default", setDefaultPaymentMethod);
router.delete("/payment-methods/:id", deletePaymentMethod);

router.get("/referrals", getReferrals);
router.post("/referrals", createReferral);

router.get("/settings", getSettings);
router.patch("/settings", updateSettings);

router.get("/legal", getLegalIndex);
router.get("/legal/terms", getTerms);
router.get("/legal/privacy", getPrivacy);

router.get("/support", getSupport);
router.post("/support/tickets", createSupportTicket);

module.exports = router;
