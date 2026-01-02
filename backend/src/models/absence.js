const mongoose = require("mongoose");

const AbsenceSchema = new mongoose.Schema(
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
    sessionType: {
      type: String,
      enum: ["course", "tp", "td", "exam"],
      default: "course"
    },
    date: {
      type: Date,
      required: true
    },
    status: {
      type: String,
      enum: ["present", "absent", "late", "justified"],
      required: true,
      default: "absent"
    },
    justificationDocument: String, // URL or path to uploaded file
    takenBy: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "User", // prof
      default: null
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
AbsenceSchema.index({ student: 1, date: -1 });
AbsenceSchema.index({ course: 1, date: -1 });
AbsenceSchema.index({ class: 1, date: -1 });
AbsenceSchema.index({ status: 1 });
AbsenceSchema.index({ academicYear: 1 });

module.exports = mongoose.model("Absence", AbsenceSchema);
