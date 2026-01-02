const Document = require("../models/document");
const Course = require("../models/course");

// Get all documents for a course
exports.getDocumentsByCourse = async (req, res) => {
  try {
    const { courseId } = req.params;

    const documents = await Document.find({ course: courseId, isPublished: true })
      .populate("uploadedBy", "name email")
      .populate("course", "title")
      .sort({ createdAt: -1 });

    res.json(documents);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

// Get all documents uploaded by a user
exports.getDocumentsByUploader = async (req, res) => {
  try {
    const { uploaderId } = req.params;

    const documents = await Document.find({ uploadedBy: uploaderId })
      .populate("uploadedBy", "name email")
      .populate("course", "title code")
      .sort({ createdAt: -1 });

    res.json(documents);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

// Create a new document
exports.createDocument = async (req, res) => {
  try {
    const { title, description, courseId, fileUrl, fileType } = req.body;

    // Validate course exists
    const course = await Course.findById(courseId);
    if (!course) {
      return res.status(404).json({ error: "Course not found" });
    }

    const document = new Document({
      title,
      description,
      course: courseId,
      fileUrl,
      fileType: fileType || "pdf",
      uploadedBy: req.user?.id,
      isPublished: true
    });

    await document.save();
    await document.populate("uploadedBy", "name email");
    await document.populate("course", "title code");

    res.status(201).json(document);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

// Get document by ID
exports.getDocument = async (req, res) => {
  try {
    const { id } = req.params;

    const document = await Document.findByIdAndUpdate(
      id,
      { $inc: { downloads: 1 } }, // Increment downloads
      { new: true }
    )
      .populate("uploadedBy", "name email")
      .populate("course", "title code");

    if (!document) {
      return res.status(404).json({ error: "Document not found" });
    }

    res.json(document);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

// Update document
exports.updateDocument = async (req, res) => {
  try {
    const { id } = req.params;
    const { title, description, fileUrl, fileType, isPublished } = req.body;

    const document = await Document.findByIdAndUpdate(
      id,
      { title, description, fileUrl, fileType, isPublished },
      { new: true }
    )
      .populate("uploadedBy", "name email")
      .populate("course", "title code");

    if (!document) {
      return res.status(404).json({ error: "Document not found" });
    }

    res.json(document);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

// Delete document
exports.deleteDocument = async (req, res) => {
  try {
    const { id } = req.params;

    const document = await Document.findByIdAndDelete(id);

    if (!document) {
      return res.status(404).json({ error: "Document not found" });
    }

    res.json({ message: "Document deleted successfully" });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};
