const mongoose = require("mongoose");

const ClassSchema = new mongoose.Schema(
  {
    name: {
      type: String,
      required: true,
      unique: true // e.g., "3A", "2B", "1C"
    },
    level: {
      type: String,
      required: true // e.g., "1", "2", "3"
    },
    section: {
      type: String,
      required: true // e.g., "A", "B", "C"
    },
    academicYear: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "AcademicYear",
      required: true
    },
    studentCount: {
      type: Number,
      default: 0
    },
    isActive: {
      type: Boolean,
      default: true
    }
  },
  { timestamps: true }
);

// Index for faster queries
ClassSchema.index({ name: 1, academicYear: 1 });
ClassSchema.index({ level: 1, section: 1 });

module.exports = mongoose.model("Class", ClassSchema);
