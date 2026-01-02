import '../models/course_model.dart';

class CoursesViewModel {
  final List<CourseModel> courses = [
    CourseModel(
      title: "Réseaux informatiques",
      level: "2ème année",
      studentCount: 45,
      hoursPerWeek: "3h/semaine",
      nextDayTime: "Lundi 08:00",
      location: "Salle A205",
    ),
    CourseModel(
      title: "Sécurité des réseaux",
      level: "3ème année",
      studentCount: 38,
      hoursPerWeek: "2h/semaine",
      nextDayTime: "Mardi 14:00",
      location: "Salle B301",
    ),
    CourseModel(
      title: "Administration système",
      level: "2ème année",
      studentCount: 42,
      hoursPerWeek: "2h/semaine",
      nextDayTime: "Jeudi 10:00",
      location: "Salle C102",
    ),
  ];
}