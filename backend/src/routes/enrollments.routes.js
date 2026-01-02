const express = require("express");
const router = express.Router();
const enrollmentsController = require("../controllers/enrollments.controller");
const { authenticate } = require("../middlewares/auth");

// Get all enrollments (admin and professors)
router.get("/", authenticate, enrollmentsController.getAllEnrollments);

// Get enrollments by student
router.get("/student/:studentId", authenticate, enrollmentsController.getEnrollmentsByStudent);

// Get enrollments by course
router.get("/course/:courseId", authenticate, enrollmentsController.getEnrollmentsByCourse);

// Get enrollments by class
router.get("/class/:classId", authenticate, enrollmentsController.getEnrollmentsByClass);

// Create new enrollment (admin only)
router.post("/", authenticate, enrollmentsController.createEnrollment);

// Bulk enroll class (admin only)
router.post("/bulk-enroll", authenticate, enrollmentsController.bulkEnrollClass);

// Update enrollment (admin only)
router.put("/:id", authenticate, enrollmentsController.updateEnrollment);

// Delete enrollment (admin only)
router.delete("/:id", authenticate, enrollmentsController.deleteEnrollment);

module.exports = router;
