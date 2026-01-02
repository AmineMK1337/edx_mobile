const Note = require("../models/note");

exports.getNotes = async (req, res) => {
  try {
    const { studentId } = req.query;
    const filter = studentId ? { student: studentId } : {};
    const notes = await Note.find(filter)
      .populate("student", "name email matricule")
      .populate("course", "title code")
      .populate("exam", "title date")
      .populate("publishedBy", "name")
      .populate("academicYear", "year semester");
    res.json(notes);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

exports.createNote = async (req, res) => {
  try {
    const { student, course, exam, type, value, coefficient, publishedBy, academicYear } = req.body;
    const note = new Note({ student, course, exam, type, value, coefficient, publishedBy, academicYear });
    await note.save();
    await note.populate("student", "name email");
    await note.populate("course", "title code");
    await note.populate("publishedBy", "name");
    await note.populate("academicYear", "year semester");
    res.status(201).json(note);
  } catch (err) {
    res.status(400).json({ error: err.message });
  }
};

exports.updateNote = async (req, res) => {
  try {
    const { id } = req.params;
    const note = await Note.findByIdAndUpdate(id, req.body, { new: true })
      .populate("student", "name email")
      .populate("course", "title code")
      .populate("publishedBy", "name")
      .populate("academicYear", "year semester");
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
