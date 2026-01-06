const express = require("express");
const router = express.Router();
const generalInfoController = require("../controllers/general_info.controller");

// Get all general info (for the mobile app)
router.get("/", generalInfoController.getGeneralInfo);

// ============== FAQ Routes ==============
router.get("/faqs", generalInfoController.getFaqs);
router.post("/faqs", generalInfoController.createFaq);
router.put("/faqs/:id", generalInfoController.updateFaq);
router.delete("/faqs/:id", generalInfoController.deleteFaq);

// ============== Services Routes ==============
router.get("/services", generalInfoController.getServices);
router.post("/services", generalInfoController.createService);
router.put("/services/:id", generalInfoController.updateService);
router.delete("/services/:id", generalInfoController.deleteService);

// ============== Academic Calendar Routes ==============
router.get("/calendar", generalInfoController.getCalendarEvents);
router.post("/calendar", generalInfoController.createCalendarEvent);
router.put("/calendar/:id", generalInfoController.updateCalendarEvent);
router.delete("/calendar/:id", generalInfoController.deleteCalendarEvent);

module.exports = router;
