const mongoose = require("mongoose");

const CalendarEventSchema = new mongoose.Schema(
  {
    title: {
      type: String,
      required: true
    },
    type: {
      type: String,
      enum: ["exam", "meeting", "tp", "td", "course", "personal", "holiday"],
      required: true
    },
    date: {
      type: Date,
      required: true
    },
    startTime: {
      type: String,
      required: true // Format: "HH:mm"
    },
    endTime: String, // Format: "HH:mm"
    location: {
      type: String,
      required: true
    },
    class: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "Class"
    },
    course: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "Course"
    },
    description: String,
    createdBy: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "User"
    },
    academicYear: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "AcademicYear"
    }
  },
  { timestamps: true }
);

// Indexes for faster queries
CalendarEventSchema.index({ date: -1 });
CalendarEventSchema.index({ class: 1, date: -1 });
CalendarEventSchema.index({ course: 1, date: -1 });
CalendarEventSchema.index({ type: 1 });
CalendarEventSchema.index({ academicYear: 1 });

module.exports = mongoose.model("CalendarEvent", CalendarEventSchema);
