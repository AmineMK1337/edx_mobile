const express = require("express");
const router = express.Router();
const { authenticate } = require("../middlewares/auth");
const absencesController = require("../controllers/absences.controller");

router.get("/", authenticate, absencesController.getAbsences);
router.post("/", authenticate, absencesController.createAbsence);
router.put("/:id", authenticate, absencesController.updateAbsence);
router.delete("/:id", authenticate, absencesController.deleteAbsence);

module.exports = router;
