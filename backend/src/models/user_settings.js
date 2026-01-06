const mongoose = require("mongoose");

const UserSettingsSchema = new mongoose.Schema(
  {
    userId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "User",
      required: true,
      unique: true
    },
    pushNotifications: {
      type: Boolean,
      default: true
    },
    gradeAlerts: {
      type: Boolean,
      default: true
    },
    messageAlerts: {
      type: Boolean,
      default: true
    },
    absenceAlerts: {
      type: Boolean,
      default: false
    },
    isDarkMode: {
      type: Boolean,
      default: false
    },
    language: {
      type: String,
      enum: ["Français", "English", "العربية"],
      default: "Français"
    },
    passwordLastChanged: {
      type: Date,
      default: Date.now
    }
  },
  { timestamps: true }
);

// Index for faster queries
UserSettingsSchema.index({ userId: 1 });

module.exports = mongoose.model("UserSettings", UserSettingsSchema);
