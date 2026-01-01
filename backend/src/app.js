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
app.use("/api/notes", require("./routes/notes.routes"));
app.use("/api/schedules", require("./routes/schedules.routes"));
app.use("/api/exams", require("./routes/exams.routes"));
app.use("/api/events", require("./routes/calendar_events.routes"));

module.exports = app;
