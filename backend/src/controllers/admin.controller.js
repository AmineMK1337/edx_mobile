const User = require('../models/user');
const Student = require('../models/student');
const Ticket = require('../models/ticket');
const Announcement = require('../models/announcement');
const Schedule = require('../models/schedule');
const Course = require('../models/course');
const Exam = require('../models/exam');
const DocRequest = require('../models/doc_request');
const Rattrapage = require('../models/rattrapage');
const Room = require('../models/room');
const Timetable = require('../models/timetable');
const ProfessorSession = require('../models/professor_session');
const Chat = require('../models/chat');
const path = require('path');
const fs = require('fs');

// Dashboard Stats
const getDashboardStats = async (req, res) => {
  try {
    const usersCount = await User.countDocuments();
    const ticketsCount = await Ticket.countDocuments();
    const studentsCount = await Student.countDocuments();
    const rattrapagesCount = await Rattrapage.countDocuments();

    res.json({
      usersCount,
      ticketsCount,
      studentsCount,
      rattrapagesCount
    });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// User Management
const getUsers = async (req, res) => {
  try {
    const { page = 1, limit = 20, search, role } = req.query;
    const query = {};
    
    if (search) {
      query.$or = [
        { name: { $regex: search, $options: 'i' } },
        { email: { $regex: search, $options: 'i' } }
      ];
    }
    
    if (role && role !== 'all') {
      query.role = role;
    }

    const users = await User.find(query)
      .limit(limit * 1)
      .skip((page - 1) * limit)
      .select('-password')
      .sort({ createdAt: -1 });

    const total = await User.countDocuments(query);

    res.json({
      users,
      totalPages: Math.ceil(total / limit),
      currentPage: page
    });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

const createUser = async (req, res) => {
  try {
    const { name, email, role, password } = req.body;
    
    const existingUser = await User.findOne({ email });
    if (existingUser) {
      return res.status(400).json({ error: 'User with this email already exists' });
    }

    const user = new User({ name, email, role, password });
    await user.save();
    
    const userResponse = user.toObject();
    delete userResponse.password;
    
    res.status(201).json(userResponse);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

const updateUser = async (req, res) => {
  try {
    const { id } = req.params;
    const updateData = req.body;
    
    if (updateData.password) {
      delete updateData.password; // Don't allow password updates through this endpoint
    }

    const user = await User.findByIdAndUpdate(id, updateData, { new: true }).select('-password');
    if (!user) {
      return res.status(404).json({ error: 'User not found' });
    }

    res.json(user);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

const deleteUser = async (req, res) => {
  try {
    const { id } = req.params;
    const user = await User.findByIdAndDelete(id);
    
    if (!user) {
      return res.status(404).json({ error: 'User not found' });
    }

    res.json({ message: 'User deleted successfully' });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

const getStudents = async (req, res) => {
  try {
    const students = await User.find({ role: { $in: ['student', 'etudiant'] } })
      .select('-password')
      .sort({ name: 1 });
    res.json(students);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

const getProfessors = async (req, res) => {
  try {
    const professors = await User.find({ role: { $in: ['professor', 'prof', 'enseignant'] } })
      .select('-password')
      .sort({ name: 1 });
    res.json(professors);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Ticket Management
const getTickets = async (req, res) => {
  try {
    const { page = 1, limit = 20, status, priority } = req.query;
    const query = {};
    
    if (status && status !== 'all') {
      query.status = status;
    }
    
    if (priority && priority !== 'all') {
      query.priority = priority;
    }

    const tickets = await Ticket.find(query)
      .populate('studentId', 'name email')
      .limit(limit * 1)
      .skip((page - 1) * limit)
      .sort({ createdAt: -1 });

    const total = await Ticket.countDocuments(query);

    res.json({
      tickets,
      totalPages: Math.ceil(total / limit),
      currentPage: page
    });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

const updateTicket = async (req, res) => {
  try {
    const { id } = req.params;
    const ticket = await Ticket.findByIdAndUpdate(id, req.body, { new: true })
      .populate('studentId', 'name email');
    
    if (!ticket) {
      return res.status(404).json({ error: 'Ticket not found' });
    }

    res.json(ticket);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

const deleteTicket = async (req, res) => {
  try {
    const { id } = req.params;
    const ticket = await Ticket.findByIdAndDelete(id);
    
    if (!ticket) {
      return res.status(404).json({ error: 'Ticket not found' });
    }

    res.json({ message: 'Ticket deleted successfully' });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

const updateTicketStatus = async (req, res) => {
  try {
    const { id } = req.params;
    const { status, response } = req.body;
    
    const ticket = await Ticket.findByIdAndUpdate(
      id, 
      { 
        status, 
        response,
        resolvedBy: req.userId,
        resolvedAt: new Date()
      }, 
      { new: true }
    ).populate('studentId', 'name email');
    
    if (!ticket) {
      return res.status(404).json({ error: 'Ticket not found' });
    }

    res.json(ticket);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Rattrapage Management
const getRattrapages = async (req, res) => {
  try {
    const { filter } = req.query;
    let query = {};
    
    if (filter === 'upcoming') {
      query.date = { $gte: new Date() };
    } else if (filter === 'past') {
      query.date = { $lt: new Date() };
    }

    const rattrapages = await Rattrapage.find(query)
      .populate('professor', 'name')
      .populate('courseId', 'name')
      .sort({ date: 1 });

    const formattedRattrapages = rattrapages.map(r => ({
      _id: r._id,
      subject: r.courseId?.name || r.subject,
      professor: r.professor?.name || 'Unknown',
      date: r.date.toLocaleDateString('fr-FR'),
      time: r.time,
      room: r.room,
      capacity: r.capacity,
      registered: r.registered,
      progress: r.progress,
      status: r.status
    }));
    
    res.json(formattedRattrapages);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

const createRattrapage = async (req, res) => {
  try {
    const rattrapageData = {
      ...req.body,
      createdBy: req.userId
    };
    
    const rattrapage = new Rattrapage(rattrapageData);
    await rattrapage.save();
    await rattrapage.populate(['professor', 'courseId']);
    
    res.status(201).json(rattrapage);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

const updateRattrapage = async (req, res) => {
  try {
    const { id } = req.params;
    const rattrapage = await Rattrapage.findByIdAndUpdate(id, req.body, { new: true })
      .populate(['professor', 'courseId']);
    
    if (!rattrapage) {
      return res.status(404).json({ error: 'Rattrapage not found' });
    }

    res.json(rattrapage);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

const deleteRattrapage = async (req, res) => {
  try {
    const { id } = req.params;
    const rattrapage = await Rattrapage.findByIdAndDelete(id);
    
    if (!rattrapage) {
      return res.status(404).json({ error: 'Rattrapage not found' });
    }

    res.json({ message: 'Rattrapage deleted successfully' });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Schedule Management
const getSchedules = async (req, res) => {
  try {
    const schedules = await Schedule.find()
      .populate('courseId')
      .sort({ createdAt: -1 });
    res.json(schedules);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

const createSchedule = async (req, res) => {
  try {
    const schedule = new Schedule(req.body);
    await schedule.save();
    await schedule.populate('courseId');
    res.status(201).json(schedule);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

const updateSchedule = async (req, res) => {
  try {
    const { id } = req.params;
    const schedule = await Schedule.findByIdAndUpdate(id, req.body, { new: true })
      .populate('courseId');
    
    if (!schedule) {
      return res.status(404).json({ error: 'Schedule not found' });
    }

    res.json(schedule);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

const deleteSchedule = async (req, res) => {
  try {
    const { id } = req.params;
    const schedule = await Schedule.findByIdAndDelete(id);
    
    if (!schedule) {
      return res.status(404).json({ error: 'Schedule not found' });
    }

    res.json({ message: 'Schedule deleted successfully' });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Subject Management
const getSubjects = async (req, res) => {
  try {
    const subjects = await Course.find().sort({ name: 1 });
    res.json(subjects);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

const createSubject = async (req, res) => {
  try {
    const subject = new Course(req.body);
    await subject.save();
    res.status(201).json(subject);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

const updateSubject = async (req, res) => {
  try {
    const { id } = req.params;
    const subject = await Course.findByIdAndUpdate(id, req.body, { new: true });
    
    if (!subject) {
      return res.status(404).json({ error: 'Subject not found' });
    }

    res.json(subject);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

const deleteSubject = async (req, res) => {
  try {
    const { id } = req.params;
    const subject = await Course.findByIdAndDelete(id);
    
    if (!subject) {
      return res.status(404).json({ error: 'Subject not found' });
    }

    res.json({ message: 'Subject deleted successfully' });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Room Management
const getRooms = async (req, res) => {
  try {
    const rooms = await Room.find().sort({ building: 1, floor: 1, name: 1 });
    res.json(rooms);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

const createRoom = async (req, res) => {
  try {
    const roomData = {
      ...req.body,
      createdBy: req.userId
    };
    
    const room = new Room(roomData);
    await room.save();
    
    res.status(201).json(room);
  } catch (error) {
    if (error.code === 11000) {
      return res.status(400).json({ error: 'Room with this name already exists' });
    }
    res.status(500).json({ error: error.message });
  }
};

const updateRoom = async (req, res) => {
  try {
    const { id } = req.params;
    const room = await Room.findByIdAndUpdate(id, req.body, { new: true });
    
    if (!room) {
      return res.status(404).json({ error: 'Room not found' });
    }

    res.json(room);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

const deleteRoom = async (req, res) => {
  try {
    const { id } = req.params;
    const room = await Room.findByIdAndDelete(id);
    
    if (!room) {
      return res.status(404).json({ error: 'Room not found' });
    }

    res.json({ message: 'Room deleted successfully' });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Document Management
const getDocuments = async (req, res) => {
  try {
    const { status } = req.query;
    const query = {};
    
    if (status && status !== 'all') {
      query.status = status;
    }

    const documents = await DocRequest.find(query)
      .populate('requestedBy', 'name email')
      .sort({ createdAt: -1 });

    res.json(documents);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

const approveDocument = async (req, res) => {
  try {
    const { id } = req.params;
    const { note } = req.body;
    
    const document = await DocRequest.findByIdAndUpdate(
      id,
      {
        status: 'approved',
        note,
        processedBy: req.userId,
        processedAt: new Date()
      },
      { new: true }
    ).populate('requestedBy', 'name email');
    
    if (!document) {
      return res.status(404).json({ error: 'Document not found' });
    }

    res.json(document);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

const rejectDocument = async (req, res) => {
  try {
    const { id } = req.params;
    const { reason } = req.body;
    
    const document = await DocRequest.findByIdAndUpdate(
      id,
      {
        status: 'rejected',
        note: reason,
        processedBy: req.userId,
        processedAt: new Date()
      },
      { new: true }
    ).populate('requestedBy', 'name email');
    
    if (!document) {
      return res.status(404).json({ error: 'Document not found' });
    }

    res.json(document);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Announcement Management
const getAnnouncements = async (req, res) => {
  try {
    const announcements = await Announcement.find()
      .populate('createdBy', 'name')
      .sort({ createdAt: -1 });
    res.json(announcements);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

const createAnnouncement = async (req, res) => {
  try {
    const announcement = new Announcement({
      ...req.body,
      createdBy: req.userId
    });
    await announcement.save();
    await announcement.populate('createdBy', 'name');
    
    res.status(201).json(announcement);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

const updateAnnouncement = async (req, res) => {
  try {
    const { id } = req.params;
    const announcement = await Announcement.findByIdAndUpdate(id, req.body, { new: true })
      .populate('createdBy', 'name');
    
    if (!announcement) {
      return res.status(404).json({ error: 'Announcement not found' });
    }

    res.json(announcement);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

const deleteAnnouncement = async (req, res) => {
  try {
    const { id } = req.params;
    const announcement = await Announcement.findByIdAndDelete(id);
    
    if (!announcement) {
      return res.status(404).json({ error: 'Announcement not found' });
    }

    res.json({ message: 'Announcement deleted successfully' });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Grade Publishing
const getExamSessions = async (req, res) => {
  try {
    const exams = await Exam.find({ status: { $ne: 'published' } })
      .populate('courseId', 'name')
      .populate('professorId', 'name')
      .sort({ date: -1 });

    const sessions = exams.map(exam => ({
      _id: exam._id,
      subject: exam.courseId?.name || 'Unknown',
      type: exam.type || 'Exam',
      group: exam.group || 'General',
      professor: exam.professorId?.name || 'Unknown',
      date: exam.date,
      studentCount: exam.students?.length || 0,
      isReady: exam.status === 'graded'
    }));

    res.json(sessions);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

const publishGrades = async (req, res) => {
  try {
    const { sessionIds, notificationSettings } = req.body;
    
    // Update exam statuses to published
    await Exam.updateMany(
      { _id: { $in: sessionIds } },
      { 
        status: 'published',
        publishedBy: req.userId,
        publishedAt: new Date()
      }
    );

    // Here you could also send notifications based on notificationSettings
    
    res.json({ 
      message: 'Grades published successfully',
      publishedCount: sessionIds.length 
    });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Ticket Reply Methods
const replyToTicket = async (req, res) => {
  try {
    const { id } = req.params;
    const { message } = req.body;
    const replyBy = req.user.id;

    const ticket = await Ticket.findByIdAndUpdate(
      id,
      {
        $push: {
          replies: {
            message,
            replyBy,
            replyAt: new Date()
          }
        },
        status: 'in_progress',
        updatedAt: new Date()
      },
      { new: true }
    ).populate('replies.replyBy', 'name email');

    res.json(ticket);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

const getTicketReplies = async (req, res) => {
  try {
    const { id } = req.params;
    const ticket = await Ticket.findById(id)
      .populate('replies.replyBy', 'name email')
      .populate('createdBy', 'name email');

    if (!ticket) {
      return res.status(404).json({ error: 'Ticket not found' });
    }

    res.json(ticket.replies);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Timetable Management Methods
const uploadTimetable = async (req, res) => {
  try {
    const { targetType, targetUsers, academicYear, semester, description } = req.body;
    
    if (!req.file) {
      return res.status(400).json({ error: 'No PDF file uploaded' });
    }

    const filePath = `uploads/${req.file.filename}`;
    
    const timetable = new Timetable({
      filePath,
      fileName: req.file.originalname,
      targetType,
      targetUsers: JSON.parse(targetUsers || '[]'),
      academicYear,
      semester,
      description,
      uploadedBy: req.user.id,
      uploadedAt: new Date()
    });

    await timetable.save();
    res.status(201).json(timetable);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

const getTimetables = async (req, res) => {
  try {
    const { page = 1, limit = 20, targetType, academicYear, semester } = req.query;
    const query = {};
    
    if (targetType && targetType !== 'all') query.targetType = targetType;
    if (academicYear && academicYear !== 'all') query.academicYear = academicYear;
    if (semester && semester !== 'all') query.semester = semester;

    const timetables = await Timetable.find(query)
      .populate('uploadedBy', 'name email')
      .populate('targetUsers', 'name email')
      .limit(limit * 1)
      .skip((page - 1) * limit)
      .sort({ uploadedAt: -1 });

    const total = await Timetable.countDocuments(query);

    res.json({
      timetables,
      totalPages: Math.ceil(total / limit),
      currentPage: page,
      total
    });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

const deleteTimetable = async (req, res) => {
  try {
    const { id } = req.params;
    const timetable = await Timetable.findById(id);
    
    if (!timetable) {
      return res.status(404).json({ error: 'Timetable not found' });
    }

    // Delete the file from filesystem
    const fullPath = path.join(__dirname, '../../', timetable.filePath);
    if (fs.existsSync(fullPath)) {
      fs.unlinkSync(fullPath);
    }

    await Timetable.findByIdAndDelete(id);
    res.json({ message: 'Timetable deleted successfully' });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

const getUserTimetable = async (req, res) => {
  try {
    const { userId } = req.params;
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

// Professor Session Management Methods
const getProfessorSessions = async (req, res) => {
  try {
    const { professorId } = req.params;
    const { date, week } = req.query;
    
    let query = { professor: professorId };
    
    if (date) {
      const startDate = new Date(date);
      const endDate = new Date(date);
      endDate.setDate(endDate.getDate() + 1);
      query.date = { $gte: startDate, $lt: endDate };
    }
    
    if (week) {
      // Get sessions for the specified week
      const startOfWeek = new Date(week);
      const endOfWeek = new Date(week);
      endOfWeek.setDate(endOfWeek.getDate() + 7);
      query.date = { $gte: startOfWeek, $lt: endOfWeek };
    }

    const sessions = await ProfessorSession.find(query)
      .populate('professor', 'name email')
      .populate('subject', 'name')
      .sort({ date: 1, startTime: 1 });

    res.json(sessions);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

const addProfessorSession = async (req, res) => {
  try {
    const { professorId } = req.params;
    const { subject, date, startTime, endTime, room, sessionType, notes } = req.body;

    // Check for conflicts
    const conflict = await ProfessorSession.findOne({
      professor: professorId,
      date: new Date(date),
      $or: [
        { startTime: { $lte: startTime }, endTime: { $gt: startTime } },
        { startTime: { $lt: endTime }, endTime: { $gte: endTime } },
        { startTime: { $gte: startTime }, endTime: { $lte: endTime } }
      ]
    });

    if (conflict) {
      return res.status(400).json({ error: 'Session time conflicts with existing session' });
    }

    const session = new ProfessorSession({
      professor: professorId,
      subject,
      date: new Date(date),
      startTime,
      endTime,
      room,
      sessionType,
      notes,
      createdBy: req.user.id
    });

    await session.save();
    await session.populate('professor', 'name email');
    await session.populate('subject', 'name');

    res.status(201).json(session);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

const updateProfessorSession = async (req, res) => {
  try {
    const { sessionId } = req.params;
    const updates = req.body;

    const session = await ProfessorSession.findByIdAndUpdate(
      sessionId,
      { ...updates, updatedAt: new Date() },
      { new: true }
    )
    .populate('professor', 'name email')
    .populate('subject', 'name');

    if (!session) {
      return res.status(404).json({ error: 'Session not found' });
    }

    res.json(session);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

const deleteProfessorSession = async (req, res) => {
  try {
    const { sessionId } = req.params;
    
    await ProfessorSession.findByIdAndDelete(sessionId);
    res.json({ message: 'Session deleted successfully' });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

const getProfessorsSessionOverview = async (req, res) => {
  try {
    const { date = new Date().toISOString().split('T')[0] } = req.query;
    
    const startDate = new Date(date);
    const endDate = new Date(date);
    endDate.setDate(endDate.getDate() + 1);

    const professors = await User.find({ role: 'professor' }).select('name email');
    const sessions = await ProfessorSession.find({
      date: { $gte: startDate, $lt: endDate }
    }).populate('professor', 'name email');

    const overview = professors.map(professor => {
      const professorSessions = sessions.filter(s => 
        s.professor._id.toString() === professor._id.toString()
      );
      
      return {
        professor,
        sessionCount: professorSessions.length,
        sessions: professorSessions,
        hasSession: professorSessions.length > 0,
        totalHours: professorSessions.reduce((total, session) => {
          const start = new Date(`1970-01-01T${session.startTime}`);
          const end = new Date(`1970-01-01T${session.endTime}`);
          return total + ((end - start) / (1000 * 60 * 60));
        }, 0)
      };
    });

    res.json(overview);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Chat Management Methods
const getChats = async (req, res) => {
  try {
    const adminId = req.user.id;
    const chats = await Chat.find({
      participants: adminId
    })
    .populate('participants', 'name email role')
    .populate('lastMessage.sender', 'name')
    .sort({ updatedAt: -1 });

    res.json(chats);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

const createOrGetChat = async (req, res) => {
  try {
    const { professorId } = req.params;
    const adminId = req.user.id;

    // Check if chat already exists
    let chat = await Chat.findOne({
      participants: { $all: [adminId, professorId] }
    }).populate('participants', 'name email role');

    if (!chat) {
      chat = new Chat({
        participants: [adminId, professorId],
        chatType: 'admin_professor',
        createdBy: adminId
      });
      await chat.save();
      await chat.populate('participants', 'name email role');
    }

    res.json(chat);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

const getChatMessages = async (req, res) => {
  try {
    const { chatId } = req.params;
    const { page = 1, limit = 50 } = req.query;

    const chat = await Chat.findById(chatId);
    if (!chat || !chat.participants.includes(req.user.id)) {
      return res.status(403).json({ error: 'Access denied' });
    }

    const messages = await Chat.findById(chatId)
      .populate('messages.sender', 'name email')
      .select('messages')
      .slice('messages', [(page - 1) * limit, limit]);

    res.json(messages.messages.reverse());
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

const sendMessage = async (req, res) => {
  try {
    const { chatId } = req.params;
    const { content, messageType = 'text' } = req.body;
    const senderId = req.user.id;

    const chat = await Chat.findById(chatId);
    if (!chat || !chat.participants.includes(senderId)) {
      return res.status(403).json({ error: 'Access denied' });
    }

    const message = {
      sender: senderId,
      content,
      messageType,
      timestamp: new Date(),
      readBy: [senderId]
    };

    await Chat.findByIdAndUpdate(chatId, {
      $push: { messages: message },
      lastMessage: {
        content,
        sender: senderId,
        timestamp: new Date()
      },
      updatedAt: new Date()
    });

    const populatedMessage = await Chat.findById(chatId)
      .populate('messages.sender', 'name email')
      .select('messages')
      .slice('messages', -1);

    res.json(populatedMessage.messages[0]);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

const markMessageAsRead = async (req, res) => {
  try {
    const { chatId, messageId } = req.params;
    const userId = req.user.id;

    await Chat.updateOne(
      { _id: chatId, 'messages._id': messageId },
      { $addToSet: { 'messages.$.readBy': userId } }
    );

    res.json({ message: 'Message marked as read' });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

module.exports = {
  getDashboardStats,
  getUsers,
  createUser,
  updateUser,
  deleteUser,
  getStudents,
  getProfessors,
  getTickets,
  updateTicket,
  deleteTicket,
  updateTicketStatus,
  replyToTicket,
  getTicketReplies,
  uploadTimetable,
  getTimetables,
  deleteTimetable,
  getUserTimetable,
  getProfessorSessions,
  addProfessorSession,
  updateProfessorSession,
  deleteProfessorSession,
  getProfessorsSessionOverview,
  getChats,
  createOrGetChat,
  getChatMessages,
  sendMessage,
  markMessageAsRead,
  getRattrapages,
  createRattrapage,
  updateRattrapage,
  deleteRattrapage,
  getSchedules,
  createSchedule,
  updateSchedule,
  deleteSchedule,
  getSubjects,
  createSubject,
  updateSubject,
  deleteSubject,
  getRooms,
  createRoom,
  updateRoom,
  deleteRoom,
  getDocuments,
  approveDocument,
  rejectDocument,
  getAnnouncements,
  createAnnouncement,
  updateAnnouncement,
  deleteAnnouncement,
  getExamSessions,
  publishGrades
};