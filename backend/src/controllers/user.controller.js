const User = require('../models/user');
const Student = require('../models/student');
const Ticket = require('../models/ticket');
const Timetable = require('../models/timetable');
const Announcement = require('../models/announcement');
const path = require('path');

// User Profile Management
const getProfile = async (req, res) => {
  try {
    const user = await User.findById(req.user.id).select('-password');
    if (!user) {
      return res.status(404).json({ error: 'User not found' });
    }

    // If user is a student, get student-specific data
    let studentData = null;
    if (user.role === 'student') {
      studentData = await Student.findOne({ userId: user._id });
    }

    res.json({ user, studentData });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

const updateProfile = async (req, res) => {
  try {
    const { name, email, phone } = req.body;
    
    const user = await User.findByIdAndUpdate(
      req.user.id,
      { name, email, phone, updatedAt: new Date() },
      { new: true }
    ).select('-password');

    if (!user) {
      return res.status(404).json({ error: 'User not found' });
    }

    res.json(user);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Timetable Access
const getUserTimetables = async (req, res) => {
  try {
    const userId = req.user.id;
    const user = await User.findById(userId);
    
    if (!user) {
      return res.status(404).json({ error: 'User not found' });
    }

    const query = {
      $or: [
        { targetType: 'all' },
        { targetUsers: userId },
        { targetType: user.role }
      ]
    };

    const timetables = await Timetable.find(query)
      .populate('uploadedBy', 'name')
      .sort({ uploadedAt: -1 });

    res.json(timetables);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

const downloadTimetable = async (req, res) => {
  try {
    const { id } = req.params;
    const userId = req.user.id;
    const user = await User.findById(userId);
    
    const timetable = await Timetable.findOne({
      _id: id,
      $or: [
        { targetType: 'all' },
        { targetUsers: userId },
        { targetType: user.role }
      ]
    });

    if (!timetable) {
      return res.status(404).json({ error: 'Timetable not found or access denied' });
    }

    const filePath = path.join(__dirname, '../../', timetable.filePath);
    res.download(filePath, timetable.fileName);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Ticket Management
const getUserTickets = async (req, res) => {
  try {
    const { page = 1, limit = 10, status } = req.query;
    const query = { createdBy: req.user.id };
    
    if (status && status !== 'all') {
      query.status = status;
    }

    const tickets = await Ticket.find(query)
      .populate('createdBy', 'name email')
      .populate('replies.replyBy', 'name email')
      .limit(limit * 1)
      .skip((page - 1) * limit)
      .sort({ createdAt: -1 });

    const total = await Ticket.countDocuments(query);

    res.json({
      tickets,
      totalPages: Math.ceil(total / limit),
      currentPage: page,
      total
    });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

const createTicket = async (req, res) => {
  try {
    const { subject, message, priority = 'medium', category } = req.body;
    
    const ticket = new Ticket({
      subject,
      message,
      priority,
      category,
      status: 'open',
      createdBy: req.user.id,
      createdAt: new Date()
    });

    await ticket.save();
    await ticket.populate('createdBy', 'name email');

    res.status(201).json(ticket);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Announcements
const getUserAnnouncements = async (req, res) => {
  try {
    const { page = 1, limit = 10, category } = req.query;
    const userId = req.user.id;
    const user = await User.findById(userId);
    
    const query = {
      $or: [
        { targetAudience: 'all' },
        { targetAudience: user.role },
        { targetUsers: userId }
      ]
    };
    
    if (category && category !== 'all') {
      query.category = category;
    }

    const announcements = await Announcement.find(query)
      .populate('createdBy', 'name')
      .limit(limit * 1)
      .skip((page - 1) * limit)
      .sort({ createdAt: -1 });

    const total = await Announcement.countDocuments(query);

    res.json({
      announcements,
      totalPages: Math.ceil(total / limit),
      currentPage: page,
      total
    });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

module.exports = {
  getProfile,
  updateProfile,
  getUserTimetables,
  downloadTimetable,
  getUserTickets,
  createTicket,
  getUserAnnouncements
};