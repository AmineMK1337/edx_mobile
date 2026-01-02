const mongoose = require("mongoose");

const MessageSchema = new mongoose.Schema(
  {
    sender: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "User",
      required: true
    },
    recipient: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "User",
      required: true
    },
    course: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "Course"
    },
    content: {
      type: String,
      required: true
    },
    isRead: {
      type: Boolean,
      default: false
    },
    attachment: {
      url: String,
      fileName: String,
      fileType: String
    }
  },
  { timestamps: true }
);

// Indexes for faster queries
MessageSchema.index({ sender: 1, recipient: 1 });
MessageSchema.index({ recipient: 1, isRead: 1 });
MessageSchema.index({ course: 1 });
MessageSchema.index({ createdAt: -1 });

module.exports = mongoose.model("Message", MessageSchema);
