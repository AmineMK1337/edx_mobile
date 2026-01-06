const Ticket = require("../models/ticket");

// Create a new ticket (student only)
exports.createTicket = async (req, res) => {
  try {
    const userId = req.userId;
    const { ticketType, documentType, examId, courseName, currentMark, subject, message } = req.body;

    if (!ticketType) {
      return res.status(400).json({ error: "ticketType is required" });
    }

    const ticketData = {
      student: userId,
      ticketType,
      subject,
      message,
      status: "pending"
    };

    if (ticketType === "document_request") {
      if (!documentType) {
        return res.status(400).json({ error: "documentType is required for document requests" });
      }
      ticketData.documentType = documentType;
    } else if (ticketType === "exam_review") {
      ticketData.examId = examId;
      ticketData.courseName = courseName;
      ticketData.currentMark = currentMark;
    }

    const ticket = new Ticket(ticketData);
    await ticket.save();
    await ticket.populate("student", "name email");

    res.status(201).json({
      message: "Ticket created successfully",
      data: ticket
    });
  } catch (err) {
    console.error("Error creating ticket:", err);
    res.status(400).json({ error: err.message });
  }
};

// Get all tickets for the current student
exports.getMyTickets = async (req, res) => {
  try {
    const userId = req.userId;

    const tickets = await Ticket.find({ student: userId })
      .populate("student", "name email")
      .populate("answeredBy", "name email")
      .populate("examId", "title date")
      .sort({ createdAt: -1 });

    res.json(tickets);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

// Get a single ticket by ID
exports.getTicketById = async (req, res) => {
  try {
    const { id } = req.params;
    const userId = req.userId;

    const ticket = await Ticket.findOne({ _id: id, student: userId })
      .populate("student", "name email")
      .populate("answeredBy", "name email")
      .populate("examId", "title date");

    if (!ticket) {
      return res.status(404).json({ error: "Ticket not found" });
    }

    res.json(ticket);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

// Cancel/delete a ticket (student can only cancel pending tickets)
exports.cancelTicket = async (req, res) => {
  try {
    const { id } = req.params;
    const userId = req.userId;

    const ticket = await Ticket.findOne({ _id: id, student: userId });

    if (!ticket) {
      return res.status(404).json({ error: "Ticket not found" });
    }

    if (ticket.status !== "pending") {
      return res.status(400).json({ error: "Only pending tickets can be cancelled" });
    }

    await Ticket.findByIdAndDelete(id);

    res.json({ message: "Ticket cancelled successfully" });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

// Get all tickets (admin only)
exports.getAllTickets = async (req, res) => {
  try {
    const tickets = await Ticket.find()
      .populate("student", "name email")
      .populate("answeredBy", "name email")
      .populate("examId", "title date")
      .sort({ createdAt: -1 });

    res.json(tickets);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

// Update ticket status (admin only)
exports.updateTicketStatus = async (req, res) => {
  try {
    const { id } = req.params;
    const { status, response } = req.body;
    const adminId = req.userId;

    const ticket = await Ticket.findByIdAndUpdate(
      id,
      { 
        status, 
        response,
        answeredBy: adminId 
      },
      { new: true }
    )
      .populate("student", "name email")
      .populate("answeredBy", "name email");

    if (!ticket) {
      return res.status(404).json({ error: "Ticket not found" });
    }

    res.json({
      message: "Ticket updated successfully",
      data: ticket
    });
  } catch (err) {
    res.status(400).json({ error: err.message });
  }
};
