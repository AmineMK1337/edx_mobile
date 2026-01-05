const mongoose = require("mongoose");

const DocRequestSchema = new mongoose.Schema(
  {
    student: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "Student",
      default: null
    },
    studentId: {
      type: String,
      required: true
    },
    studentName: {
      type: String,
      required: true
    },
    documentType: {
      type: String,
      enum: [
        "Attestation de Scolarité",
        "Relevé de Notes",
        "Certificat de Stage",
        "Autre"
      ],
      required: true
    },
    comment: {
      type: String,
      default: ""
    },
    status: {
      type: String,
      enum: ["pending", "approved", "rejected", "completed"],
      default: "pending"
    },
    requestDate: {
      type: Date,
      default: Date.now
    },
    completionDate: {
      type: Date,
      default: null
    }
  },
  { timestamps: true }
);

module.exports = mongoose.model("DocRequest", DocRequestSchema);
