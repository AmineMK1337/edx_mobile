const mongoose = require("mongoose");

const StudentSchema = new mongoose.Schema(
  {
    userId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "User",
      required: true
    },
    firstName: {
      type: String,
      required: true
    },
    lastName: {
      type: String,
      required: true
    },
    email: {
      type: String,
      required: true,
      unique: true,
      index: true
    },
    phone: {
      type: String,
      default: ""
    },
    address: {
      type: String,
      default: ""
    },
    birthDate: {
      type: Date,
      default: null
    },
    photoUrl: {
      type: String,
      default: null
    },
    studentClass: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "Class",
      required: true
    },
    matricule: {
      type: String,
      unique: true,
      index: true,
      required: true
    },
    enrollmentDate: {
      type: Date,
      default: Date.now
    },
    isActive: {
      type: Boolean,
      default: true
    }
  },
  { timestamps: true }
);

// Indexes for faster queries
StudentSchema.index({ email: 1 });
StudentSchema.index({ matricule: 1 });
StudentSchema.index({ studentClass: 1 });
StudentSchema.index({ userId: 1 });

module.exports = mongoose.model("Student", StudentSchema);
