const Student = require("../models/student");
const User = require("../models/user");

/**
 * Get student profile with detailed information
 */
exports.getProfile = async (req, res) => {
  try {
    const studentId = req.params.id;

    const student = await Student.findById(studentId)
      .populate("userId", "name email")
      .populate("studentClass", "name code level");

    if (!student) {
      return res.status(404).json({ message: "Student not found" });
    }

    // Format birth date
    const birthDate = student.birthDate
      ? new Date(student.birthDate).toLocaleDateString("fr-FR", {
          day: "numeric",
          month: "long",
          year: "numeric"
        })
      : null;

    res.json({
      fullName: `${student.firstName} ${student.lastName}`,
      email: student.email,
      phone: student.phone || "",
      address: student.address || "",
      birthDate: birthDate,
      studentId: student.matricule,
      major: student.studentClass?.name || "",
      academicYear: getCurrentAcademicYear(),
      group: student.studentClass?.code || "",
      photoUrl: student.photoUrl
    });
  } catch (error) {
    console.error("Error fetching profile:", error);
    res.status(500).json({ message: "Server error" });
  }
};

/**
 * Update student profile
 */
exports.updateProfile = async (req, res) => {
  try {
    const studentId = req.params.id;
    const { phone, address, photoUrl } = req.body;

    const student = await Student.findById(studentId);

    if (!student) {
      return res.status(404).json({ message: "Student not found" });
    }

    // Update only allowed fields (students can't change name, email, etc.)
    if (phone !== undefined) student.phone = phone;
    if (address !== undefined) student.address = address;
    if (photoUrl !== undefined) student.photoUrl = photoUrl;

    await student.save();

    res.json({ message: "Profile updated successfully", student });
  } catch (error) {
    console.error("Error updating profile:", error);
    res.status(500).json({ message: "Server error" });
  }
};

// Helper function to get current academic year
function getCurrentAcademicYear() {
  const now = new Date();
  const year = now.getFullYear();
  const month = now.getMonth();

  // Academic year starts in September
  if (month >= 8) {
    return `${year}-${year + 1}`;
  }
  return `${year - 1}-${year}`;
}
