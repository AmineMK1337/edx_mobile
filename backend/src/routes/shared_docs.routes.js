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
    const allowedMimeTypes = [
      "application/pdf",
      "application/msword",
      "application/vnd.openxmlformats-officedocument.wordprocessingml.document",
      "application/vnd.ms-powerpoint",
      "application/vnd.openxmlformats-officedocument.presentationml.presentation",
      "application/vnd.ms-excel",
      "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
      "image/png",
      "image/jpeg",
      "application/octet-stream" // Sometimes browsers send this for PDFs
    ];
    const allowedExtensions = [".pdf", ".doc", ".docx", ".ppt", ".pptx", ".xls", ".xlsx", ".png", ".jpg", ".jpeg"];
    const ext = path.extname(file.originalname).toLowerCase();
    
    if (allowedMimeTypes.includes(file.mimetype) || allowedExtensions.includes(ext)) {
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

// Get my shared documents (protected) - documents uploaded by the current user
router.get("/my", authenticate, sharedDocController.getMySharedDocs);

// Create a new shared document (protected) - with file upload
router.post("/", authenticate, upload.single("pdfFile"), sharedDocController.createSharedDoc);

// Increment view count (public)
router.patch("/:id/views", sharedDocController.incrementViews);

// Update a shared document (protected)
router.put("/:id", authenticate, sharedDocController.updateSharedDoc);

// Delete a shared document (protected)
router.delete("/:id", authenticate, sharedDocController.deleteSharedDoc);

module.exports = router;
