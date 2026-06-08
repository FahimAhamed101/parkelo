const express = require("express");

const {
  forgotPassword,
  getMe,
  resendResetCode,
  resetPassword,
  signin,
  signup,
  socialSignin,
  verifyResetCode,
} = require("../controllers/authController");
const { requireAuth } = require("../middleware/authMiddleware");

const router = express.Router();

router.post("/signup", signup);
router.post("/signin", signin);
router.post("/social-signin", socialSignin);
router.post("/forgot-password", forgotPassword);
router.post("/resend-reset-code", resendResetCode);
router.post("/verify-reset-code", verifyResetCode);
router.post("/reset-password", resetPassword);
router.get("/me", requireAuth, getMe);

module.exports = router;
