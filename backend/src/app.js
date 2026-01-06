const express = require("express");
const cors = require("cors");
const connectDB = require("./config/db");
require("dotenv").config();

const app = express();
connectDB(process.env.MONGO_URI);

app.use(cors());
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// Routes
app.use("/api/auth", require("./routes/auth.routes"));
app.use("/api/users", require("./routes/users.routes"));
app.use("/api/students", require("./routes/students.routes"));
app.use("/api/notes", require("./routes/notes.routes"));
app.use("/api/schedules", require("./routes/schedules.routes"));
app.use("/api/exams", require("./routes/exams.routes"));
app.use("/api/events", require("./routes/calendar_events.routes"));
app.use("/api/courses", require("./routes/courses.routes"));
app.use("/api/absences", require("./routes/absences.routes"));
app.use("/api/attendance", require("./routes/attendance.routes"));
app.use("/api/classes", require("./routes/classes.routes"));
app.use("/api/academic-years", require("./routes/academic_years.routes"));
app.use("/api/enrollments", require("./routes/enrollments.routes"));
app.use("/api/documents", require("./routes/documents.routes"));
app.use("/api/shared-docs", require("./routes/shared_docs.routes"));
app.use("/api/doc-requests", require("./routes/doc_requests.routes"));
app.use("/api/messages", require("./routes/messages.routes"));
app.use("/api/announcements", require("./routes/announcements.routes"));
app.use("/api/tickets", require("./routes/tickets.routes"));

module.exports = app;
