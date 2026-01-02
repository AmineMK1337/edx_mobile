const Absence = require("../models/absence");

exports.getAbsences = async (req, res) => {
  try {
    const absences = await Absence.find()
      .populate("student", "name email matricule")
      .populate("course", "title code")
      .populate("class", "name")
      .populate("takenBy", "name email")
      .populate("academicYear", "year semester")
      .sort({ date: -1 });
    
    // Group by course, sessionType, class to get unique sessions
    const sessions = {};
    absences.forEach((absence) => {
      const key = `${absence.course?._id}_${absence.sessionType}_${absence.class?._id}`;
      if (!sessions[key]) {
        sessions[key] = {
          _id: absence._id,
          course: absence.course,
          sessionType: absence.sessionType,
          class: absence.class,
          date: absence.date,
          status: "recorded",
          time: new Date(absence.date).toLocaleTimeString(),
          absentCount: 0,
          presentCount: 0,
          lateCount: 0,
        };
      }
    });

    // Count attendance status per session
    absences.forEach((absence) => {
      const key = `${absence.course?._id}_${absence.sessionType}_${absence.class?._id}`;
      if (absence.status === "absent") {
        sessions[key].absentCount++;
      } else if (absence.status === "present") {
        sessions[key].presentCount++;
      } else if (absence.status === "late") {
        sessions[key].lateCount++;
      }
    });

    const uniqueSessions = Object.values(sessions);
    res.json(uniqueSessions);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

exports.createAbsence = async (req, res) => {
  try {
    const absence = new Absence(req.body);
    await absence.save();
    await absence.populate("student", "name email");
    await absence.populate("course", "title code");
    await absence.populate("class", "name");
    res.status(201).json(absence);
  } catch (err) {
    res.status(400).json({ error: err.message });
  }
};

exports.updateAbsence = async (req, res) => {
  try {
    const { id } = req.params;
    const absence = await Absence.findByIdAndUpdate(id, req.body, { new: true })
      .populate("student", "name email")
      .populate("course", "title code")
      .populate("class", "name");
    if (!absence) return res.status(404).json({ error: "Absence not found" });
    res.json(absence);
    res.json(absence);
  } catch (err) {
    res.status(400).json({ error: err.message });
  }
};

exports.deleteAbsence = async (req, res) => {
  try {
    const { id } = req.params;
    await Absence.findByIdAndDelete(id);
    res.json({ message: "Absence deleted" });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};
