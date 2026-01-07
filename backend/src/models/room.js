const mongoose = require('mongoose');

const roomSchema = new mongoose.Schema({
  name: {
    type: String,
    required: true,
    unique: true
  },
  type: {
    type: String,
    enum: ['Amphithéâtre', 'TD', 'Laboratoire', 'Bureau', 'Salle de réunion'],
    required: true
  },
  capacity: {
    type: Number,
    required: true,
    min: 1
  },
  hasProjector: {
    type: Boolean,
    default: false
  },
  hasComputers: {
    type: Boolean,
    default: false
  },
  hasAirConditioning: {
    type: Boolean,
    default: false
  },
  floor: {
    type: Number,
    required: true
  },
  building: {
    type: String,
    required: true
  },
  status: {
    type: String,
    enum: ['available', 'occupied', 'maintenance', 'reserved'],
    default: 'available'
  },
  equipment: [{
    name: String,
    quantity: Number,
    status: {
      type: String,
      enum: ['working', 'broken', 'maintenance'],
      default: 'working'
    }
  }],
  description: {
    type: String
  },
  createdBy: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User'
  }
}, {
  timestamps: true
});

module.exports = mongoose.model('Room', roomSchema);