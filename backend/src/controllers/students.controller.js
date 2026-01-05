const Student = require("../models/student");
const User = require("../models/user");

/**
 * Get all students with optional filtering
 */
exports.getStudents = async (req, res) => {
  try {
    const { classId, isActive } = req.query;

    let query = {};
    if (classId) query.studentClass = classId;
    if (isActive !== undefined) query.isActive = isActive === "true";

    const students = await Student.find(query)
      .populate("userId", "name email role")
      .populate("studentClass", "name code");

    res.json(students);
  } catch (error) {
    console.error("Error fetching students:", error);
    res.status(500).json({ message: "Server error" });
  }
};

/**
 * Get a single student by ID
 */
exports.getStudentById = async (req, res) => {
  try {
    const student = await Student.findById(req.params.id)
      .populate("userId", "name email role")
      .populate("studentClass", "name code");

    if (!student) {
      return res.status(404).json({ message: "Student not found" });
    }

    res.json(student);
  } catch (error) {
    console.error("Error fetching student:", error);
    res.status(500).json({ message: "Server error" });
  }
};

/**
 * Get students by class
 */
exports.getStudentsByClass = async (req, res) => {
  try {
    const students = await Student.find({
      studentClass: req.params.classId,
      isActive: true
    })
      .populate("userId", "name email")
      .populate("studentClass", "name code");

    res.json(students);
  } catch (error) {
    console.error("Error fetching students by class:", error);
    res.status(500).json({ message: "Server error" });
  }
};

/**
 * Create a new student profile
 */
exports.createStudent = async (req, res) => {
  try {
    const {
      userId,
      firstName,
      lastName,
      email,
      phone,
      address,
      birthDate,
      photoUrl,
      studentClass,
      matricule
    } = req.body;

    // Validate required fields
    if (
      !userId ||
      !firstName ||
      !lastName ||
      !email ||
      !studentClass ||
      !matricule
    ) {
      return res.status(400).json({
        message:
          "Missing required fields: userId, firstName, lastName, email, studentClass, matricule"
      });
    }

    // Check if student already exists
    let existingStudent = await Student.findOne({ email });
    if (existingStudent) {
      return res
        .status(400)
        .json({ message: "Student with this email already exists" });
    }

    // Check if matricule is unique
    existingStudent = await Student.findOne({ matricule });
    if (existingStudent) {
      return res
        .status(400)
        .json({ message: "Student with this matricule already exists" });
    }

    const student = new Student({
      userId,
      firstName,
      lastName,
      email,
      phone: phone || "",
      address: address || "",
      birthDate: birthDate || null,
      photoUrl: photoUrl || null,
      studentClass,
      matricule
    });

    await student.save();

    const populatedStudent = await Student.findById(student._id)
      .populate("userId", "name email")
      .populate("studentClass", "name code");

    res.status(201).json(populatedStudent);
  } catch (error) {
    console.error("Error creating student:", error);
    res.status(500).json({ message: "Error creating student profile" });
  }
};

/**
 * Update student profile
 */
exports.updateStudent = async (req, res) => {
  try {
    // Prevent modification of sensitive fields
    const forbiddenFields = ["matricule", "studentClass", "userId"];
    const updates = { ...req.body };

    forbiddenFields.forEach((field) => {
      delete updates[field];
    });

    const updatedStudent = await Student.findByIdAndUpdate(
      req.params.id,
      { $set: updates },
      { new: true, runValidators: true }
    )
      .populate("userId", "name email")
      .populate("studentClass", "name code");

    if (!updatedStudent) {
      return res.status(404).json({ message: "Student not found" });
    }

    res.json(updatedStudent);
  } catch (error) {
    console.error("Error updating student:", error);
    res.status(500).json({ message: "Error updating student profile" });
  }
};

/**
 * Delete (soft delete) a student
 */
exports.deleteStudent = async (req, res) => {
  try {
    const student = await Student.findByIdAndUpdate(
      req.params.id,
      { isActive: false },
      { new: true }
    );

    if (!student) {
      return res.status(404).json({ message: "Student not found" });
    }

    res.json({ message: "Student deactivated successfully", student });
  } catch (error) {
    console.error("Error deactivating student:", error);
    res.status(500).json({ message: "Server error" });
  }
};

/**
 * Get student profile with full details
 */
exports.getStudentProfile = async (req, res) => {
  try {
    const student = await Student.findById(req.params.id)
      .populate("userId")
      .populate("studentClass");

    if (!student) {
      return res.status(404).json({ message: "Student not found" });
    }

    res.json(student);
  } catch (error) {
    console.error("Error fetching student profile:", error);
    res.status(500).json({ message: "Server error" });
  }
};
