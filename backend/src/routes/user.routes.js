const express = require('express');
const router = express.Router();
const { authenticate } = require('../middlewares/auth');
const userController = require('../controllers/user.controller');

// Apply authentication to all routes
router.use(authenticate);

// User profile
router.get('/profile', userController.getProfile);
router.put('/profile', userController.updateProfile);

// User timetables
router.get('/timetables', userController.getUserTimetables);
router.get('/timetables/:id/download', userController.downloadTimetable);

// User tickets
router.get('/tickets', userController.getUserTickets);
router.post('/tickets', userController.createTicket);

// User announcements
router.get('/announcements', userController.getUserAnnouncements);

module.exports = router;