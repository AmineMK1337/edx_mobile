enum EventType { exam, meeting, tp, td, course, personal, holiday }

class CalendarEventModel {
  final String? id;
  final String title;
  final EventType type;
  final DateTime date;
  final String startTime;
  final String? endTime;
  final String location;
  final String? classId;
  final String? courseId;
  final String? description;
  final String? createdById;
  final String? academicYearId;

  // Populated fields
  final Map<String, dynamic>? classDetails;
  final Map<String, dynamic>? course;
  final Map<String, dynamic>? createdBy;
  final Map<String, dynamic>? academicYear;

  CalendarEventModel({
    this.id,
    required this.title,
    required this.type,
    required this.date,
    required this.startTime,
    this.endTime,
    required this.location,
    this.classId,
    this.courseId,
    this.description,
    this.createdById,
    this.academicYearId,
    this.classDetails,
    this.course,
    this.createdBy,
    this.academicYear,
  });

  factory CalendarEventModel.fromJson(Map<String, dynamic> json) {
    return CalendarEventModel(
      id: json['_id'],
      title: json['title'] ?? '',
      type: _parseType(json['type']),
      date: DateTime.parse(json['date']),
      startTime: json['startTime'] ?? json['time'] ?? '',
      endTime: json['endTime'],
      location: json['location'] ?? '',
      classId: json['class'] is String ? json['class'] : json['class']?['_id'],
      courseId: json['course'] is String ? json['course'] : json['course']?['_id'],
      description: json['description'],
      createdById: json['createdBy'] is String ? json['createdBy'] : json['createdBy']?['_id'],
      academicYearId: json['academicYear'] is String ? json['academicYear'] : json['academicYear']?['_id'],
      classDetails: json['class'] is Map ? json['class'] : null,
      course: json['course'] is Map ? json['course'] : null,
      createdBy: json['createdBy'] is Map ? json['createdBy'] : null,
      academicYear: json['academicYear'] is Map ? json['academicYear'] : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) '_id': id,
      'title': title,
      'type': _typeToString(type),
      'date': date.toIso8601String(),
      'startTime': startTime,
      if (endTime != null) 'endTime': endTime,
      'location': location,
      if (classId != null) 'class': classId,
      if (courseId != null) 'course': courseId,
      if (description != null) 'description': description,
      if (createdById != null) 'createdBy': createdById,
      if (academicYearId != null) 'academicYear': academicYearId,
    };
  }

  static EventType _parseType(dynamic value) {
    switch (value?.toString().toLowerCase()) {
      case 'exam':
      case 'examen':
        return EventType.exam;
      case 'meeting':
      case 'reunion':
        return EventType.meeting;
      case 'tp':
        return EventType.tp;
      case 'td':
        return EventType.td;
      case 'course':
        return EventType.course;
      case 'holiday':
        return EventType.holiday;
      default:
        return EventType.personal;
    }
  }

  static String _typeToString(EventType type) {
    switch (type) {
      case EventType.exam:
        return 'exam';
      case EventType.meeting:
        return 'meeting';
      case EventType.tp:
        return 'tp';
      case EventType.td:
        return 'td';
      case EventType.course:
        return 'course';
      case EventType.holiday:
        return 'holiday';
      default:
        return 'personal';
    }
  }

  String get className => classDetails?['name'] ?? classId ?? 'Tous';
  String get courseName => course?['title'] ?? '';
  String get formattedDate => '${date.day}/${date.month}/${date.year}';
  
  // Backward compatibility properties for UI
  String get time => startTime;
  String get group => className;
}