const mongoose = require("mongoose");

const ExamSchema = new mongoose.Schema(
  {
    title: {
      type: String,
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
    status: {
      type: String,
      enum: ["scheduled", "completed", "cancelled"],
      default: "scheduled"
    },
    date: {
      type: Date,
      required: true
    },
    startTime: {
      type: String,
      required: true // Format: "HH:mm"
    },
    studentCount: {
      type: Number,
      required: true
    },
    duration: {
      type: Number,
      required: true // Duration in minutes
    },
    location: {
      type: String,
      required: true
    },
    professor: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "User"
    },
    academicYear: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "AcademicYear",
      required: true
    }
  },
  { timestamps: true }
);

// Indexes for faster queries
ExamSchema.index({ course: 1, date: -1 });
ExamSchema.index({ class: 1, date: -1 });
ExamSchema.index({ date: -1 });
ExamSchema.index({ status: 1 });
ExamSchema.index({ academicYear: 1 });

module.exports = mongoose.model("Exam", ExamSchema);
