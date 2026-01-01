const mongoose = require("mongoose");

const AbsenceSchema = new mongoose.Schema(
  {
    student: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "User",
      required: true
    },
    subject: String,
    date: {
      type: Date,
      required: true
    },
    status: {
      type: String,
      enum: ["present", "absent"],
      required: true
    },
    takenBy: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "User", // prof
      required: true
    }
  },
  { timestamps: true }
);

module.exports = mongoose.model("Absence", AbsenceSchema);
