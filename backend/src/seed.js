const mongoose = require("mongoose");
const bcrypt = require("bcryptjs");
require("dotenv").config();

const User = require("./models/user");
const Note = require("./models/note");
const Schedule = require("./models/schedule");
const Ticket = require("./models/ticket");
const Absence = require("./models/absence");
const Class = require("./models/class");
const Course = require("./models/course");
const Exam = require("./models/exam");
const AcademicYear = require("./models/academic_year");
const Enrollment = require("./models/enrollment");
const Document = require("./models/document");
const Message = require("./models/message");
const Announcement = require("./models/announcement");
const Rattrapage = require("./models/rattrapage");
const Room = require("./models/room");

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
    await Class.deleteMany({});
    await Course.deleteMany({});
    await Exam.deleteMany({});
    await AcademicYear.deleteMany({});
    await Enrollment.deleteMany({});
    await Document.deleteMany({});
    await Message.deleteMany({});
    await Announcement.deleteMany({});
    await Rattrapage.deleteMany({});
    await Room.deleteMany({});
    console.log("Cleared existing data");

    // Create Academic Year
    const academicYear = await AcademicYear.create({
      year: "2025-2026",
      semester: "1",
      startDate: new Date("2025-09-01"),
      endDate: new Date("2026-01-31"),
      isCurrent: true
    });
    console.log("Academic year created");

    // Create Classes
    const classes = await Class.insertMany([
      // INDP1 Classes
      { name: "INDP1A", level: "INDP1", section: "A", academicYear: academicYear._id, studentCount: 30, isActive: true },
      { name: "INDP1B", level: "INDP1", section: "B", academicYear: academicYear._id, studentCount: 28, isActive: true },
      { name: "INDP1C", level: "INDP1", section: "C", academicYear: academicYear._id, studentCount: 32, isActive: true },
      { name: "INDP1D", level: "INDP1", section: "D", academicYear: academicYear._id, studentCount: 29, isActive: true },
      { name: "INDP1E", level: "INDP1", section: "E", academicYear: academicYear._id, studentCount: 31, isActive: true },
      { name: "INDP1F", level: "INDP1", section: "F", academicYear: academicYear._id, studentCount: 27, isActive: true },
      
      // INDP2 Classes  
      { name: "INDP2A", level: "INDP2", section: "A", academicYear: academicYear._id, studentCount: 25, isActive: true },
      { name: "INDP2B", level: "INDP2", section: "B", academicYear: academicYear._id, studentCount: 26, isActive: true },
      { name: "INDP2C", level: "INDP2", section: "C", academicYear: academicYear._id, studentCount: 24, isActive: true },
      { name: "INDP2D", level: "INDP2", section: "D", academicYear: academicYear._id, studentCount: 27, isActive: true },
      { name: "INDP2E", level: "INDP2", section: "E", academicYear: academicYear._id, studentCount: 25, isActive: true },
      { name: "INDP2F", level: "INDP2", section: "F", academicYear: academicYear._id, studentCount: 23, isActive: true },
      
      // INDP3 Classes
      { name: "INDP3A", level: "INDP3", section: "A", academicYear: academicYear._id, studentCount: 22, isActive: true },
      { name: "INDP3B", level: "INDP3", section: "B", academicYear: academicYear._id, studentCount: 24, isActive: true },
      { name: "INDP3C", level: "INDP3", section: "C", academicYear: academicYear._id, studentCount: 21, isActive: true },
      { name: "INDP3D", level: "INDP3", section: "D", academicYear: academicYear._id, studentCount: 23, isActive: true },
      { name: "INDP3E", level: "INDP3", section: "E", academicYear: academicYear._id, studentCount: 20, isActive: true },
      { name: "INDP3F", level: "INDP3", section: "F", academicYear: academicYear._id, studentCount: 22, isActive: true }
    ]);

    console.log("Classes created:", classes.length);

    // Create users - 30 students + professors
    const hashedPassword = await bcrypt.hash("password123", 10);

    const studentNames = [
      "Mohamed Saidi", "Leila Hadj", "Ali Ben Ahmed", "Fatima Zahra", "Hassan Ali",
      "Amina Boulay", "Karim Saoudi", "Noor Al-Rashid", "Rania Djaout", "Youssef Bouazza",
      "Sara Ben Youssef", "Abdelhamid Kadi", "Mariam El-Fassi", "Ismail Belkacem", "Zainab Moussa",
      "Omar El-Hadj", "Hana Berri", "Bilal Osman", "Leila Bennaceur", "Farah Hamra",
      "Jamal Nasri", "Selma Bellal", "Ahmed Oudjedi", "Nawal Bouzidi", "Tariq El-Kadi",
      "Yasmine Tabet", "Mourad El-Berri", "Layla Bennani", "Ramzi Bouhafs", "Samira Oudjani"
    ];

    const students = studentNames.map((name, index) => ({
      name: name,
      email: `student${index + 1}@example.com`,
      password: hashedPassword,
      role: "student",
      class: classes[0]._id, // All in 2A class
      matricule: `MAT${String(index + 1).padStart(5, '0')}`,
      isActive: true
    }));

    const professors = [
      {
        name: "Dr. Ahmed Kaddour",
        email: "ahmed@example.com",
        password: hashedPassword,
        role: "professor",
        isActive: true
      },
      {
        name: "Dr. Fatima Ben Ali",
        email: "fatima@example.com",
        password: hashedPassword,
        role: "professor",
        isActive: true
      },
    ];

    const admin = {
      name: "Admin User",
      email: "admin@example.com",
      password: hashedPassword,
      role: "admin",
      isActive: true
    };

    const allUsers = await User.insertMany([...students, ...professors, admin]);
    console.log("Users created:", allUsers.length);

    // Create Courses
    const courses = await Course.insertMany([
      {
        title: "Réseaux informatiques",
        code: "NET101",
        level: "2",
        class: classes[0]._id,
        studentCount: 30,
        hoursPerWeek: 4,
        nextDayTime: new Date("2026-01-06T08:00:00"),
        location: "Salle A101",
        professor: allUsers[30]._id,
        academicYear: academicYear._id,
        isActive: true
      },
      {
        title: "Sécurité des réseaux",
        code: "SEC201",
        level: "2",
        class: classes[0]._id,
        studentCount: 30,
        hoursPerWeek: 3,
        nextDayTime: new Date("2026-01-06T10:30:00"),
        location: "Salle B203",
        professor: allUsers[31]._id,
        academicYear: academicYear._id,
        isActive: true
      },
      {
        title: "Administration système",
        code: "SYS301",
        level: "2",
        class: classes[0]._id,
        studentCount: 30,
        hoursPerWeek: 3,
        nextDayTime: new Date("2026-01-08T14:00:00"),
        location: "Lab 1",
        professor: allUsers[30]._id,
        academicYear: academicYear._id,
        isActive: true
      },
      {
        title: "Programmation Web",
        code: "WEB401",
        level: "2",
        class: classes[0]._id,
        studentCount: 30,
        hoursPerWeek: 4,
        nextDayTime: new Date("2026-01-10T09:00:00"),
        location: "Lab 2",
        professor: allUsers[31]._id,
        academicYear: academicYear._id,
        isActive: true
      },
    ]);
    console.log("Courses created:", courses.length);

    // Create Enrollments for all students in all courses
    const enrollments = [];
    for (let i = 0; i < 30; i++) {
      for (let j = 0; j < courses.length; j++) {
        enrollments.push({
          student: allUsers[i]._id,
          course: courses[j]._id,
          class: classes[0]._id,
          academicYear: academicYear._id,
          status: "active",
          enrollmentDate: new Date("2025-09-01")
        });
      }
    }
    await Enrollment.insertMany(enrollments);
    console.log("Enrollments created:", enrollments.length);

    // Create schedules
    const schedules = await Schedule.insertMany([
      {
        class: classes[0]._id,
        course: courses[0]._id,
        day: "Monday",
        startTime: "08:00",
        endTime: "10:00",
        professor: allUsers[30]._id,
        location: "Salle A101",
        isRattrapage: false,
        academicYear: academicYear._id
      },
      {
        class: classes[0]._id,
        course: courses[1]._id,
        day: "Monday",
        startTime: "10:30",
        endTime: "12:30",
        professor: allUsers[31]._id,
        location: "Salle B203",
        isRattrapage: false,
        academicYear: academicYear._id
      },
      {
        class: classes[0]._id,
        course: courses[2]._id,
        day: "Wednesday",
        startTime: "14:00",
        endTime: "16:00",
        professor: allUsers[30]._id,
        location: "Lab 1",
        isRattrapage: false,
        academicYear: academicYear._id
      },
      {
        class: classes[0]._id,
        course: courses[3]._id,
        day: "Friday",
        startTime: "09:00",
        endTime: "11:00",
        professor: allUsers[31]._id,
        location: "Lab 2",
        isRattrapage: false,
        academicYear: academicYear._id
      },
    ]);
    console.log("Schedules created:", schedules.length);

    // Create Exams
    const exams = await Exam.insertMany([
      {
        title: "Examen Réseaux informatiques",
        course: courses[0]._id,
        class: classes[0]._id,
        status: "scheduled",
        date: new Date("2026-01-20"),
        startTime: "08:00",
        studentCount: 30,
        duration: 120,
        location: "Amphi A",
        professor: allUsers[30]._id,
        academicYear: academicYear._id
      },
      {
        title: "DS Sécurité des réseaux",
        course: courses[1]._id,
        class: classes[0]._id,
        status: "completed",
        date: new Date("2025-12-15"),
        startTime: "10:00",
        studentCount: 30,
        duration: 90,
        location: "Salle B203",
        professor: allUsers[31]._id,
        academicYear: academicYear._id
      }
    ]);
    console.log("Exams created:", exams.length);

    // Create notes
    const notes = await Note.insertMany([
      {
        student: allUsers[0]._id,
        course: courses[0]._id,
        exam: exams[0]._id,
        type: "DS",
        value: 16,
        coefficient: 1,
        publishedBy: allUsers[30]._id,
        academicYear: academicYear._id,
        isPublished: true
      },
      {
        student: allUsers[0]._id,
        course: courses[1]._id,
        exam: exams[1]._id,
        type: "Exam",
        value: 14,
        coefficient: 2,
        publishedBy: allUsers[31]._id,
        academicYear: academicYear._id,
        isPublished: true
      },
      {
        student: allUsers[1]._id,
        course: courses[0]._id,
        type: "TP",
        value: 18,
        coefficient: 0.5,
        publishedBy: allUsers[30]._id,
        academicYear: academicYear._id,
        isPublished: true
      },
      {
        student: allUsers[1]._id,
        course: courses[2]._id,
        type: "CC",
        value: 15,
        coefficient: 1,
        publishedBy: allUsers[30]._id,
        academicYear: academicYear._id,
        isPublished: true
      },
    ]);
    console.log("Notes created:", notes.length);

    // Create absences - 3 seances with multiple students
    const seance1Date = new Date("2025-12-01T08:00:00");
    const seance2Date = new Date("2025-12-03T10:30:00");
    const seance3Date = new Date("2025-12-05T14:00:00");

    // Seance 1: Réseaux informatiques - 30 students with mixed status
    const seance1Absences = [];
    for (let i = 0; i < 30; i++) {
      const statuses = ["present", "absent", "late"];
      const randomStatus = statuses[Math.floor(Math.random() * statuses.length)];
      
      seance1Absences.push({
        student: allUsers[i]._id,
        course: courses[0]._id,
        class: classes[0]._id,
        sessionType: "course",
        date: seance1Date,
        status: randomStatus,
        takenBy: allUsers[30]._id,
        academicYear: academicYear._id
      });
    }

    // Seance 2: Sécurité des réseaux - 30 students with mixed status
    const seance2Absences = [];
    for (let i = 0; i < 30; i++) {
      const statuses = ["present", "absent", "late"];
      const randomStatus = statuses[Math.floor(Math.random() * statuses.length)];
      
      seance2Absences.push({
        student: allUsers[i]._id,
        course: courses[1]._id,
        class: classes[0]._id,
        sessionType: "course",
        date: seance2Date,
        status: randomStatus,
        takenBy: allUsers[31]._id,
        academicYear: academicYear._id
      });
    }

    // Seance 3: Administration système - 30 students with mixed status
    const seance3Absences = [];
    for (let i = 0; i < 30; i++) {
      const statuses = ["present", "absent", "late"];
      const randomStatus = statuses[Math.floor(Math.random() * statuses.length)];
      
      seance3Absences.push({
        student: allUsers[i]._id,
        course: courses[2]._id,
        class: classes[0]._id,
        sessionType: "course",
        date: seance3Date,
        status: randomStatus,
        takenBy: allUsers[30]._id,
        academicYear: academicYear._id
      });
    }

    const allAbsences = [...seance1Absences, ...seance2Absences, ...seance3Absences];
    const absences = await Absence.insertMany(allAbsences);
    console.log("Absences created:", absences.length);

    // Create tickets
    const tickets = await Ticket.insertMany([
      {
        student: allUsers[0]._id,
        ticketType: "document_request",
        documentType: "attestation_presence",
        subject: "Question sur l'examen",
        message: "Pourquoi la date de l'examen a changé ?",
        status: "approved",
        response: "L'examen a été reporté en raison d'un conflit d'horaire.",
        answeredBy: allUsers[32]._id,
      },
      {
        student: allUsers[1]._id,
        ticketType: "exam_review",
        courseName: "Algorithmes",
        currentMark: 12,
        subject: "Problème d'accès aux ressources",
        message: "Je n'arrive pas à accéder aux documents du cours",
        status: "pending",
      },
    ]);
    console.log("Tickets created:", tickets.length);

    // Create documents for courses - query courses from DB to ensure they exist
    console.log("Fetching courses from database...");
    const existingCourses = await Course.find({}).limit(2);
    console.log("Found courses:", existingCourses.length);
    console.log("Total users:", allUsers.length);
    
    if (existingCourses && existingCourses.length > 0 && allUsers.length > 32) {
      console.log("Creating documents...");
      const documentsData = [
        {
          title: "Chapitre 1 - Introduction",
          description: "Introduction aux bases du cours",
          course: existingCourses[0]._id,
          fileUrl: "/docs/chapter1.pdf",
          fileType: "pdf",
          uploadedBy: allUsers[30]._id, // Professor
          downloads: 15,
          isPublished: true
        },
        {
          title: "TP 1 - Exercices pratiques",
          description: "Exercices à faire avant la prochaine séance",
          course: existingCourses[0]._id,
          fileUrl: "/docs/tp1.pdf",
          fileType: "pdf",
          uploadedBy: allUsers[30]._id,
          downloads: 12,
          isPublished: true
        },
        {
          title: "Slides - Semaine 1",
          description: "Présentations PowerPoint de la semaine",
          course: existingCourses[0]._id,
          fileUrl: "/docs/slides_week1.pptx",
          fileType: "pptx",
          uploadedBy: allUsers[30]._id,
          downloads: 28,
          isPublished: true
        },
      ];
      
      if (existingCourses.length > 1) {
        documentsData.push({
          title: "Résumé - Chapitre 2",
          description: "Résumé du deuxième chapitre",
          course: existingCourses[1]._id,
          fileUrl: "/docs/summary_chapter2.pdf",
          fileType: "pdf",
          uploadedBy: allUsers[31]._id,
          downloads: 8,
          isPublished: true
        });
        documentsData.push({
          title: "Code source - Projet",
          description: "Code de référence pour le projet",
          course: existingCourses[1]._id,
          fileUrl: "/docs/project_source.zip",
          fileType: "other",
          uploadedBy: allUsers[31]._id,
          downloads: 20,
          isPublished: true
        });
      }
      
      console.log("Document data prepared, inserting...");
      const documents = await Document.insertMany(documentsData);
      console.log("Documents created:", documents.length);
    } else {
      console.log("Skipping documents creation: courses=" + existingCourses.length + ", users=" + allUsers.length);
    }

    // Create sample messages between students and professors
    const messages = await Message.insertMany([
      {
        sender: allUsers[0]._id, // student1
        recipient: allUsers[30]._id, // professor
        course: courses[0]._id,
        content: "Bonjour professeur, j'ai une question sur le cours d'aujourd'hui.",
        isRead: true
      },
      {
        sender: allUsers[30]._id, // professor
        recipient: allUsers[0]._id, // student1
        course: courses[0]._id,
        content: "Bonjour! Bien sûr, n'hésite pas à demander.",
        isRead: true
      },
      {
        sender: allUsers[0]._id, // student1
        recipient: allUsers[30]._id, // professor
        content: "Pouvez-vous expliquer le dernier sujet plus en détail?",
        isRead: true
      },
      {
        sender: allUsers[30]._id, // professor
        recipient: allUsers[0]._id, // student1
        content: "Bien sûr! Je t'enverrai les slides détaillés par email.",
        isRead: false
      },
      {
        sender: allUsers[1]._id, // student2
        recipient: allUsers[31]._id, // professor2
        course: courses[1]._id,
        content: "Quand est la date limite pour le devoir?",
        isRead: true
      },
      {
        sender: allUsers[31]._id, // professor2
        recipient: allUsers[1]._id, // student2
        content: "La date limite est le 15 janvier.",
        isRead: true
      },
      {
        sender: allUsers[2]._id, // student3
        recipient: allUsers[30]._id, // professor
        content: "Je suis absent demain. Je peux faire un rattrapage?",
        isRead: false
      }
    ]);
    console.log("Messages created:", messages.length);

    // Create announcements for classes
    const announcements = await Announcement.insertMany([
      {
        title: "Contrôle continu - Semaine prochaine",
        content: "Un contrôle continu aura lieu la semaine prochaine sur les chapitres 1 et 2. Veuillez préparer vos notes.",
        class: classes[0]._id,
        createdBy: allUsers[30]._id, // professor
        priority: "high",
        isPinned: true
      },
      {
        title: "Remise des devoirs",
        content: "N'oubliez pas de remettre vos devoirs avant vendredi à 17h. Les retards ne seront pas acceptés.",
        class: classes[0]._id,
        createdBy: allUsers[30]._id,
        priority: "high",
        isPinned: true
      },
      {
        title: "Réunion de classe - Lundi 6 janvier",
        content: "Une réunion de classe aura lieu lundi prochain à 14h en salle A101. Veuillez confirmer votre présence.",
        class: classes[0]._id,
        createdBy: allUsers[30]._id,
        priority: "medium"
      },
      {
        title: "Nouveau sujet de projet",
        content: "Le sujet du projet final pour ce semestre a été publié. Consultez le lien partagé sur le portail.",
        class: classes[0]._id,
        createdBy: allUsers[31]._id,
        priority: "medium"
      },
      {
        title: "Absence du professeur",
        content: "Je serai en formation toute la journée du jeudi. Le cours sera reporté à une autre date.",
        class: classes[1]._id,
        createdBy: allUsers[31]._id,
        priority: "medium"
      },
      {
        title: "Annonce importante",
        content: "Les résultats des examens de janvier seront publiés le 15 février.",
        class: classes[0]._id,
        createdBy: allUsers[30]._id,
        priority: "low"
      }
    ]);
    console.log("Announcements created:", announcements.length);

    // Create Rooms
    const rooms = await Room.create([
      {
        name: 'Amphi A',
        type: 'Amphithéâtre',
        capacity: 120,
        hasProjector: true,
        hasAirConditioning: true,
        floor: 0,
        building: 'Bâtiment Principal',
        status: 'available',
        equipment: [
          { name: 'Projecteur', quantity: 1, status: 'working' },
          { name: 'Micro', quantity: 2, status: 'working' }
        ],
        createdBy: allUsers[32]._id
      },
      {
        name: 'Amphi B',
        type: 'Amphithéâtre',
        capacity: 150,
        hasProjector: true,
        hasAirConditioning: true,
        floor: 0,
        building: 'Bâtiment Principal',
        status: 'available',
        equipment: [
          { name: 'Projecteur', quantity: 1, status: 'working' },
          { name: 'Micro', quantity: 3, status: 'working' }
        ],
        createdBy: allUsers[32]._id
      },
      {
        name: 'B200',
        type: 'TD',
        capacity: 40,
        hasProjector: true,
        hasAirConditioning: true,
        floor: 2,
        building: 'Bâtiment B',
        status: 'available',
        equipment: [
          { name: 'Projecteur', quantity: 1, status: 'working' },
          { name: 'Tableau', quantity: 1, status: 'working' }
        ],
        createdBy: allUsers[32]._id
      },
      {
        name: 'B300',
        type: 'TD',
        capacity: 35,
        hasProjector: true,
        hasAirConditioning: true,
        floor: 3,
        building: 'Bâtiment B',
        status: 'available',
        equipment: [
          { name: 'Projecteur', quantity: 1, status: 'working' },
          { name: 'Tableau', quantity: 1, status: 'working' }
        ],
        createdBy: allUsers[32]._id
      },
      {
        name: 'A200',
        type: 'TD',
        capacity: 45,
        hasProjector: true,
        hasAirConditioning: true,
        floor: 2,
        building: 'Bâtiment A',
        status: 'available',
        equipment: [
          { name: 'Projecteur', quantity: 1, status: 'working' },
          { name: 'Tableau', quantity: 1, status: 'working' }
        ],
        createdBy: allUsers[32]._id
      },
      {
        name: 'A300',
        type: 'TD',
        capacity: 42,
        hasProjector: true,
        hasAirConditioning: true,
        floor: 3,
        building: 'Bâtiment A',
        status: 'available',
        equipment: [
          { name: 'Projecteur', quantity: 1, status: 'working' },
          { name: 'Tableau', quantity: 1, status: 'working' }
        ],
        createdBy: allUsers[32]._id
      },
      {
        name: 'Lab Info 1',
        type: 'Laboratoire',
        capacity: 30,
        hasProjector: true,
        hasComputers: true,
        hasAirConditioning: true,
        floor: 1,
        building: 'Bâtiment Informatique',
        status: 'available',
        equipment: [
          { name: 'PC', quantity: 30, status: 'working' },
          { name: 'Projecteur', quantity: 1, status: 'working' }
        ],
        createdBy: allUsers[32]._id
      },
      {
        name: 'Salle TD 1',
        type: 'TD',
        capacity: 40,
        hasProjector: false,
        floor: 1,
        building: 'Bâtiment Principal',
        status: 'available',
        createdBy: allUsers[32]._id
      },
      {
        name: 'Salle TD 2',
        type: 'TD',
        capacity: 40,
        hasProjector: true,
        floor: 1,
        building: 'Bâtiment Principal',
        status: 'maintenance',
        createdBy: allUsers[32]._id
      }
    ]);
    console.log("Rooms created:", rooms.length);

    // Create Rattrapage sessions
    const rattrapages = await Rattrapage.create([
      {
        subject: 'Réseaux Informatiques',
        professor: allUsers[30]._id,
        date: new Date('2024-02-15'),
        time: '09:00',
        room: 'Amphi A',
        capacity: 50,
        courseId: courses[0]._id,
        status: 'scheduled',
        description: 'Session de rattrapage pour le partiel de réseaux',
        createdBy: allUsers[32]._id,
        registeredStudents: [
          { student: allUsers[0]._id },
          { student: allUsers[1]._id }
        ]
      },
      {
        subject: 'Bases de Données',
        professor: allUsers[31]._id,
        date: new Date('2024-02-20'),
        time: '14:00',
        room: 'Lab Info 1',
        capacity: 30,
        courseId: courses[1]._id,
        status: 'scheduled',
        description: 'Rattrapage examen final BD',
        createdBy: allUsers[32]._id,
        registeredStudents: Array.from({ length: 25 }, (_, i) => ({
          student: allUsers[i % 30]._id
        }))
      }
    ]);
    console.log("Rattrapages created:", rattrapages.length);

    console.log("\n✅ Database seeded successfully!");
    process.exit(0);
  } catch (err) {
    console.error("Seeding failed:", err);
    process.exit(1);
  }
}

seedDB();
