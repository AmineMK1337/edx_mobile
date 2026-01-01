const Note = require("../models/note");

exports.getNotes = async (req, res) => {
  try {
    const { studentId } = req.query;
    const filter = studentId ? { student: studentId } : {};
    const notes = await Note.find(filter)
      .populate("student", "name email")
      .populate("publishedBy", "name");
    res.json(notes);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

exports.createNote = async (req, res) => {
  try {
    const { student, subject, value, publishedBy } = req.body;
    const note = new Note({ student, subject, value, publishedBy });
    await note.save();
    await note.populate("student", "name email");
    await note.populate("publishedBy", "name");
    res.status(201).json(note);
  } catch (err) {
    res.status(400).json({ error: err.message });
  }
};

exports.updateNote = async (req, res) => {
  try {
    const { id } = req.params;
    const { value } = req.body;
    const note = await Note.findByIdAndUpdate(id, { value }, { new: true })
      .populate("student", "name email")
      .populate("publishedBy", "name");
    if (!note) return res.status(404).json({ error: "Note not found" });
    res.json(note);
  } catch (err) {
    res.status(400).json({ error: err.message });
  }
};

exports.deleteNote = async (req, res) => {
  try {
    const { id } = req.params;
    await Note.findByIdAndDelete(id);
    res.json({ message: "Note deleted" });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};
