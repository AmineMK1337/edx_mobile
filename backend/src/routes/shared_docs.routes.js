const express = require("express");
const router = express.Router();
const sharedDocController = require("../controllers/shared_doc.controller");
const { authenticate } = require("../middlewares/auth");

// Get all shared documents (public)
router.get("/", sharedDocController.getAllSharedDocs);

// Get shared documents by tag (public)
router.get("/tag/:tag", sharedDocController.getSharedDocsByTag);

// Get shared documents by teacher (public)
router.get("/teacher/:teacherId", sharedDocController.getSharedDocsByTeacher);

// Create a new shared document (protected)
router.post("/", authenticate, sharedDocController.createSharedDoc);

// Increment view count (public)
router.patch("/:id/views", sharedDocController.incrementViews);

// Update a shared document (protected)
router.put("/:id", authenticate, sharedDocController.updateSharedDoc);

// Delete a shared document (protected)
router.delete("/:id", authenticate, sharedDocController.deleteSharedDoc);

module.exports = router;
