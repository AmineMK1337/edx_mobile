const Announcement = require("../models/announcement");
const Class = require("../models/class");

// Get all announcements for a specific class
exports.getAnnouncementsByClass = async (req, res) => {
  try {
    const { classId } = req.params;

    // Validate ObjectId
    if (!classId.match(/^[0-9a-fA-F]{24}$/)) {
      return res.status(400).json({ error: "Invalid class ID" });
    }

    const announcements = await Announcement.find({ class: classId })
      .populate("createdBy", "name email role")
      .populate("class", "name level")
      .sort({ isPinned: -1, createdAt: -1 });

    res.json(announcements);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

// Get all announcements for current user's classes
exports.getAllAnnouncements = async (req, res) => {
  try {
    const announcements = await Announcement.find()
      .populate("createdBy", "name email role")
      .populate("class", "name level")
      .sort({ isPinned: -1, createdAt: -1 });

    res.json(announcements);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

// Create a new announcement
exports.createAnnouncement = async (req, res) => {
  try {
    const { title, content, classId, priority } = req.body;
    const userId = req.userId;

    if (!title || !content || !classId) {
      return res.status(400).json({ error: "Missing required fields: title, content, classId" });
    }

    // Verify class exists
    const classExists = await Class.findById(classId);
    if (!classExists) {
      return res.status(404).json({ error: "Class not found" });
    }

    const announcement = new Announcement({
      title,
      content,
      class: classId,
      createdBy: userId,
      priority: priority || "medium"
    });

    await announcement.save();
    await announcement.populate("createdBy", "name email role");
    await announcement.populate("class", "name level");

    res.status(201).json(announcement);
  } catch (err) {
    console.error("Error creating announcement:", err);
    res.status(400).json({ error: err.message });
  }
};

// Get a single announcement
exports.getAnnouncement = async (req, res) => {
  try {
    const { id } = req.params;
    const announcement = await Announcement.findById(id)
      .populate("createdBy", "name email role")
      .populate("class", "name level");

    if (!announcement) {
      return res.status(404).json({ error: "Announcement not found" });
    }

    res.json(announcement);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

// Update an announcement
exports.updateAnnouncement = async (req, res) => {
  try {
    const { id } = req.params;
    const { title, content, priority, isPinned } = req.body;
    const userId = req.userId;

    const announcement = await Announcement.findById(id);

    if (!announcement) {
      return res.status(404).json({ error: "Announcement not found" });
    }

    // Only creator can update
    if (announcement.createdBy.toString() !== userId) {
      return res.status(403).json({ error: "Unauthorized" });
    }

    if (title) announcement.title = title;
    if (content) announcement.content = content;
    if (priority) announcement.priority = priority;
    if (isPinned !== undefined) announcement.isPinned = isPinned;

    await announcement.save();
    await announcement.populate("createdBy", "name email role");
    await announcement.populate("class", "name level");

    res.json(announcement);
  } catch (err) {
    res.status(400).json({ error: err.message });
  }
};

// Delete an announcement
exports.deleteAnnouncement = async (req, res) => {
  try {
    const { id } = req.params;
    const userId = req.userId;

    const announcement = await Announcement.findById(id);

    if (!announcement) {
      return res.status(404).json({ error: "Announcement not found" });
    }

    // Only creator can delete
    if (announcement.createdBy.toString() !== userId) {
      return res.status(403).json({ error: "Unauthorized" });
    }

    await Announcement.findByIdAndDelete(id);
    res.json({ message: "Announcement deleted" });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

// Pin/Unpin announcement
exports.togglePin = async (req, res) => {
  try {
    const { id } = req.params;
    const userId = req.userId;

    const announcement = await Announcement.findById(id);

    if (!announcement) {
      return res.status(404).json({ error: "Announcement not found" });
    }

    // Only creator can pin
    if (announcement.createdBy.toString() !== userId) {
      return res.status(403).json({ error: "Unauthorized" });
    }

    announcement.isPinned = !announcement.isPinned;
    await announcement.save();

    res.json(announcement);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};
