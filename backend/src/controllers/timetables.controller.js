const Timetable = require("../models/timetable");
const Class = require("../models/class");
const multer = require("multer");
const path = require("path");
const fs = require("fs");

// Configure multer for PDF upload
const storage = multer.diskStorage({
  destination: function (req, file, cb) {
    const uploadPath = path.join(__dirname, "../../uploads/timetables");
    if (!fs.existsSync(uploadPath)) {
      fs.mkdirSync(uploadPath, { recursive: true });
    }
    cb(null, uploadPath);
  },
  filename: function (req, file, cb) {
    const timestamp = Date.now();
    const classId = req.body.class;
    const semester = req.body.semester;
    cb(null, `timetable_${classId}_${semester}_${timestamp}.pdf`);
  }
});

const fileFilter = (req, file, cb) => {
  if (file.mimetype === "application/pdf") {
    cb(null, true);
  } else {
    cb(new Error("Only PDF files are allowed!"), false);
  }
};

// Multer upload configuration
exports.upload = multer({
  storage: storage,
  fileFilter: fileFilter,
  limits: {
    fileSize: 10 * 1024 * 1024, // 10MB limit
  },
});

// Get all timetables
exports.getAllTimetables = async (req, res) => {
  try {
    const timetables = await Timetable.find({ isActive: true })
      .populate("class", "name level section")
      .populate("uploadedBy", "name email")
      .sort({ createdAt: -1 });

    res.status(200).json(timetables);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Get timetables by class
exports.getTimetablesByClass = async (req, res) => {
  try {
    const { classId } = req.params;
    
    const timetables = await Timetable.find({ 
      class: classId, 
      isActive: true 
    })
      .populate("class", "name level section")
      .populate("uploadedBy", "name email")
      .sort({ semester: 1, createdAt: -1 });

    res.status(200).json(timetables);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Upload new timetable
exports.uploadTimetable = async (req, res) => {
  try {
    if (!req.file) {
      return res.status(400).json({ error: "PDF file is required" });
    }

    const { title, description, class: classId, academicYear, semester } = req.body;

    // Verify class exists
    const classDoc = await Class.findById(classId);
    if (!classDoc) {
      // Delete uploaded file if class doesn't exist
      fs.unlinkSync(req.file.path);
      return res.status(404).json({ error: "Class not found" });
    }

    // Deactivate previous timetables for the same class and semester
    await Timetable.updateMany(
      { class: classId, semester: semester },
      { isActive: false }
    );

    // Create new timetable record
    const timetable = new Timetable({
      title,
      description: description || "",
      class: classId,
      academicYear,
      semester,
      pdfFileName: req.file.filename,
      pdfFilePath: req.file.path,
      fileSize: req.file.size,
      uploadedBy: req.userId,
    });

    await timetable.save();
    await timetable.populate("class", "name level section");
    await timetable.populate("uploadedBy", "name email");

    res.status(201).json(timetable);
  } catch (error) {
    // Delete uploaded file if there's an error
    if (req.file) {
      fs.unlinkSync(req.file.path);
    }
    res.status(500).json({ error: error.message });
  }
};

// Download timetable PDF
exports.downloadTimetable = async (req, res) => {
  try {
    const { id } = req.params;
    
    const timetable = await Timetable.findById(id);
    if (!timetable) {
      return res.status(404).json({ error: "Timetable not found" });
    }

    // Check if file exists
    if (!fs.existsSync(timetable.pdfFilePath)) {
      return res.status(404).json({ error: "PDF file not found" });
    }

    // Increment download count
    timetable.downloadCount += 1;
    await timetable.save();

    // Set headers for PDF download
    res.setHeader("Content-Type", "application/pdf");
    res.setHeader("Content-Disposition", `attachment; filename="${timetable.pdfFileName}"`);
    
    // Stream the file
    const fileStream = fs.createReadStream(timetable.pdfFilePath);
    fileStream.pipe(res);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Delete timetable
exports.deleteTimetable = async (req, res) => {
  try {
    const { id } = req.params;
    
    const timetable = await Timetable.findById(id);
    if (!timetable) {
      return res.status(404).json({ error: "Timetable not found" });
    }

    // Delete PDF file
    if (fs.existsSync(timetable.pdfFilePath)) {
      fs.unlinkSync(timetable.pdfFilePath);
    }

    // Delete database record
    await Timetable.findByIdAndDelete(id);

    res.status(200).json({ message: "Timetable deleted successfully" });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Get timetable by ID
exports.getTimetableById = async (req, res) => {
  try {
    const { id } = req.params;
    
    const timetable = await Timetable.findById(id)
      .populate("class", "name level section")
      .populate("uploadedBy", "name email");
      
    if (!timetable) {
      return res.status(404).json({ error: "Timetable not found" });
    }

    res.status(200).json(timetable);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};