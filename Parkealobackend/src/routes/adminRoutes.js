const express = require("express");

const {
  getDashboard,
  createUser,
  deleteUser,
  listBookings,
  listParkings,
  listSupportTickets,
  listUsers,
  listWithdrawals,
  updateBooking,
  updateParking,
  updateSupportTicket,
  updateUser,
  updateWithdrawal,
} = require("../controllers/adminController");
const { requireAdmin } = require("../middleware/adminMiddleware");
const { requireAuth } = require("../middleware/authMiddleware");

const router = express.Router();

router.use(requireAuth, requireAdmin);

router.get("/dashboard", getDashboard);
router.get("/users", listUsers);
router.post("/users", createUser);
router.patch("/users/:id", updateUser);
router.delete("/users/:id", deleteUser);
router.get("/parkings", listParkings);
router.patch("/parkings/:id", updateParking);
router.get("/bookings", listBookings);
router.patch("/bookings/:id", updateBooking);
router.get("/withdrawals", listWithdrawals);
router.patch("/withdrawals/:id", updateWithdrawal);
router.get("/support", listSupportTickets);
router.patch("/support/:id", updateSupportTicket);

module.exports = router;
