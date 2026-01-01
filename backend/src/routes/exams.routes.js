const express = require("express");
const router = express.Router();
const examsController = require("../controllers/exams.controller");

router.get("/", examsController.getExams);
router.post("/", examsController.createExam);
router.put("/:id", examsController.updateExam);
router.delete("/:id", examsController.deleteExam);

module.exports = router;
