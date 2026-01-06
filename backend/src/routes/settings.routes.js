const express = require("express");
const router = express.Router();
const settingsController = require("../controllers/settings.controller");

// Get user settings
router.get("/:userId", settingsController.getSettings);

// Update user settings
router.put("/:userId", settingsController.updateSettings);

// Update password
router.put("/:userId/password", settingsController.updatePassword);

module.exports = router;
