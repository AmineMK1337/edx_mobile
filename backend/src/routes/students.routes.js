const express = require("express");
const router = express.Router();
const studentsController = require("../controllers/students.controller");

// Get all students
router.get("/", studentsController.getStudents);

// Get a single student by ID
router.get("/:id", studentsController.getStudentById);

// Get students by class
router.get("/class/:classId", studentsController.getStudentsByClass);

// Create a new student
router.post("/", studentsController.createStudent);

// Update student profile
router.put("/:id", studentsController.updateStudent);

// Delete (soft delete) a student
router.delete("/:id", studentsController.deleteStudent);

module.exports = router;
