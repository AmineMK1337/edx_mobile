const express = require("express");
const router = express.Router();
const schedulesController = require("../controllers/schedules.controller");

router.get("/", schedulesController.getSchedules);
router.post("/", schedulesController.createSchedule);
router.put("/:id", schedulesController.updateSchedule);
router.delete("/:id", schedulesController.deleteSchedule);

module.exports = router;
