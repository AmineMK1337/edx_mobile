const express = require("express");
const router = express.Router();
const docRequestController = require("../controllers/doc_request.controller");
const { authenticate } = require("../middlewares/auth");

// Submit a new document request (anyone can submit)
router.post("/send", docRequestController.submitRequest);

// Get all document requests (protected - admin/staff)
router.get("/", authenticate, docRequestController.getAllRequests);

// Get document requests by student ID (protected)
router.get("/student/:studentId", authenticate, docRequestController.getStudentRequests);

// Update request status (protected - admin/staff)
router.put("/:id", authenticate, docRequestController.updateRequestStatus);

// Delete a document request (protected - admin/staff)
router.delete("/:id", authenticate, docRequestController.deleteRequest);

module.exports = router;
