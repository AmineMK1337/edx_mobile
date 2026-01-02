const Message = require("../models/message");
const User = require("../models/user");

// Get all conversations for the current user
exports.getConversations = async (req, res) => {
  try {
    const userId = req.user.id;

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
    const userId = req.user.id;

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
    const { recipientId, content, courseId } = req.body;
    const userId = req.user.id;

    if (!recipientId || !content) {
      return res.status(400).json({ error: "Missing required fields" });
    }

    // Don't allow sending message to self
    if (userId === recipientId) {
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
    const userId = req.user.id;

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
