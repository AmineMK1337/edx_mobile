import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';
import '../models/professor/calendar_event_model.dart';
import '../viewmodels/professor/calendar_viewmodel.dart';

// --- WIDGET DE LA GRILLE CALENDRIER (Dynamic) ---
class MonthCalendarWidget extends StatefulWidget {
  final List<CalendarEventModel> events;
  
  const MonthCalendarWidget({super.key, required this.events});

  @override
  State<MonthCalendarWidget> createState() => _MonthCalendarWidgetState();
}

class _MonthCalendarWidgetState extends State<MonthCalendarWidget> {
  late DateTime _currentMonth;
  late DateTime _selectedDay;
  
  @override
  void initState() {
    super.initState();
    _currentMonth = DateTime.now();
    _selectedDay = DateTime.now();
  }

  void _previousMonth() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month - 1);
    });
  }

  void _nextMonth() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month + 1);
    });
  }

  String _getMonthName(int month) {
    const months = [
      'Janvier', 'Février', 'Mars', 'Avril', 'Mai', 'Juin',
      'Juillet', 'Août', 'Septembre', 'Octobre', 'Novembre', 'Décembre'
    ];
    return months[month - 1];
  }

  @override
  Widget build(BuildContext context) {
    // Get event days for the current month
    final eventDays = widget.events
        .where((e) => e.date.year == _currentMonth.year && e.date.month == _currentMonth.month)
        .map((e) => e.date.day)
        .toSet();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          // Month navigation
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left, color: Colors.teal),
                onPressed: _previousMonth,
              ),
              Text(
                "${_getMonthName(_currentMonth.month)} ${_currentMonth.year}",
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
              IconButton(
                icon: const Icon(Icons.chevron_right, color: Colors.teal),
                onPressed: _nextMonth,
              ),
            ],
          ),
          const SizedBox(height: 15),
          // Day headers
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: ["L", "M", "M", "J", "V", "S", "D"]
                .map((day) => SizedBox(
                      width: 35,
                      child: Center(child: Text(day, style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.w600))),
                    ))
                .toList(),
          ),
          const SizedBox(height: 10),
          // Calendar grid
          _buildCalendarGrid(eventDays),
        ],
      ),
    );
  }

  Widget _buildCalendarGrid(Set<int> eventDays) {
    final firstDayOfMonth = DateTime(_currentMonth.year, _currentMonth.month, 1);
    final lastDayOfMonth = DateTime(_currentMonth.year, _currentMonth.month + 1, 0);
    final daysInMonth = lastDayOfMonth.day;
    
    // Monday = 1, Sunday = 7 in Dart
    int startWeekday = firstDayOfMonth.weekday; // 1 = Monday
    
    List<Widget> rows = [];
    List<String> currentWeek = [];
    
    // Add empty cells for days before the first of the month
    for (int i = 1; i < startWeekday; i++) {
      currentWeek.add("");
    }
    
    // Add all days of the month
    for (int day = 1; day <= daysInMonth; day++) {
      currentWeek.add(day.toString());
      
      if (currentWeek.length == 7) {
        rows.add(_buildWeekRow(currentWeek, eventDays));
        currentWeek = [];
      }
    }
    
    // Add remaining days if the last week is incomplete
    if (currentWeek.isNotEmpty) {
      while (currentWeek.length < 7) {
        currentWeek.add("");
      }
      rows.add(_buildWeekRow(currentWeek, eventDays));
    }
    
    return Column(children: rows);
  }

  Widget _buildWeekRow(List<String> days, Set<int> eventDays) {
    final today = DateTime.now();
    final isCurrentMonth = _currentMonth.year == today.year && _currentMonth.month == today.month;
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: days.map((day) {
          if (day.isEmpty) return const SizedBox(width: 35, height: 35);
          
          final dayNum = int.parse(day);
          final isToday = isCurrentMonth && dayNum == today.day;
          final isSelected = _currentMonth.year == _selectedDay.year && 
                            _currentMonth.month == _selectedDay.month && 
                            dayNum == _selectedDay.day;
          final hasEvent = eventDays.contains(dayNum);

          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedDay = DateTime(_currentMonth.year, _currentMonth.month, dayNum);
              });
            },
            child: Container(
              width: 35,
              height: 35,
              decoration: BoxDecoration(
                color: isSelected 
                    ? AppColors.calSelectedDayBg 
                    : (isToday ? Colors.teal.withOpacity(0.2) : (hasEvent ? AppColors.calEventDayBg : Colors.transparent)),
                borderRadius: BorderRadius.circular(8),
                border: isToday && !isSelected ? Border.all(color: Colors.teal, width: 2) : null,
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Text(
                    day,
                    style: TextStyle(
                      color: isSelected ? Colors.white : (isToday ? Colors.teal : (hasEvent ? Colors.blue : Colors.black87)),
                      fontWeight: isSelected || isToday || hasEvent ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                  if (hasEvent && !isSelected)
                    Positioned(
                      bottom: 2,
                      child: Container(
                        width: 5,
                        height: 5,
                        decoration: const BoxDecoration(
                          color: Colors.redAccent,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                ],
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