const mongoose = require("mongoose");

const UserSchema = new mongoose.Schema(
  {
    name: {
      type: String,
      required: true
    },
    email: {
      type: String,
      required: true,
      unique: true,
      index: true
    },
    password: {
      type: String,
      required: true
    },
    role: {
      type: String,
      enum: ["student", "professor", "admin"],
      required: true
    },
    class: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "Class" // seulement pour student
    },
    matricule: {
      type: String,
      index: true // seulement pour student
    },
    isActive: {
      type: Boolean,
      default: true
    }
  },
  { timestamps: true }
);

// Indexes for faster queries
UserSchema.index({ role: 1 });
UserSchema.index({ class: 1 });

module.exports = mongoose.model("User", UserSchema);
