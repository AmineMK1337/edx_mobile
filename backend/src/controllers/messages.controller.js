const Message = require("../models/message");
const User = require("../models/user");
const mongoose = require("mongoose");

// Get all messages (sent and received) for the current user
exports.getAllMessages = async (req, res) => {
  try {
    const userId = req.userId;
    const { filter } = req.query; // 'sent', 'received', or 'all' (default)

    let query = {};
    if (filter === 'sent') {
      query = { sender: userId };
    } else if (filter === 'received') {
      query = { recipient: userId };
    } else {
      query = { $or: [{ sender: userId }, { recipient: userId }] };
    }

    const messages = await Message.find(query)
      .populate("sender", "name email role")
      .populate("recipient", "name email role")
      .sort({ createdAt: -1 });

    res.json(messages);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

// Get all conversations for the current user
exports.getConversations = async (req, res) => {
  try {
    const userId = new mongoose.Types.ObjectId(req.userId);

    // Get all conversations where user is either sender or recipient
    const conversations = await Message.aggregate([
      {
        $match: {
          $or: [{ sender: userId }, { recipient: userId }]
        }
      },
      {
        $sort: { createdAt: -1 }
      },
      {
        $group: {
          _id: {
            $cond: [
              { $eq: ["$sender", userId] },
              "$recipient",
              "$sender"
            ]
          },
          lastMessage: { $first: "$content" },
          lastMessageTime: { $first: "$createdAt" },
          unreadCount: {
            $sum: {
              $cond: [
                {
                  $and: [
                    { $eq: ["$recipient", userId] },
                    { $eq: ["$isRead", false] }
                  ]
                },
                1,
                0
              ]
            }
          }
        }
      },
      {
        $sort: { lastMessageTime: -1 }
      },
      {
        $lookup: {
          from: "users",
          localField: "_id",
          foreignField: "_id",
          as: "userInfo"
        }
      },
      {
        $unwind: "$userInfo"
      },
      {
        $project: {
          _id: 0,
          userId: "$_id",
          name: "$userInfo.name",
          email: "$userInfo.email",
          lastMessage: 1,
          lastMessageTime: 1,
          unreadCount: 1
        }
      }
    ]);

    res.json(conversations);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

// Get messages between two users (conversation)
exports.getConversation = async (req, res) => {
  try {
    const { recipientId } = req.params;
    const userId = req.userId;

    // Validate ObjectId
    if (!recipientId.match(/^[0-9a-fA-F]{24}$/)) {
      return res.status(400).json({ error: "Invalid recipient ID" });
    }

    const messages = await Message.find({
      $or: [
        { sender: userId, recipient: recipientId },
        { sender: recipientId, recipient: userId }
      ]
    })
      .populate("sender", "name email")
      .populate("recipient", "name email")
      .sort({ createdAt: 1 });

    // Mark messages as read
    await Message.updateMany(
      { sender: recipientId, recipient: userId, isRead: false },
      { isRead: true }
    );

    res.json(messages);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

// Send a message
exports.sendMessage = async (req, res) => {
  try {
    let { recipientId, content, courseId, role, specificName } = req.body;
    const userId = req.userId;

    if (!content) {
      return res.status(400).json({ error: "Content is required" });
    }

    // If recipientId is not provided, try to find user by role and name
    if (!recipientId) {
      if (!role) {
        return res.status(400).json({ error: "recipientId or role is required" });
      }

      // Map French role names to database roles
      const roleMap = {
        'Professeur': 'professor',
        'Administrateur': 'admin',
        'Student': 'student',
        'professor': 'professor',
        'admin': 'admin',
        'student': 'student'
      };

      const dbRole = roleMap[role] || role.toLowerCase();

      // Find a user with the specified role
      let query = { role: dbRole };
      if (specificName && specificName.trim()) {
        query.name = { $regex: specificName, $options: "i" };
      }

      const recipient = await User.findOne(query).select("_id");
      if (!recipient) {
        return res.status(404).json({ error: `No ${role} found` });
      }

      recipientId = recipient._id;
    }

    // Don't allow sending message to self
    if (userId.toString() === recipientId.toString()) {
      return res.status(400).json({ error: "Cannot send message to yourself" });
    }

    const message = new Message({
      sender: userId,
      recipient: recipientId,
      course: courseId,
      content,
      isRead: false
    });

    await message.save();
    await message.populate("sender", "name email");
    await message.populate("recipient", "name email");

    res.status(201).json(message);
  } catch (err) {
    res.status(400).json({ error: err.message });
  }
};

// Get a single message
exports.getMessage = async (req, res) => {
  try {
    const { id } = req.params;
    const message = await Message.findById(id)
      .populate("sender", "name email")
      .populate("recipient", "name email");

    if (!message) {
      return res.status(404).json({ error: "Message not found" });
    }

    res.json(message);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

// Delete a message
exports.deleteMessage = async (req, res) => {
  try {
    const { id } = req.params;
    const userId = req.userId;

    const message = await Message.findById(id);

    if (!message) {
      return res.status(404).json({ error: "Message not found" });
    }

    // Only sender can delete their message
    if (message.sender.toString() !== userId) {
      return res.status(403).json({ error: "Unauthorized" });
    }

    await Message.findByIdAndDelete(id);
    res.json({ message: "Message deleted" });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

// Mark message as read
exports.markAsRead = async (req, res) => {
  try {
    const { id } = req.params;

    const message = await Message.findByIdAndUpdate(
      id,
      { isRead: true },
      { new: true }
    );

    if (!message) {
      return res.status(404).json({ error: "Message not found" });
    }

    res.json(message);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};
