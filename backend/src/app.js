const express = require("express");
const cors = require("cors");
const connectDB = require("./config/db");
require("dotenv").config();

const app = express();
connectDB(process.env.MONGO_URI);

app.use(cors());
app.use(express.json());

// Routes
app.use("/api/auth", require("./routes/auth.routes"));
app.use("/api/users", require("./routes/users.routes"));
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

module.exports = app;
