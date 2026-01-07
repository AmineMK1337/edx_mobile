const mongoose = require('mongoose');

const rattrapageSchema = new mongoose.Schema({
  subject: {
    type: String,
    required: true
  },
  professor: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    required: true
  },
  date: {
    type: Date,
    required: true
  },
  time: {
    type: String,
    required: true
  },
  room: {
    type: String,
    required: true
  },
  capacity: {
    type: Number,
    required: true,
    min: 1
  },
  registeredStudents: [{
    student: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'User'
    },
    registeredAt: {
      type: Date,
      default: Date.now
    }
  }],
  courseId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Course'
  },
  status: {
    type: String,
    enum: ['scheduled', 'ongoing', 'completed', 'cancelled'],
    default: 'scheduled'
  },
  description: {
    type: String
  },
  createdBy: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    required: true
  }
}, {
  timestamps: true
});

// Virtual for registered count
rattrapageSchema.virtual('registered').get(function() {
  return this.registeredStudents ? this.registeredStudents.length : 0;
});

// Virtual for availability
rattrapageSchema.virtual('isAvailable').get(function() {
  return this.registered < this.capacity;
});

// Virtual for progress percentage
rattrapageSchema.virtual('progress').get(function() {
  return this.capacity > 0 ? this.registered / this.capacity : 0;
});

// Ensure virtual fields are serialized
rattrapageSchema.set('toJSON', { virtuals: true });
rattrapageSchema.set('toObject', { virtuals: true });

module.exports = mongoose.model('Rattrapage', rattrapageSchema);