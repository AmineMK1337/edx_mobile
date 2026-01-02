const Schedule = require("../models/schedule");

exports.getSchedules = async (req, res) => {
  try {
    const { class: classId } = req.query;
    const filter = classId ? { class: classId } : {};
    const schedules = await Schedule.find(filter)
      .populate("class", "name level section")
      .populate("course", "title code")
      .populate("professor", "name email")
      .populate("academicYear", "year semester");
    res.json(schedules);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

exports.createSchedule = async (req, res) => {
  try {
    const schedule = new Schedule(req.body);
    await schedule.save();
    await schedule.populate("class", "name level section");
    await schedule.populate("course", "title code");
    await schedule.populate("professor", "name email");
    await schedule.populate("academicYear", "year semester");
    res.status(201).json(schedule);
  } catch (err) {
    res.status(400).json({ error: err.message });
  }
};

exports.updateSchedule = async (req, res) => {
  try {
    const { id } = req.params;
    const schedule = await Schedule.findByIdAndUpdate(id, req.body, { new: true })
      .populate("class", "name level section")
      .populate("course", "title code")
      .populate("professor", "name email")
      .populate("academicYear", "year semester");
    if (!schedule) return res.status(404).json({ error: "Schedule not found" });
    res.json(schedule);
  } catch (err) {
    res.status(400).json({ error: err.message });
  }
};

exports.deleteSchedule = async (req, res) => {
  try {
    const { id } = req.params;
    await Schedule.findByIdAndDelete(id);
    res.json({ message: "Schedule deleted" });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};
