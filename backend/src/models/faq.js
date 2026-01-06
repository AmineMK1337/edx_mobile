const mongoose = require("mongoose");

const FaqSchema = new mongoose.Schema(
  {
    question: {
      type: String,
      required: true
    },
    answer: {
      type: String,
      required: true
    },
    category: {
      type: String,
      enum: ["general", "academic", "administrative", "technical"],
      default: "general"
    },
    order: {
      type: Number,
      default: 0
    },
    isActive: {
      type: Boolean,
      default: true
    }
  },
  { timestamps: true }
);

// Index for faster queries
FaqSchema.index({ category: 1, order: 1 });
FaqSchema.index({ isActive: 1 });

module.exports = mongoose.model("Faq", FaqSchema);
