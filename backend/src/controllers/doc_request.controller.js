const DocRequest = require("../models/doc_request");
const Student = require("../models/student");

// Submit a document request
exports.submitRequest = async (req, res) => {
  try {
    const { studentId, studentName, documentType, comment } = req.body;

    // Validate required fields
    if (!studentId || !studentName || !documentType) {
      return res.status(400).json({
        error: "studentId, studentName, and documentType are required"
      });
    }

    // Create new document request
    const docRequest = new DocRequest({
      studentId,
      studentName,
      documentType,
      comment: comment || "",
      status: "pending"
    });

    await docRequest.save();

    res.status(201).json({
      message: "Document request submitted successfully",
      data: docRequest
    });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

// Get all document requests (admin/staff only)
exports.getAllRequests = async (req, res) => {
  try {
    const requests = await DocRequest.find()
      .sort({ createdAt: -1 });

    res.json({
      total: requests.length,
      data: requests
    });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

// Get document requests by student
exports.getStudentRequests = async (req, res) => {
  try {
    const { studentId } = req.params;

    const requests = await DocRequest.find({ studentId })
      .sort({ createdAt: -1 });

    res.json({
      total: requests.length,
      data: requests
    });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

// Update request status (admin/staff only)
exports.updateRequestStatus = async (req, res) => {
  try {
    const { id } = req.params;
    const { status } = req.body;

    const validStatuses = ["pending", "approved", "rejected", "completed"];
    if (!validStatuses.includes(status)) {
      return res.status(400).json({
        error: `Status must be one of: ${validStatuses.join(", ")}`
      });
    }

    const docRequest = await DocRequest.findByIdAndUpdate(
      id,
      {
        status,
        completionDate: status === "completed" ? Date.now() : null
      },
      { new: true }
    );

    if (!docRequest) {
      return res.status(404).json({ error: "Document request not found" });
    }

    res.json({
      message: "Request status updated successfully",
      data: docRequest
    });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

// Delete a document request
exports.deleteRequest = async (req, res) => {
  try {
    const { id } = req.params;

    const docRequest = await DocRequest.findByIdAndDelete(id);

    if (!docRequest) {
      return res.status(404).json({ error: "Document request not found" });
    }

    res.json({ message: "Document request deleted successfully" });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};
