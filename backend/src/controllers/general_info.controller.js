const Faq = require("../models/faq");
const Service = require("../models/service");
const AcademicCalendar = require("../models/academic_calendar");
const Announcement = require("../models/announcement");

/**
 * Get all general info (FAQs, Services, Calendar, Latest Announcement)
 */
exports.getGeneralInfo = async (req, res) => {
  try {
    // Get active FAQs
    const faqs = await Faq.find({ isActive: true }).sort({ order: 1 });

    // Get active services
    const services = await Service.find({ isActive: true });

    // Get academic calendar events for current year
    const calendarEvents = await AcademicCalendar.find({ isActive: true })
      .sort({ startDate: 1 })
      .populate("academicYear", "name");

    // Get latest pinned or high priority announcement
    const latestAnnouncement = await Announcement.findOne({ isPinned: true })
      .sort({ createdAt: -1 })
      .select("title content");

    // Format response
    const response = {
      announcement: latestAnnouncement?.content || "",
      faqs: faqs.map(faq => ({
        q: faq.question,
        a: faq.answer
      })),
      events: calendarEvents.map(event => ({
        title: event.title,
        date: formatDateRange(event.startDate, event.endDate),
        status: getEventStatus(event.startDate, event.endDate)
      })),
      services: services.map(service => ({
        name: service.name,
        bureau: service.bureau,
        email: service.email
      }))
    };

    res.json(response);
  } catch (error) {
    console.error("Error fetching general info:", error);
    res.status(500).json({ message: "Server error" });
  }
};

// ============== FAQ CRUD ==============

/**
 * Get all FAQs
 */
exports.getFaqs = async (req, res) => {
  try {
    const { category, isActive } = req.query;
    let query = {};
    
    if (category) query.category = category;
    if (isActive !== undefined) query.isActive = isActive === "true";

    const faqs = await Faq.find(query).sort({ order: 1 });
    res.json(faqs);
  } catch (error) {
    console.error("Error fetching FAQs:", error);
    res.status(500).json({ message: "Server error" });
  }
};

/**
 * Create a new FAQ
 */
exports.createFaq = async (req, res) => {
  try {
    const { question, answer, category, order } = req.body;

    if (!question || !answer) {
      return res.status(400).json({ message: "Question and answer are required" });
    }

    const faq = await Faq.create({ question, answer, category, order });
    res.status(201).json(faq);
  } catch (error) {
    console.error("Error creating FAQ:", error);
    res.status(500).json({ message: "Server error" });
  }
};

/**
 * Update a FAQ
 */
exports.updateFaq = async (req, res) => {
  try {
    const faq = await Faq.findByIdAndUpdate(req.params.id, req.body, { new: true });
    if (!faq) {
      return res.status(404).json({ message: "FAQ not found" });
    }
    res.json(faq);
  } catch (error) {
    console.error("Error updating FAQ:", error);
    res.status(500).json({ message: "Server error" });
  }
};

/**
 * Delete a FAQ
 */
exports.deleteFaq = async (req, res) => {
  try {
    const faq = await Faq.findByIdAndDelete(req.params.id);
    if (!faq) {
      return res.status(404).json({ message: "FAQ not found" });
    }
    res.json({ message: "FAQ deleted successfully" });
  } catch (error) {
    console.error("Error deleting FAQ:", error);
    res.status(500).json({ message: "Server error" });
  }
};

// ============== SERVICES CRUD ==============

/**
 * Get all services
 */
exports.getServices = async (req, res) => {
  try {
    const services = await Service.find({ isActive: true });
    res.json(services);
  } catch (error) {
    console.error("Error fetching services:", error);
    res.status(500).json({ message: "Server error" });
  }
};

/**
 * Create a new service
 */
