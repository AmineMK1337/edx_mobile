const SharedDoc = require("../models/shared_doc");
const User = require("../models/user");

// Get all shared documents
exports.getAllSharedDocs = async (req, res) => {
  try {
    const sharedDocs = await SharedDoc.find({ isPublished: true })
      .populate("uploadedBy", "name email")
      .populate("teacher", "name email")
      .sort({ createdAt: -1 });

    res.json(sharedDocs);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

// Get shared documents by tag
exports.getSharedDocsByTag = async (req, res) => {
  try {
    const { tag } = req.params;

    const sharedDocs = await SharedDoc.find({ tag, isPublished: true })
      .populate("uploadedBy", "name email")
      .populate("teacher", "name email")
      .sort({ createdAt: -1 });

    res.json(sharedDocs);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

// Get shared documents by teacher
exports.getSharedDocsByTeacher = async (req, res) => {
  try {
    const { teacherId } = req.params;

    const sharedDocs = await SharedDoc.find({ teacher: teacherId, isPublished: true })
      .populate("uploadedBy", "name email")
      .populate("teacher", "name email")
      .sort({ createdAt: -1 });

    res.json(sharedDocs);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

// Create a new shared document
exports.createSharedDoc = async (req, res) => {
  try {
    // Get fields from body (multer parses form fields to body)
    const { title, description, tag, subject, teacher, targetClass } = req.body;
    const userId = req.userId;

    console.log("Creating shared doc - Title:", title);
    console.log("req.body:", req.body);
    console.log("req.file:", req.file);

    if (!title) {
      return res.status(400).json({
        error: "title is required"
      });
    }

    // Get file URL from uploaded file or generate placeholder
    let fileUrl = `/uploads/shared-docs/${Date.now()}_${(title || 'document').replace(/\s+/g, '_')}.pdf`;
    if (req.file) {
      fileUrl = `/uploads/${req.file.filename}`;
    }

    const sharedDoc = new SharedDoc({
      title,
      description: description || "",
      targetClass: targetClass || "",
      fileUrl,
      fileType: req.file?.mimetype || "pdf",
      tag: tag || subject || "Autre",
      teacher: teacher || userId,
      uploadedBy: userId,
      isPublished: true
    });

    await sharedDoc.save();
    await sharedDoc.populate("uploadedBy", "name email");
    await sharedDoc.populate("teacher", "name email");

    res.status(201).json({
      message: "Shared document created successfully",
      data: sharedDoc
    });
  } catch (err) {
    console.error("Error creating shared doc:", err);
    res.status(400).json({ error: err.message });
  }
};

// Update a shared document
exports.updateSharedDoc = async (req, res) => {
  try {
    const { id } = req.params;
    const { title, description, tag, isPublished } = req.body;

    const sharedDoc = await SharedDoc.findByIdAndUpdate(
      id,
      { title, description, tag, isPublished },
      { new: true }
    )
      .populate("uploadedBy", "name email")
      .populate("teacher", "name email");

    if (!sharedDoc) {
      return res.status(404).json({ error: "Shared document not found" });
    }

    res.json({
      message: "Shared document updated successfully",
      data: sharedDoc
    });
  } catch (err) {
    res.status(400).json({ error: err.message });
  }
};

// Increment view count
exports.incrementViews = async (req, res) => {
  try {
    const { id } = req.params;

    const sharedDoc = await SharedDoc.findByIdAndUpdate(
      id,
      { $inc: { views: 1 } },
      { new: true }
    );

    if (!sharedDoc) {
      return res.status(404).json({ error: "Shared document not found" });
    }

    res.json(sharedDoc);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

// Delete a shared document
exports.deleteSharedDoc = async (req, res) => {
  try {
    const { id } = req.params;

    const sharedDoc = await SharedDoc.findByIdAndDelete(id);

    if (!sharedDoc) {
      return res.status(404).json({ error: "Shared document not found" });
    }

    res.json({ message: "Shared document deleted successfully" });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};
