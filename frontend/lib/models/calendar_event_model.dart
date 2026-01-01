enum EventType { examen, reunion, tp, personnel }

class CalendarEventModel {
  final String title;
  final EventType type;
  final String date;
  final String time;
  final String location;
  final String group; // "2A - RT", "Tous", etc.

  CalendarEventModel({
    required this.title,
    required this.type,
    required this.date,
    required this.time,
    required this.location,
    required this.group,
  });
}