exports.createService = async (req, res) => {
  try {
    const { name, bureau, email, phone, hours, description } = req.body;

    if (!name || !bureau || !email) {
      return res.status(400).json({ message: "Name, bureau, and email are required" });
    }

    const service = await Service.create({ name, bureau, email, phone, hours, description });
    res.status(201).json(service);
  } catch (error) {
    console.error("Error creating service:", error);
    res.status(500).json({ message: "Server error" });
  }
};

/**
 * Update a service
 */
exports.updateService = async (req, res) => {
  try {
    const service = await Service.findByIdAndUpdate(req.params.id, req.body, { new: true });
    if (!service) {
      return res.status(404).json({ message: "Service not found" });
    }
    res.json(service);
  } catch (error) {
    console.error("Error updating service:", error);
    res.status(500).json({ message: "Server error" });
  }
};

/**
 * Delete a service
 */
exports.deleteService = async (req, res) => {
  try {
    const service = await Service.findByIdAndDelete(req.params.id);
    if (!service) {
      return res.status(404).json({ message: "Service not found" });
    }
    res.json({ message: "Service deleted successfully" });
  } catch (error) {
    console.error("Error deleting service:", error);
    res.status(500).json({ message: "Server error" });
  }
};

// ============== ACADEMIC CALENDAR CRUD ==============

/**
 * Get academic calendar events
 */
exports.getCalendarEvents = async (req, res) => {
  try {
    const { academicYear, type, status } = req.query;
    let query = { isActive: true };

    if (academicYear) query.academicYear = academicYear;
    if (type) query.type = type;
    if (status) query.status = status;

    const events = await AcademicCalendar.find(query)
      .sort({ startDate: 1 })
      .populate("academicYear", "name");

    res.json(events);
  } catch (error) {
    console.error("Error fetching calendar events:", error);
    res.status(500).json({ message: "Server error" });
  }
};

/**
 * Create a calendar event
 */
exports.createCalendarEvent = async (req, res) => {
  try {
    const { title, startDate, endDate, type, academicYear, description } = req.body;

    if (!title || !startDate || !endDate || !academicYear) {
      return res.status(400).json({ message: "Title, dates, and academic year are required" });
    }

    const event = await AcademicCalendar.create({
      title,
      startDate,
      endDate,
      type,
      academicYear,
      description,
      status: getEventStatus(new Date(startDate), new Date(endDate))
    });

    res.status(201).json(event);
  } catch (error) {
    console.error("Error creating calendar event:", error);
    res.status(500).json({ message: "Server error" });
  }
};

/**
 * Update a calendar event
 */
exports.updateCalendarEvent = async (req, res) => {
  try {
    const event = await AcademicCalendar.findByIdAndUpdate(req.params.id, req.body, { new: true });
    if (!event) {
      return res.status(404).json({ message: "Event not found" });
    }
    res.json(event);
  } catch (error) {
    console.error("Error updating calendar event:", error);
    res.status(500).json({ message: "Server error" });
  }
};

/**
 * Delete a calendar event
 */
exports.deleteCalendarEvent = async (req, res) => {
  try {
    const event = await AcademicCalendar.findByIdAndDelete(req.params.id);
    if (!event) {
      return res.status(404).json({ message: "Event not found" });
    }
    res.json({ message: "Event deleted successfully" });
  } catch (error) {
    console.error("Error deleting calendar event:", error);
    res.status(500).json({ message: "Server error" });
  }
};

// ============== HELPER FUNCTIONS ==============

function formatDateRange(startDate, endDate) {
  const options = { day: "numeric", month: "short", year: "numeric" };
  const start = new Date(startDate).toLocaleDateString("fr-FR", options);
  const end = new Date(endDate).toLocaleDateString("fr-FR", options);
  return `${start} - ${end}`;
}

function getEventStatus(startDate, endDate) {
  const now = new Date();
  const start = new Date(startDate);
  const end = new Date(endDate);

  if (now < start) return "À venir";
  if (now > end) return "Terminé";
  return "En cours";
}
