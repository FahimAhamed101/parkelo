const express = require("express");

const { getParking, listParkings } = require("../controllers/parkingController");

const router = express.Router();

router.get("/", listParkings);
router.get("/:id", getParking);

module.exports = router;
