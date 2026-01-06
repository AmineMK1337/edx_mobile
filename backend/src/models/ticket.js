const mongoose = require("mongoose");

const TicketSchema = new mongoose.Schema(
  {
    student: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "User",
      required: true
    },
    ticketType: {
      type: String,
      enum: ["document_request", "exam_review"],
      required: true
    },
    // For document requests
    documentType: {
      type: String,
      enum: ["attestation_presence", "attestation_reussite", "releve_notes", "attestation_niveau_langue", "bulletin", "autre"],
    },
    // For exam review requests
    examId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "Exam"
    },
    courseName: String,
    currentMark: Number,
    subject: String,
    message: String,
    response: String,
    status: {
      type: String,
      enum: ["pending", "in_progress", "approved", "rejected", "closed"],
      default: "pending"
    },
    answeredBy: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "User"
    }
  },
  { timestamps: true }
);

module.exports = mongoose.model("Ticket", TicketSchema);
