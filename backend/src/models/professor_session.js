const mongoose = require('mongoose');

const professorSessionSchema = new mongoose.Schema({
  professor: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    required: true
  },
  subject: {
    type: String,
    required: true
  },
  dayOfWeek: {
    type: String,
    enum: ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'],
    required: true
  },
  startTime: {
    type: String,
    required: true
  },
  endTime: {
    type: String,
    required: true
  },
  room: {
    type: String,
    required: true
  },
  group: {
    type: String
  },
  sessionType: {
    type: String,
    enum: ['Cours', 'TD', 'TP'],
    required: true
  },
  isActive: {
    type: Boolean,
    default: true
  },
  academicYear: {
    type: String,
    required: true
  },
  semester: {
    type: String,
    enum: ['1', '2'],
    required: true
  }
}, {
  timestamps: true
});

module.exports = mongoose.model('ProfessorSession', professorSessionSchema);