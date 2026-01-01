const mongoose = require("mongoose");

const ExamSchema = new mongoose.Schema(
  {
    title: {
      type: String,
      required: true
    },
    subject: {
      type: String,
      required: true
    },
    status: {
      type: String,
      enum: ["planifie", "passe"],
      default: "planifie"
    },
    date: {
      type: String,
      required: true
    },
    time: {
      type: String,
      required: true
    },
    className: {
      type: String,
      required: true
    },
    studentCount: {
      type: Number,
      required: true
    },
    duration: {
      type: String,
      required: true
    },
    location: {
      type: String,
      required: true
    }
  },
  { timestamps: true }
);

module.exports = mongoose.model("Exam", ExamSchema);
