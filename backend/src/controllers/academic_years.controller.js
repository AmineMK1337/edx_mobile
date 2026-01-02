const AcademicYear = require("../models/academic_year");

// Get all academic years
exports.getAllAcademicYears = async (req, res) => {
  try {
    const academicYears = await AcademicYear.find().sort({ year: -1, semester: 1 });
    res.json(academicYears);
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
};

// Get current academic year
exports.getCurrentAcademicYear = async (req, res) => {
  try {
    const currentYear = await AcademicYear.findOne({ isCurrent: true });
    if (!currentYear) {
      return res.status(404).json({ message: "No current academic year set" });
    }
    res.json(currentYear);
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
};

// Get academic year by ID
exports.getAcademicYearById = async (req, res) => {
  try {
    const academicYear = await AcademicYear.findById(req.params.id);
    if (!academicYear) {
      return res.status(404).json({ message: "Academic year not found" });
    }
    res.json(academicYear);
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
};

// Create new academic year
exports.createAcademicYear = async (req, res) => {
  const academicYear = new AcademicYear(req.body);
  try {
    const newAcademicYear = await academicYear.save();
    res.status(201).json(newAcademicYear);
  } catch (err) {
    res.status(400).json({ message: err.message });
  }
};

// Update academic year
exports.updateAcademicYear = async (req, res) => {
  try {
    const updatedYear = await AcademicYear.findByIdAndUpdate(
      req.params.id,
      req.body,
      { new: true }
    );
    
    if (!updatedYear) {
      return res.status(404).json({ message: "Academic year not found" });
    }
    res.json(updatedYear);
  } catch (err) {
    res.status(400).json({ message: err.message });
  }
};

// Set current academic year
exports.setCurrentAcademicYear = async (req, res) => {
  try {
    // Set all to not current
    await AcademicYear.updateMany({}, { isCurrent: false });
    
    // Set the specified one as current
    const currentYear = await AcademicYear.findByIdAndUpdate(
      req.params.id,
      { isCurrent: true },
      { new: true }
    );
    
    if (!currentYear) {
      return res.status(404).json({ message: "Academic year not found" });
    }
    res.json(currentYear);
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
};

// Delete academic year
exports.deleteAcademicYear = async (req, res) => {
  try {
    const deletedYear = await AcademicYear.findByIdAndDelete(req.params.id);
    if (!deletedYear) {
      return res.status(404).json({ message: "Academic year not found" });
    }
    res.json({ message: "Academic year deleted successfully" });
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
};
