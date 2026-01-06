const express = require("express");
const router = express.Router();
const ticketsController = require("../controllers/tickets.controller");
const { authenticate } = require("../middlewares/auth");

// Student routes (protected)
router.post("/", authenticate, ticketsController.createTicket);
router.get("/my", authenticate, ticketsController.getMyTickets);
router.get("/:id", authenticate, ticketsController.getTicketById);
router.delete("/:id", authenticate, ticketsController.cancelTicket);

// Admin routes (protected)
router.get("/", authenticate, ticketsController.getAllTickets);
router.patch("/:id/status", authenticate, ticketsController.updateTicketStatus);

module.exports = router;
