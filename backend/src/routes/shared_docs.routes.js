const express = require("express");
const router = express.Router();
const multer = require("multer");
const path = require("path");
const sharedDocController = require("../controllers/shared_doc.controller");
const { authenticate } = require("../middlewares/auth");

// Configure multer for file uploads
const storage = multer.diskStorage({
  destination: (req, file, cb) => {
    cb(null, path.join(__dirname, "../../uploads"));
  },
  filename: (req, file, cb) => {
    const uniqueSuffix = Date.now() + "-" + Math.round(Math.random() * 1e9);
    cb(null, uniqueSuffix + "-" + file.originalname);
  },
});

const upload = multer({
  storage,
  limits: { fileSize: 10 * 1024 * 1024 }, // 10MB max
  fileFilter: (req, file, cb) => {
    const allowedTypes = ["application/pdf", "image/png", "image/jpeg"];
    if (allowedTypes.includes(file.mimetype)) {
      cb(null, true);
    } else {
      cb(new Error("Type de fichier non autorisé"), false);
    }
  },
});

// Get all shared documents (public)
router.get("/", sharedDocController.getAllSharedDocs);

// Get shared documents by tag (public)
router.get("/tag/:tag", sharedDocController.getSharedDocsByTag);

// Get shared documents by teacher (public)
router.get("/teacher/:teacherId", sharedDocController.getSharedDocsByTeacher);

// Create a new shared document (protected) - with file upload
router.post("/", authenticate, upload.single("pdfFile"), sharedDocController.createSharedDoc);

// Increment view count (public)
router.patch("/:id/views", sharedDocController.incrementViews);

// Update a shared document (protected)
router.put("/:id", authenticate, sharedDocController.updateSharedDoc);

// Delete a shared document (protected)
router.delete("/:id", authenticate, sharedDocController.deleteSharedDoc);

module.exports = router;
