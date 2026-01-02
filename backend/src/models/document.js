const mongoose = require("mongoose");

const DocumentSchema = new mongoose.Schema(
  {
    title: {
      type: String,
      required: true
    },
    description: String,
    course: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "Course",
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
    uploadedBy: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "User",
      required: true
    },
    downloads: {
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
DocumentSchema.index({ course: 1, createdAt: -1 });
DocumentSchema.index({ uploadedBy: 1 });

module.exports = mongoose.model("Document", DocumentSchema);
