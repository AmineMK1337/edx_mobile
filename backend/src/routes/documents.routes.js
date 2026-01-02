const express = require("express");
const { authenticate } = require("../middlewares/auth");
const documentsController = require("../controllers/documents.controller");

const router = express.Router();

// Get all documents for a course
router.get("/course/:courseId", authenticate, documentsController.getDocumentsByCourse);

// Get documents uploaded by a user
router.get("/uploader/:uploaderId", authenticate, documentsController.getDocumentsByUploader);

// Create a new document
router.post("/", authenticate, documentsController.createDocument);

// Get document by ID (increments downloads)
router.get("/:id", authenticate, documentsController.getDocument);

// Update document
router.put("/:id", authenticate, documentsController.updateDocument);

// Delete document
router.delete("/:id", authenticate, documentsController.deleteDocument);

module.exports = router;
