const express = require('express');
const router = express.Router();
const messagesController = require('../controllers/messages.controller');
const { authenticate } = require('../middlewares/auth');

// All routes require authentication
router.use(authenticate);

// Get all conversations for current user
router.get('/conversations', messagesController.getConversations);

// Get all messages (sent and received) for current user
router.get('/all', messagesController.getAllMessages);

// Get conversation with specific user
router.get('/conversation/:recipientId', messagesController.getConversation);

// Send a message
router.post('/', messagesController.sendMessage);

// Get single message
router.get('/:id', messagesController.getMessage);

// Mark message as read
router.put('/:id/read', messagesController.markAsRead);

// Delete message
router.delete('/:id', messagesController.deleteMessage);

module.exports = router;
