const mongoose = require("mongoose");

const AcademicYearSchema = new mongoose.Schema(
  {
    year: {
      type: String,
      required: true,
      unique: true // e.g., "2025-2026"
    },
    semester: {
      type: String,
      enum: ["1", "2"],
      required: true // "1" for first semester, "2" for second semester
    },
    startDate: {
      type: Date,
      required: true
    },
    endDate: {
      type: Date,
      required: true
    },
    isCurrent: {
      type: Boolean,
      default: false
    }
  },
  { timestamps: true }
);

// Ensure only one academic year is marked as current
AcademicYearSchema.pre("save", async function (next) {
  if (this.isCurrent) {
    await this.constructor.updateMany(
      { _id: { $ne: this._id } },
      { isCurrent: false }
    );
  }
  next();
});

// Index for faster queries
AcademicYearSchema.index({ year: 1, semester: 1 });
AcademicYearSchema.index({ isCurrent: 1 });

module.exports = mongoose.model("AcademicYear", AcademicYearSchema);
