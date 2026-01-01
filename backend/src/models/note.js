const mongoose = require("mongoose");

const NoteSchema = new mongoose.Schema(
  {
    student: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "User",
      required: true
    },
    subject: {
      type: String,
      required: true
    },
    value: {
      type: Number,
      required: true
    },
    publishedBy: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "User",
      required: true // prof ou admin
    }
  },
  { timestamps: true }
);

module.exports = mongoose.model("Note", NoteSchema);
