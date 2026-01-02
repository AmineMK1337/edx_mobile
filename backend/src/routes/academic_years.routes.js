const express = require("express");
const router = express.Router();
const academicYearsController = require("../controllers/academic_years.controller");
const { authenticate } = require("../middlewares/auth");

// Get all academic years
router.get("/", authenticate, academicYearsController.getAllAcademicYears);

// Get current academic year
router.get("/current", authenticate, academicYearsController.getCurrentAcademicYear);

// Get academic year by ID
router.get("/:id", authenticate, academicYearsController.getAcademicYearById);

// Create new academic year (admin only)
router.post("/", authenticate, academicYearsController.createAcademicYear);

// Update academic year (admin only)
router.put("/:id", authenticate, academicYearsController.updateAcademicYear);

// Set current academic year (admin only)
router.put("/:id/set-current", authenticate, academicYearsController.setCurrentAcademicYear);

// Delete academic year (admin only)
router.delete("/:id", authenticate, academicYearsController.deleteAcademicYear);

module.exports = router;
