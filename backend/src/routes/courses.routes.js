const express = require("express");
const router = express.Router();
const { authenticate } = require("../middlewares/auth");
const coursesController = require("../controllers/courses.controller");

router.get("/", authenticate, coursesController.getCourses);
router.post("/", authenticate, coursesController.createCourse);
router.put("/:id", authenticate, coursesController.updateCourse);
router.delete("/:id", authenticate, coursesController.deleteCourse);

module.exports = router;
