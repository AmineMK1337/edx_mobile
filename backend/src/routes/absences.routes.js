const express = require("express");
const router = express.Router();
const absencesController = require("../controllers/absences.controller");

router.get("/", absencesController.getAbsences);
router.post("/", absencesController.createAbsence);
router.put("/:id", absencesController.updateAbsence);
router.delete("/:id", absencesController.deleteAbsence);

module.exports = router;
