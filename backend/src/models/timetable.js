const mongoose = require('mongoose');

const timetableSchema = new mongoose.Schema({
  title: {
    type: String,
    required: true
  },
  description: {
    type: String,
    default: ""
  },
  class: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Class',
    required: true
  },
  academicYear: {
    type: String,
    required: true
  },
  semester: {
    type: String,
    enum: ['S1', 'S2'],
    required: true
  },
  pdfFileName: {
    type: String,
    required: true
  },
  pdfFilePath: {
    type: String,
    required: true
  },
  fileSize: {
    type: Number,
    required: true
  },
  isActive: {
    type: Boolean,
    default: true
  },
  uploadedBy: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    required: true
  },
  downloadCount: {
    type: Number,
    default: 0
  }
}, {
  timestamps: true
});

// Index for efficient queries
timetableSchema.index({ class: 1, semester: 1, isActive: 1 });

module.exports = mongoose.model('Timetable', timetableSchema);