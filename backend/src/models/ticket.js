const mongoose = require("mongoose");

const TicketSchema = new mongoose.Schema(
  {
    student: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "User",
      required: true
    },
    subject: String,
    message: String,
    response: String,
    status: {
      type: String,
      enum: ["open", "answered", "closed"],
      default: "open"
    },
    answeredBy: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "User" // admin
    }
  },
  { timestamps: true }
);

module.exports = mongoose.model("Ticket", TicketSchema);
