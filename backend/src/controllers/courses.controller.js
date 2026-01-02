const Course = require("../models/course");

exports.getCourses = async (req, res) => {
  try {
    const courses = await Course.find()
      .populate("professor", "name email")
      .populate("class", "name level section")
      .populate("academicYear", "year semester");
    res.json(courses);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

exports.createCourse = async (req, res) => {
  try {
    const course = new Course(req.body);
    await course.save();
    await course.populate("professor", "name email");
    await course.populate("class", "name level section");
    await course.populate("academicYear", "year semester");
    res.status(201).json(course);
  } catch (err) {
    res.status(400).json({ error: err.message });
  }
};

exports.updateCourse = async (req, res) => {
  try {
    const { id } = req.params;
    const course = await Course.findByIdAndUpdate(id, req.body, { new: true })
      .populate("professor", "name email")
      .populate("class", "name level section")
      .populate("academicYear", "year semester");
    if (!course) return res.status(404).json({ error: "Course not found" });
    res.json(course);
  } catch (err) {
    res.status(400).json({ error: err.message });
  }
};

exports.deleteCourse = async (req, res) => {
  try {
    const { id } = req.params;
    await Course.findByIdAndDelete(id);
    res.json({ message: "Course deleted" });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};
