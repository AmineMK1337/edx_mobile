const mongoose = require("mongoose");

const SharedDocSchema = new mongoose.Schema(
  {
    title: {
      type: String,
      required: true
    },
    description: String,
    teacher: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "User",
      required: true
    },
    uploadedBy: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "User",
      required: true
    },
    fileUrl: {
      type: String,
      required: true
    },
    fileType: {
      type: String,
      enum: ["pdf", "doc", "docx", "xls", "xlsx", "ppt", "pptx", "image", "jpg", "png", "other"],
      default: "pdf"
    },
    tag: {
      type: String,
      enum: ["Cours", "TD", "TP", "Examen", "Rapport", "Autre"],
      default: "Autre"
    },
    views: {
      type: Number,
      default: 0
    },
    isPublished: {
      type: Boolean,
      default: true
    }
  },
  { timestamps: true }
);

// Indexes for faster queries
SharedDocSchema.index({ teacher: 1, createdAt: -1 });
SharedDocSchema.index({ tag: 1 });
SharedDocSchema.index({ isPublished: 1 });

module.exports = mongoose.model("SharedDoc", SharedDocSchema);
