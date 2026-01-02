const Absence = require("../models/absence");
const User = require("../models/user");
const Course = require("../models/course");
const Class = require("../models/class");
const AcademicYear = require("../models/academic_year");

exports.markAttendance = async (req, res) => {
  try {
    const { students, courseId, classId, subject, className, sessionType, date } = req.body;

    // Handle both old (subject/className) and new (courseId/classId) formats
    let finalCourseId = courseId;
    let finalClassId = classId;

    // If IDs not provided, try to find by names (backward compatibility)
    if (!finalCourseId && subject) {
      const course = await Course.findOne({ title: subject });
      if (course) finalCourseId = course._id;
    }

    if (!finalClassId && className) {
      const classObj = await Class.findOne({ name: className });
      if (classObj) finalClassId = classObj._id;
    }

    // Validate required fields
    if (!finalCourseId || !finalClassId) {
      return res.status(400).json({ 
        error: "Course and Class are required. Provide either courseId/classId or subject/className" 
      });
    }

    // Get current academic year
    const currentAcademicYear = await AcademicYear.findOne({ isCurrent: true });
    if (!currentAcademicYear) {
      return res.status(400).json({ error: "No current academic year found" });
    }

    // students should be an array of { studentId, status }
    const attendanceRecords = [];

    for (const student of students) {
      const absence = new Absence({
        student: student.studentId,
        course: finalCourseId,
        class: finalClassId,
        sessionType: sessionType || "course",
        date: new Date(date || Date.now()),
        status: student.status || "absent",
        takenBy: req.user?.id || null,
        academicYear: currentAcademicYear._id
      });

      await absence.save();
      // Populate related data
      await absence.populate([
        { path: "student", select: "name email matricule" },
        { path: "course", select: "title code" },
        { path: "class", select: "name level" },
        { path: "takenBy", select: "name email" }
      ]);
      attendanceRecords.push(absence);
    }

    res.status(201).json({
      message: "Attendance marked successfully",
      records: attendanceRecords
    });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

exports.getAttendanceByStudent = async (req, res) => {
  try {
    const { studentId } = req.params;
    const absences = await Absence.find({ student: studentId })
      .populate("student", "name email")
      .populate("course", "title code")
      .populate("class", "name level")
      .populate("takenBy", "name email")
      .sort({ date: -1 });

    res.json(absences);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

exports.getAttendanceByClass = async (req, res) => {
  try {
    const { classId } = req.params;
    const absences = await Absence.find({ class: classId })
      .populate("student", "name email matricule")
      .populate("course", "title code")
      .populate("class", "name level")
      .populate("takenBy", "name email")
      .sort({ date: -1 });

    res.json(absences);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

exports.updateAttendance = async (req, res) => {
  try {
    const { id } = req.params;
    const { status } = req.body;

    const absence = await Absence.findByIdAndUpdate(
      id,
      { status },
      { new: true }
    )
      .populate("student", "name email matricule")
      .populate("course", "title code")
      .populate("class", "name level");

    if (!absence) {
      return res.status(404).json({ error: "Attendance record not found" });
    }

    res.json(absence);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};
