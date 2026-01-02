const express = require("express");
const router = express.Router();
const attendanceController = require("../controllers/attendance.controller");

router.post("/mark", attendanceController.markAttendance);
router.get("/student/:studentId", attendanceController.getAttendanceByStudent);
router.get("/class/:className", attendanceController.getAttendanceByClass);
router.put("/:id", attendanceController.updateAttendance);

module.exports = router;
