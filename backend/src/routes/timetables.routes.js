const express = require("express");
const router = express.Router();
const timetableController = require("../controllers/timetables.controller");
const { authenticate } = require("../middlewares/auth");
const { adminAuth } = require("../middlewares/adminAuth");

// Get all timetables (for admin)
router.get(
  "/",
  authenticate,
  adminAuth,
  timetableController.getAllTimetables
);

// Get timetables by class (for students and professors)
router.get(
  "/class/:classId",
  authenticate,
  timetableController.getTimetablesByClass
);

// Get timetable by ID
router.get(
  "/:id",
  authenticate,
  timetableController.getTimetableById
);

// Upload new timetable (admin only)
router.post(
  "/upload",
  authenticate,
  adminAuth,
  timetableController.upload.single("pdfFile"),
  timetableController.uploadTimetable
);

// Download timetable PDF
router.get(
  "/download/:id",
  authenticate,
  timetableController.downloadTimetable
);

// Delete timetable (admin only)
router.delete(
  "/:id",
  authenticate,
  adminAuth,
  timetableController.deleteTimetable
);

module.exports = router;