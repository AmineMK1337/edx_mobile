const mongoose = require("mongoose");

const ScheduleSchema = new mongoose.Schema(
  {
    class: {
      type: String,
      required: true
    },
    day: {
      type: String,
      enum: ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
    },
    startTime: String,
    endTime: String,
    subject: String,
    professor: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "User"
    },
    isRattrapage: {
      type: Boolean,
      default: false
    }
  },
  { timestamps: true }
);

module.exports = mongoose.model("Schedule", ScheduleSchema);
