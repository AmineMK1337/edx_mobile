const mongoose = require("mongoose");

const EnrollmentSchema = new mongoose.Schema(
  {
    student: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "User",
      required: true
    },
    course: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "Course",
      required: true
    },
    class: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "Class",
      required: true
    },
    academicYear: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "AcademicYear",
      required: true
    },
    status: {
      type: String,
      enum: ["active", "completed", "dropped"],
      default: "active"
    },
    enrollmentDate: {
      type: Date,
      default: Date.now
    }
  },
  { timestamps: true }
);

// Ensure a student can only enroll once in a course per academic year
EnrollmentSchema.index(
  { student: 1, course: 1, academicYear: 1 },
  { unique: true }
);

// Index for faster queries
EnrollmentSchema.index({ student: 1 });
EnrollmentSchema.index({ course: 1 });
EnrollmentSchema.index({ class: 1 });
EnrollmentSchema.index({ academicYear: 1 });

module.exports = mongoose.model("Enrollment", EnrollmentSchema);
