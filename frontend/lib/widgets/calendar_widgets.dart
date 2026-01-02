import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';
import '../models/calendar_event_model.dart';
import '../viewmodels/calendar_viewmodel.dart';

// --- WIDGET DE LA GRILLE CALENDRIER (Custom) ---
class MonthCalendarWidget extends StatelessWidget {
  const MonthCalendarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          const Text(
            "Novembre 2025",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
          ),
          const SizedBox(height: 20),
          // En-têtes des jours
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: ["L", "M", "M", "J", "V", "S", "D"]
                .map((day) => SizedBox(
                      width: 35,
                      child: Center(child: Text(day, style: const TextStyle(color: Colors.grey))),
                    ))
                .toList(),
          ),
          const SizedBox(height: 10),
          // Grille des jours (Hardcoded pour le visuel Novembre 2025 selon l'image)
          // Semaine 1
          _buildWeekRow(["", "", "", "", "", "1", "2"]),
          _buildWeekRow(["3", "4", "5", "6", "7", "8", "9"]),
          _buildWeekRow(["10", "11", "12", "13", "14", "15", "16"], selectedDay: "16"),
          _buildWeekRow(["17", "18", "19", "20", "21", "22", "23"], eventDays: ["20", "22"]),
          _buildWeekRow(["24", "25", "26", "27", "28", "29", "30"], eventDays: ["25", "27"]),
        ],
      ),
    );
  }

  Widget _buildWeekRow(List<String> days, {String? selectedDay, List<String>? eventDays}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: days.map((day) {
          if (day.isEmpty) return const SizedBox(width: 35);
          
          bool isSelected = day == selectedDay;
          bool isEvent = eventDays?.contains(day) ?? false;

          return Container(
            width: 35,
            height: 35,
            decoration: BoxDecoration(
              color: isSelected 
                  ? AppColors.calSelectedDayBg 
                  : (isEvent ? AppColors.calEventDayBg : Colors.transparent),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                day,
                style: TextStyle(
                  color: isSelected ? Colors.white : (isEvent ? Colors.blue : Colors.black87),
                  fontWeight: isSelected || isEvent ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

// --- WIDGET CARTE ÉVÉNEMENT ---
class EventCard extends StatelessWidget {
  final CalendarEventModel event;
  final CalendarViewModel viewModel = CalendarViewModel();

  EventCard({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    final style = viewModel.getEventTypeStyle(event.type);

    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icône Calendrier à gauche
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFE0F2F1), // Mint très clair
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.calendar_today, color: Colors.teal),
          ),
          const SizedBox(width: 15),
          
          // Détails
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Titre et Badge
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        event.title,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: style['bg'],
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        style['label'],
                        style: TextStyle(color: style['text'], fontSize: 10, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                
                // Date et Heure
                Row(
                  children: [
                    const Icon(Icons.calendar_month_outlined, size: 14, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(event.formattedDate, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                    const SizedBox(width: 15),
                    const Icon(Icons.access_time, size: 14, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(event.time, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                  ],
                ),
                const SizedBox(height: 8),

                // Classe et Lieu
                Row(
                  children: [
                    if(event.group != "-") ...[
                      const Icon(Icons.school_outlined, size: 14, color: Colors.black87),
                      const SizedBox(width: 4),
                      Text(event.group, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
                      const SizedBox(width: 15),
                    ],
                    const Icon(Icons.location_on, size: 14, color: AppColors.primaryPink),
                    const SizedBox(width: 4),
                    Text(event.location, style: const TextStyle(fontSize: 12, color: Colors.black87)),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}