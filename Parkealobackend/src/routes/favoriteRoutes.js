const express = require("express");

const { addFavorite, listFavorites, removeFavorite } = require("../controllers/favoriteController");
const { requireAuth } = require("../middleware/authMiddleware");

const router = express.Router();

router.use(requireAuth);

router.get("/", listFavorites);
router.post("/", addFavorite);
router.post("/:parkingId", addFavorite);
router.delete("/:parkingId", removeFavorite);

module.exports = router;
