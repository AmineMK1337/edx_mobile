const express = require("express");
const router = express.Router();
const calendarEventsController = require("../controllers/calendar_events.controller");

router.get("/", calendarEventsController.getEvents);
router.post("/", calendarEventsController.createEvent);
router.put("/:id", calendarEventsController.updateEvent);
router.delete("/:id", calendarEventsController.deleteEvent);

module.exports = router;
