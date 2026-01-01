const mongoose = require("mongoose");
const bcrypt = require("bcryptjs");
require("dotenv").config();

const User = require("./models/user");
const Note = require("./models/note");
const Schedule = require("./models/schedule");
const Ticket = require("./models/ticket");
const Absence = require("./models/absence");

const connectDB = require("./config/db");

async function seedDB() {
  try {
    await connectDB(process.env.MONGO_URI);
    console.log("Connected to MongoDB");

    // Clear existing data
    await User.deleteMany({});
    await Note.deleteMany({});
    await Schedule.deleteMany({});
    await Ticket.deleteMany({});
    await Absence.deleteMany({});
    console.log("Cleared existing data");

    // Create users
    const hashedPassword = await bcrypt.hash("password123", 10);

    const users = await User.insertMany([
      {
        name: "Ahmed Kaddour",
        email: "ahmed@example.com",
        password: hashedPassword,
        role: "professor",
      },
      {
        name: "Fatima Ben Ali",
        email: "fatima@example.com",
        password: hashedPassword,
        role: "professor",
      },
      {
        name: "Mohamed Saidi",
        email: "mohamed@example.com",
        password: hashedPassword,
        role: "student",
        class: "2A - RT",
      },
      {
        name: "Leila Hadj",
        email: "leila@example.com",
        password: hashedPassword,
        role: "student",
        class: "2A - RT",
      },
      {
        name: "Admin User",
        email: "admin@example.com",
        password: hashedPassword,
        role: "admin",
      },
    ]);
    console.log("Users created:", users.length);

    // Create schedules
    const schedules = await Schedule.insertMany([
      {
        class: "2A - RT",
        day: "Monday",
        startTime: "08:00",
        endTime: "10:00",
        subject: "Réseaux informatiques",
        professor: users[0]._id,
        isRattrapage: false,
      },
      {
        class: "2A - RT",
        day: "Monday",
        startTime: "10:30",
        endTime: "12:30",
        subject: "Sécurité des réseaux",
        professor: users[1]._id,
        isRattrapage: false,
      },
      {
        class: "2A - RT",
        day: "Wednesday",
        startTime: "14:00",
        endTime: "16:00",
        subject: "Administration système",
        professor: users[0]._id,
        isRattrapage: false,
      },
      {
        class: "2A - RT",
        day: "Friday",
        startTime: "09:00",
        endTime: "11:00",
        subject: "Programmation Web",
        professor: users[1]._id,
        isRattrapage: false,
      },
    ]);
    console.log("Schedules created:", schedules.length);

    // Create notes
    const notes = await Note.insertMany([
      {
        student: users[2]._id,
        subject: "Réseaux informatiques",
        value: 16,
        publishedBy: users[0]._id,
      },
      {
        student: users[2]._id,
        subject: "Sécurité des réseaux",
        value: 14,
        publishedBy: users[1]._id,
      },
      {
        student: users[3]._id,
        subject: "Réseaux informatiques",
        value: 18,
        publishedBy: users[0]._id,
      },
      {
        student: users[3]._id,
        subject: "Administration système",
        value: 15,
        publishedBy: users[0]._id,
      },
    ]);
    console.log("Notes created:", notes.length);

    // Create absences
    const absences = await Absence.insertMany([
      {
        student: users[2]._id,
        date: new Date("2025-11-10"),
        subject: "Réseaux informatiques",
        status: "absent",
        takenBy: users[0]._id,
      },
      {
        student: users[3]._id,
        date: new Date("2025-11-15"),
        subject: "Sécurité des réseaux",
        status: "present",
        takenBy: users[1]._id,
      },
    ]);
    console.log("Absences created:", absences.length);

    // Create tickets
    const tickets = await Ticket.insertMany([
      {
        student: users[2]._id,
        subject: "Question sur l'examen",
        message: "Pourquoi la date de l'examen a changé ?",
        status: "answered",
        response: "L'examen a été reporté en raison d'un conflit d'horaire.",
        answeredBy: users[4]._id,
      },
      {
        student: users[3]._id,
        subject: "Problème d'accès aux ressources",
        message: "Je n'arrive pas à accéder aux documents du cours",
        status: "open",
      },
    ]);
    console.log("Tickets created:", tickets.length);

    console.log("\n✅ Database seeded successfully!");
    process.exit(0);
  } catch (err) {
    console.error("Seeding failed:", err);
    process.exit(1);
  }
}

seedDB();
