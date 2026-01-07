const express = require('express');
const router = express.Router();
const { authenticate } = require('../middlewares/auth');
const { adminAuth } = require('../middlewares/adminAuth');
const adminController = require('../controllers/admin.controller');
const multer = require('multer');

// Configure multer for file uploads
const storage = multer.diskStorage({
  destination: function (req, file, cb) {
    cb(null, './uploads/');
  },
  filename: function (req, file, cb) {
    const uniqueSuffix = Date.now() + '-' + Math.round(Math.random() * 1E9);
    cb(null, file.fieldname + '-' + uniqueSuffix + '.' + file.originalname.split('.').pop());
  }
});

const upload = multer({ storage: storage });

// Apply authentication and admin authorization to all routes
router.use(authenticate);
router.use(adminAuth);

// Dashboard stats
router.get('/stats', adminController.getDashboardStats);

// User management
router.get('/users', adminController.getUsers);
router.post('/users', adminController.createUser);
router.put('/users/:id', adminController.updateUser);
router.delete('/users/:id', adminController.deleteUser);
router.get('/users/students', adminController.getStudents);
router.get('/users/professors', adminController.getProfessors);

// Ticket management
router.get('/tickets', adminController.getTickets);
router.put('/tickets/:id', adminController.updateTicket);
router.delete('/tickets/:id', adminController.deleteTicket);
router.put('/tickets/:id/status', adminController.updateTicketStatus);
router.post('/tickets/:id/reply', adminController.replyToTicket);
router.get('/tickets/:id/replies', adminController.getTicketReplies);

// Timetable management
router.post('/timetables', upload.single('pdfFile'), adminController.uploadTimetable);
router.get('/timetables', adminController.getTimetables);
router.delete('/timetables/:id', adminController.deleteTimetable);
router.get('/users/:userId/timetable', adminController.getUserTimetable);

// Professor session management
router.get('/professors/:professorId/sessions', adminController.getProfessorSessions);
router.post('/professors/:professorId/sessions', adminController.addProfessorSession);
router.put('/sessions/:sessionId', adminController.updateProfessorSession);
router.delete('/sessions/:sessionId', adminController.deleteProfessorSession);
router.get('/professors/sessions/overview', adminController.getProfessorsSessionOverview);

// Chat with professors
router.get('/chats', adminController.getChats);
router.post('/chats/:professorId', adminController.createOrGetChat);
router.get('/chats/:chatId/messages', adminController.getChatMessages);
router.post('/chats/:chatId/messages', adminController.sendMessage);
router.put('/chats/:chatId/messages/:messageId/read', adminController.markMessageAsRead);

// Rattrapage management
router.get('/rattrapages', adminController.getRattrapages);
router.post('/rattrapages', adminController.createRattrapage);
router.put('/rattrapages/:id', adminController.updateRattrapage);
router.delete('/rattrapages/:id', adminController.deleteRattrapage);

// Schedule management
router.get('/schedules', adminController.getSchedules);
router.post('/schedules', adminController.createSchedule);
router.put('/schedules/:id', adminController.updateSchedule);
router.delete('/schedules/:id', adminController.deleteSchedule);

// Subject management
router.get('/subjects', adminController.getSubjects);
router.post('/subjects', adminController.createSubject);
router.put('/subjects/:id', adminController.updateSubject);
router.delete('/subjects/:id', adminController.deleteSubject);

// Room management
router.get('/rooms', adminController.getRooms);
router.post('/rooms', adminController.createRoom);
router.put('/rooms/:id', adminController.updateRoom);
router.delete('/rooms/:id', adminController.deleteRoom);

// Document management
router.get('/documents', adminController.getDocuments);
router.put('/documents/:id/approve', adminController.approveDocument);
router.put('/documents/:id/reject', adminController.rejectDocument);

// Announcement management
router.get('/announcements', adminController.getAnnouncements);
router.post('/announcements', adminController.createAnnouncement);
router.put('/announcements/:id', adminController.updateAnnouncement);
router.delete('/announcements/:id', adminController.deleteAnnouncement);

// Grade publishing
router.get('/exams/sessions', adminController.getExamSessions);
router.post('/grades/publish', adminController.publishGrades);

module.exports = router;