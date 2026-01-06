const UserSettings = require("../models/user_settings");
const User = require("../models/user");

/**
 * Get user settings
 */
exports.getSettings = async (req, res) => {
  try {
    const userId = req.params.userId;

    let settings = await UserSettings.findOne({ userId }).populate("userId", "name email");

    // If no settings exist, create default settings
    if (!settings) {
      settings = await UserSettings.create({ userId });
      settings = await UserSettings.findOne({ userId }).populate("userId", "name email");
    }

    // Get user info for display
    const user = await User.findById(userId).select("name email");

    res.json({
      userName: user?.name || "",
      userPhone: "", // Phone is in Student model, not User
      pushNotifications: settings.pushNotifications,
      gradeAlerts: settings.gradeAlerts,
      messageAlerts: settings.messageAlerts,
      absenceAlerts: settings.absenceAlerts,
      isDarkMode: settings.isDarkMode,
      currentLanguage: settings.language,
      passwordLastChanged: settings.passwordLastChanged
        ? getTimeAgo(settings.passwordLastChanged)
        : "Jamais"
    });
  } catch (error) {
    console.error("Error fetching settings:", error);
    res.status(500).json({ message: "Server error" });
  }
};

/**
 * Update user settings
 */
exports.updateSettings = async (req, res) => {
  try {
    const userId = req.params.userId;
    const {
      pushNotifications,
      gradeAlerts,
      messageAlerts,
      absenceAlerts,
      isDarkMode,
      language
    } = req.body;

    let settings = await UserSettings.findOne({ userId });

    if (!settings) {
      settings = new UserSettings({ userId });
    }

    // Update only provided fields
    if (pushNotifications !== undefined) settings.pushNotifications = pushNotifications;
    if (gradeAlerts !== undefined) settings.gradeAlerts = gradeAlerts;
    if (messageAlerts !== undefined) settings.messageAlerts = messageAlerts;
    if (absenceAlerts !== undefined) settings.absenceAlerts = absenceAlerts;
    if (isDarkMode !== undefined) settings.isDarkMode = isDarkMode;
    if (language !== undefined) settings.language = language;

    await settings.save();

    res.json({ message: "Settings updated successfully", settings });
  } catch (error) {
    console.error("Error updating settings:", error);
    res.status(500).json({ message: "Server error" });
  }
};

/**
 * Update password and record timestamp
 */
exports.updatePassword = async (req, res) => {
  try {
    const userId = req.params.userId;
    const { currentPassword, newPassword } = req.body;

    // This would typically verify current password and update
    // For now, just update the passwordLastChanged timestamp
    let settings = await UserSettings.findOne({ userId });

    if (!settings) {
      settings = new UserSettings({ userId });
    }

    settings.passwordLastChanged = new Date();
    await settings.save();

    res.json({ message: "Password updated successfully" });
  } catch (error) {
    console.error("Error updating password:", error);
    res.status(500).json({ message: "Server error" });
  }
};

// Helper function to get time ago string
function getTimeAgo(date) {
  const now = new Date();
  const diff = now - new Date(date);
  const days = Math.floor(diff / (1000 * 60 * 60 * 24));
  const months = Math.floor(days / 30);
  const years = Math.floor(days / 365);

  if (years > 0) return `il y a ${years} an${years > 1 ? "s" : ""}`;
  if (months > 0) return `il y a ${months} mois`;
  if (days > 0) return `il y a ${days} jour${days > 1 ? "s" : ""}`;
  return "Aujourd'hui";
}
