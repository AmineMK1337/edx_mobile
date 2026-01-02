const Exam = require("../models/exam");

exports.getExams = async (req, res) => {
  try {
    const exams = await Exam.find()
      .populate("course", "title code")
      .populate("class", "name level section")
      .populate("professor", "name email")
      .populate("academicYear", "year semester")
      .sort({ date: 1 });
    res.json(exams);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

exports.createExam = async (req, res) => {
  try {
    const exam = new Exam(req.body);
    await exam.save();
    await exam.populate("course", "title code");
    await exam.populate("class", "name level section");
    await exam.populate("professor", "name email");
    await exam.populate("academicYear", "year semester");
    res.status(201).json(exam);
  } catch (err) {
    res.status(400).json({ error: err.message });
  }
};

exports.updateExam = async (req, res) => {
  try {
    const { id } = req.params;
    const exam = await Exam.findByIdAndUpdate(id, req.body, { new: true })
      .populate("course", "title code")
      .populate("class", "name level section")
      .populate("professor", "name email")
      .populate("academicYear", "year semester");
    if (!exam) return res.status(404).json({ error: "Exam not found" });
    res.json(exam);
  } catch (err) {
    res.status(400).json({ error: err.message });
  }
};

exports.deleteExam = async (req, res) => {
  try {
    const { id } = req.params;
    await Exam.findByIdAndDelete(id);
    res.json({ message: "Exam deleted" });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};
