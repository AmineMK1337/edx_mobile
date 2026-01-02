const express = require('express');
const router = express.Router();
const announcementsController = require('../controllers/announcements.controller');
const { authenticate } = require('../middlewares/auth');

// All routes require authentication
router.use(authenticate);

// Get all announcements
router.get('/', announcementsController.getAllAnnouncements);

// Get announcements for a specific class
router.get('/class/:classId', announcementsController.getAnnouncementsByClass);

// Create a new announcement
router.post('/', announcementsController.createAnnouncement);

// Get single announcement
router.get('/:id', announcementsController.getAnnouncement);

// Update announcement
router.put('/:id', announcementsController.updateAnnouncement);

// Toggle pin status
router.put('/:id/toggle-pin', announcementsController.togglePin);

// Delete announcement
router.delete('/:id', announcementsController.deleteAnnouncement);

module.exports = router;
