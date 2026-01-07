class ScheduleClass {
  final String id;
  final String title;
  final String subtitle; // ex: "4 groupes"
  final String status;   // "publié", "brouillon"

  ScheduleClass({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.status,
  });

  factory ScheduleClass.fromJson(Map<String, dynamic> json) {
    return ScheduleClass(
      id: json['_id'] ?? json['id'] ?? '',
      title: json['title'] ?? json['name'] ?? '',
      subtitle: json['subtitle'] ?? '',
      status: json['status'] ?? 'brouillon',
    );
  }
}

class ProfessorAvailability {
  final String name;
  final String status;   // "complet", "disponible"
  final int hoursPerWeek;
  final int coursesCount;

  ProfessorAvailability({
    required this.name,
    required this.status,
    required this.hoursPerWeek,
    required this.coursesCount,
  });

  factory ProfessorAvailability.fromJson(Map<String, dynamic> json) {
    return ProfessorAvailability(
      name: json['name'] ?? '',
      status: json['status'] ?? 'disponible',
      hoursPerWeek: json['hoursPerWeek'] ?? 0,
      coursesCount: json['coursesCount'] ?? 0,
    );
  }
}
