const mongoose = require("mongoose");

const NoteSchema = new mongoose.Schema(
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
    exam: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "Exam" // Optional reference to specific exam
    },
    type: {
      type: String,
      enum: ["DS", "TP", "CC", "Exam", "Project"],
      required: true
    },
    value: {
      type: Number,
      required: true,
      min: 0,
      max: 20
    },
    coefficient: {
      type: Number,
      default: 1,
      min: 0
    },
    publishedBy: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "User",
      required: true // prof ou admin
    },
    academicYear: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "AcademicYear",
      required: true
    },
    isPublished: {
      type: Boolean,
      default: false
    }
  },
  { timestamps: true }
);

// Indexes for faster queries
NoteSchema.index({ student: 1, course: 1 });
NoteSchema.index({ course: 1 });
NoteSchema.index({ exam: 1 });
NoteSchema.index({ academicYear: 1 });
NoteSchema.index({ isPublished: 1 });

module.exports = mongoose.model("Note", NoteSchema);
