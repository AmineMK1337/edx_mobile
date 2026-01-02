const mongoose = require("mongoose");
require("dotenv").config();

const AcademicYear = require("./models/academic_year");
const Class = require("./models/class");
const Course = require("./models/course");
const Enrollment = require("./models/enrollment");
const User = require("./models/user");

const connectDB = require("./config/db");

async function testDB() {
  try {
    await connectDB(process.env.MONGO_URI);
    console.log("Connected to MongoDB\n");

    // Test Academic Year
    const academicYears = await AcademicYear.find();
    console.log(`✅ Academic Years: ${academicYears.length}`);
    if (academicYears.length > 0) {
      console.log(`   - ${academicYears[0].year} Semester ${academicYears[0].semester}`);
    }

    // Test Classes
    const classes = await Class.find().populate("academicYear");
    console.log(`\n✅ Classes: ${classes.length}`);
    classes.forEach(c => {
      console.log(`   - ${c.name} (Level ${c.level}, Section ${c.section}) - ${c.studentCount} students`);
    });

    // Test Courses
    const courses = await Course.find()
      .populate("professor", "name")
      .populate("class", "name")
      .populate("academicYear", "year semester");
    console.log(`\n✅ Courses: ${courses.length}`);
    courses.forEach(c => {
      console.log(`   - ${c.title} (${c.code})`);
      console.log(`     Professor: ${c.professor?.name || 'N/A'}`);
      console.log(`     Class: ${c.class?.name || 'N/A'}`);
      console.log(`     Students: ${c.studentCount}`);
    });

    // Test Enrollments
    const enrollments = await Enrollment.find();
    console.log(`\n✅ Enrollments: ${enrollments.length}`);

    // Test Users with class reference
    const students = await User.find({ role: "student" }).populate("class", "name");
    console.log(`\n✅ Students: ${students.length}`);
    if (students.length > 0) {
      console.log(`   - ${students[0].name} (${students[0].matricule})`);
      console.log(`     Class: ${students[0].class?.name || 'N/A'}`);
    }

    console.log("\n🎉 All database relationships working correctly!");
    process.exit(0);
  } catch (err) {
    console.error("Test failed:", err);
    process.exit(1);
  }
}

testDB();
