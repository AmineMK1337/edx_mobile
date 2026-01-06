const express = require("express");
const router = express.Router();
const schoolInfoController = require("../controllers/school_info.controller");

// Get school info (About page)
router.get("/", schoolInfoController.getSchoolInfo);

// Update school info (Admin only)
router.put("/", schoolInfoController.updateSchoolInfo);

module.exports = router;
