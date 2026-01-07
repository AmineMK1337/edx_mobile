import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class ScheduleDetailsView extends StatelessWidget {
  final String classId;
  
  const ScheduleDetailsView({super.key, required this.classId});

  @override
  Widget build(BuildContext context) {
    // Mock schedule data
    final days = ['Lundi', 'Mardi', 'Mercredi', 'Jeudi', 'Vendredi'];
    final schedule = {
      'Lundi': [
        {'time': '08:00 - 10:00', 'subject': 'Réseaux', 'room': 'A101', 'prof': 'Dr. Ben Salah'},
        {'time': '10:30 - 12:30', 'subject': 'Prog C++', 'room': 'B203', 'prof': 'Dr. Trabelsi'},
      ],
      'Mardi': [
        {'time': '08:00 - 10:00', 'subject': 'Électronique', 'room': 'Labo 1', 'prof': 'Dr. Gharbi'},
        {'time': '14:00 - 16:00', 'subject': 'Maths', 'room': 'A102', 'prof': 'Dr. Sassi'},
      ],
      'Mercredi': [
        {'time': '10:30 - 12:30', 'subject': 'TP Réseaux', 'room': 'Labo Info', 'prof': 'Dr. Ben Salah'},
      ],
      'Jeudi': [
        {'time': '08:00 - 10:00', 'subject': 'Systèmes', 'room': 'A103', 'prof': 'Dr. Feki'},
        {'time': '10:30 - 12:30', 'subject': 'Anglais', 'room': 'C201', 'prof': 'Mme. Smith'},
      ],
      'Vendredi': [
        {'time': '08:00 - 10:00', 'subject': 'Projet', 'room': 'Labo 2', 'prof': 'Dr. Ben Salah'},
      ],
    };

    return Scaffold(
      backgroundColor: AppColors.backgroundMint,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(20),
                itemCount: days.length,
                itemBuilder: (context, index) {
                  final day = days[index];
                  final slots = schedule[day] ?? [];
                  return _buildDayCard(day, slots);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          InkWell(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.arrow_back_ios_new, color: AppColors.primaryPink, size: 20),
            ),
          ),
          const SizedBox(width: 16),
          const Text(
            'Détail emploi du temps',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87),
          ),
        ],
      ),
    );
  }

  Widget _buildDayCard(String day, List<Map<String, String>> slots) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.primaryPink.withOpacity(0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                const Icon(Icons.calendar_today, color: AppColors.primaryPink, size: 20),
                const SizedBox(width: 8),
                Text(
                  day,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: AppColors.primaryPink,
                  ),
                ),
              ],
            ),
          ),
          if (slots.isEmpty)
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text('Pas de cours', style: TextStyle(color: Colors.grey)),
            )
          else
            ...slots.map((slot) => _buildSlotItem(slot)),
        ],
      ),
    );
  }

  Widget _buildSlotItem(Map<String, String> slot) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey[100]!),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.teal.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              slot['time']!,
              style: const TextStyle(
                color: Colors.teal,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  slot['subject']!,
                  style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.meeting_room, size: 14, color: Colors.grey[500]),
                    const SizedBox(width: 4),
                    Text(
                      slot['room']!,
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    ),
                    const SizedBox(width: 12),
                    Icon(Icons.person, size: 14, color: Colors.grey[500]),
                    const SizedBox(width: 4),
                    Text(
                      slot['prof']!,
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
