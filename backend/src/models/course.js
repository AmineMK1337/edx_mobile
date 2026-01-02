const mongoose = require("mongoose");

const CourseSchema = new mongoose.Schema(
  {
    title: {
      type: String,
      required: true
    },
    code: {
      type: String,
      required: true,
      unique: true // e.g., "MATH101", "PHY201"
    },
    level: String,
    class: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "Class"
    },
    studentCount: {
      type: Number,
      default: 0
    },
    hoursPerWeek: {
      type: Number,
      required: true
    },
    nextDayTime: Date,
    location: String,
    professor: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "User"
    },
    academicYear: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "AcademicYear",
      required: true
    },
    isActive: {
      type: Boolean,
      default: true
    }
  },
  { timestamps: true }
);

// Indexes for faster queries
CourseSchema.index({ code: 1 });
CourseSchema.index({ professor: 1 });
CourseSchema.index({ class: 1 });
CourseSchema.index({ academicYear: 1 });

module.exports = mongoose.model("Course", CourseSchema);
