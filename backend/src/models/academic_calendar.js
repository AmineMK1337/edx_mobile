const mongoose = require("mongoose");

const AcademicCalendarSchema = new mongoose.Schema(
  {
    title: {
      type: String,
      required: true
    },
    startDate: {
      type: Date,
      required: true
    },
    endDate: {
      type: Date,
      required: true
    },
    status: {
      type: String,
      enum: ["upcoming", "ongoing", "completed"],
      default: "upcoming"
    },
    type: {
      type: String,
      enum: ["semester", "exams", "vacation", "event", "registration"],
      default: "event"
    },
    academicYear: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "AcademicYear",
      required: true
    },
    description: {
      type: String,
      default: ""
    },
    isActive: {
      type: Boolean,
      default: true
    }
  },
  { timestamps: true }
);

// Indexes for faster queries
AcademicCalendarSchema.index({ academicYear: 1, startDate: 1 });
AcademicCalendarSchema.index({ status: 1 });
AcademicCalendarSchema.index({ type: 1 });

module.exports = mongoose.model("AcademicCalendar", AcademicCalendarSchema);
