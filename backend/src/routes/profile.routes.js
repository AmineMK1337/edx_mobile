const express = require("express");
const router = express.Router();
const profileController = require("../controllers/profile.controller");

// Get student profile
router.get("/:id", profileController.getProfile);

// Update student profile
router.put("/:id", profileController.updateProfile);

module.exports = router;
