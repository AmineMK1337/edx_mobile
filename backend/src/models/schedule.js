const mongoose = require("mongoose");

const ScheduleSchema = new mongoose.Schema(
  {
    class: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "Class",
      required: true
    },
    course: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "Course",
      required: true
    },
    day: {
      type: String,
      enum: ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"],
      required: true
    },
    startTime: {
      type: String,
      required: true // Format: "HH:mm" e.g., "08:00"
    },
    endTime: {
      type: String,
      required: true // Format: "HH:mm" e.g., "10:00"
    },
    professor: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "User"
    },
    location: String,
    isRattrapage: {
      type: Boolean,
      default: false
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
ScheduleSchema.index({ class: 1, day: 1 });
ScheduleSchema.index({ course: 1 });
ScheduleSchema.index({ professor: 1 });
ScheduleSchema.index({ academicYear: 1 });

module.exports = mongoose.model("Schedule", ScheduleSchema);
