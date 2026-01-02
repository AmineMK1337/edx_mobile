const Enrollment = require("../models/enrollment");
const User = require("../models/user");
const Course = require("../models/course");

// Get all enrollments
exports.getAllEnrollments = async (req, res) => {
  try {
    const enrollments = await Enrollment.find()
      .populate("student", "name email matricule")
      .populate("course", "title code")
      .populate("class", "name")
      .populate("academicYear", "year semester");
    res.json(enrollments);
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
};

// Get enrollments by student
exports.getEnrollmentsByStudent = async (req, res) => {
  try {
    const enrollments = await Enrollment.find({ student: req.params.studentId })
      .populate("course", "title code professor hoursPerWeek")
      .populate("class", "name")
      .populate("academicYear", "year semester")
      .populate({
        path: "course",
        populate: { path: "professor", select: "name email" }
      });
    res.json(enrollments);
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
};

// Get enrollments by course
exports.getEnrollmentsByCourse = async (req, res) => {
  try {
    const enrollments = await Enrollment.find({ course: req.params.courseId })
      .populate("student", "name email matricule")
      .populate("class", "name")
      .populate("academicYear", "year semester");
    res.json(enrollments);
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
};

// Get enrollments by class
exports.getEnrollmentsByClass = async (req, res) => {
  try {
    const enrollments = await Enrollment.find({ class: req.params.classId })
      .populate("student", "name email matricule")
      .populate("course", "title code")
      .populate("academicYear", "year semester");
    res.json(enrollments);
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
};

// Create new enrollment
exports.createEnrollment = async (req, res) => {
  const enrollment = new Enrollment(req.body);
  try {
    const newEnrollment = await enrollment.save();
    
    // Update student count in course
    await Course.findByIdAndUpdate(
      req.body.course,
      { $inc: { studentCount: 1 } }
    );
    
    const populatedEnrollment = await Enrollment.findById(newEnrollment._id)
      .populate("student", "name email")
      .populate("course", "title code")
      .populate("class", "name")
      .populate("academicYear", "year semester");
    
    res.status(201).json(populatedEnrollment);
  } catch (err) {
    res.status(400).json({ message: err.message });
  }
};

// Bulk enroll students (enroll entire class to a course)
exports.bulkEnrollClass = async (req, res) => {
  try {
    const { classId, courseId, academicYearId } = req.body;
    
    // Get all students in the class
    const students = await User.find({ class: classId, role: "student" });
    
    if (students.length === 0) {
      return res.status(404).json({ message: "No students found in this class" });
    }
    
    // Create enrollments for all students
    const enrollments = students.map(student => ({
      student: student._id,
      course: courseId,
      class: classId,
      academicYear: academicYearId,
      status: "active"
    }));
    
    const createdEnrollments = await Enrollment.insertMany(enrollments);
    
    // Update student count in course
    await Course.findByIdAndUpdate(
      courseId,
      { $inc: { studentCount: students.length } }
    );
    
    res.status(201).json({
      message: `Successfully enrolled ${students.length} students`,
      count: students.length,
      enrollments: createdEnrollments
    });
  } catch (err) {
    res.status(400).json({ message: err.message });
  }
};

// Update enrollment
exports.updateEnrollment = async (req, res) => {
  try {
    const updatedEnrollment = await Enrollment.findByIdAndUpdate(
      req.params.id,
      req.body,
      { new: true }
    )
      .populate("student", "name email")
      .populate("course", "title code")
      .populate("class", "name")
      .populate("academicYear", "year semester");
    
    if (!updatedEnrollment) {
      return res.status(404).json({ message: "Enrollment not found" });
    }
    res.json(updatedEnrollment);
  } catch (err) {
    res.status(400).json({ message: err.message });
  }
};

// Delete enrollment
exports.deleteEnrollment = async (req, res) => {
  try {
    const enrollment = await Enrollment.findById(req.params.id);
    if (!enrollment) {
      return res.status(404).json({ message: "Enrollment not found" });
    }
    
    // Update student count in course
    await Course.findByIdAndUpdate(
      enrollment.course,
      { $inc: { studentCount: -1 } }
    );
    
    await enrollment.deleteOne();
    res.json({ message: "Enrollment deleted successfully" });
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
};
