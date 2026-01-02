const express = require("express");
const router = express.Router();
const classesController = require("../controllers/classes.controller");
const { authenticate } = require("../middlewares/auth");

// Get all classes
router.get("/", authenticate, classesController.getAllClasses);

// Get class by ID
router.get("/:id", authenticate, classesController.getClassById);

// Get classes by academic year
router.get("/academic-year/:academicYearId", authenticate, classesController.getClassesByAcademicYear);

// Create new class (admin only)
router.post("/", authenticate, classesController.createClass);

// Update class (admin only)
router.put("/:id", authenticate, classesController.updateClass);

// Delete class (admin only)
router.delete("/:id", authenticate, classesController.deleteClass);

module.exports = router;
