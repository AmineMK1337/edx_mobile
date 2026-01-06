const SchoolInfo = require("../models/school_info");

/**
 * Get school info (About page data)
 */
exports.getSchoolInfo = async (req, res) => {
  try {
    let schoolInfo = await SchoolInfo.findOne();

    // If no school info exists, create default
    if (!schoolInfo) {
      schoolInfo = await SchoolInfo.create({
        name: "SUP'COM",
        fullName: "École Supérieure des Communications de Tunis",
        presentation: "L'École Supérieure des Communications de Tunis est la grande école d'ingénieurs des télécommunications en Tunisie. Fondée en 1998, elle forme des ingénieurs de haut niveau dans les domaines des télécommunications, des réseaux et des technologies de l'information.",
        studentsCount: "1200+",
        teachersCount: "90+",
        partnersCount: "30+",
        labsCount: "15",
        departments: [
          "Réseaux et Services",
          "Systèmes de Communications",
          "Technologies du Numérique",
          "Langues et Management"
        ],
        address: "Cité Technologique des Communications, Raoued",
        phone: "+216 70 011 000",
        email: "contact@supcom.tn",
        website: "www.supcom.tn"
      });
    }

    res.json({
      presentation: schoolInfo.presentation,
      studentsCount: schoolInfo.studentsCount,
      teachersCount: schoolInfo.teachersCount,
      partnersCount: schoolInfo.partnersCount,
      labsCount: schoolInfo.labsCount,
      departments: schoolInfo.departments,
      address: schoolInfo.address,
      phone: schoolInfo.phone,
      website: schoolInfo.website
    });
  } catch (error) {
    console.error("Error fetching school info:", error);
    res.status(500).json({ message: "Server error" });
  }
};

/**
 * Update school info (Admin only)
 */
exports.updateSchoolInfo = async (req, res) => {
  try {
    const {
      presentation,
      studentsCount,
      teachersCount,
      partnersCount,
      labsCount,
      departments,
      address,
      phone,
      email,
      website,
      logoUrl,
      imageUrl
    } = req.body;

    let schoolInfo = await SchoolInfo.findOne();

    if (!schoolInfo) {
      schoolInfo = new SchoolInfo();
    }

    // Update provided fields
    if (presentation) schoolInfo.presentation = presentation;
    if (studentsCount) schoolInfo.studentsCount = studentsCount;
    if (teachersCount) schoolInfo.teachersCount = teachersCount;
    if (partnersCount) schoolInfo.partnersCount = partnersCount;
    if (labsCount) schoolInfo.labsCount = labsCount;
    if (departments) schoolInfo.departments = departments;
    if (address) schoolInfo.address = address;
    if (phone) schoolInfo.phone = phone;
    if (email) schoolInfo.email = email;
    if (website) schoolInfo.website = website;
    if (logoUrl) schoolInfo.logoUrl = logoUrl;
    if (imageUrl) schoolInfo.imageUrl = imageUrl;

    await schoolInfo.save();

    res.json({ message: "School info updated successfully", schoolInfo });
  } catch (error) {
    console.error("Error updating school info:", error);
    res.status(500).json({ message: "Server error" });
  }
};
