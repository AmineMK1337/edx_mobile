import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';
import '../models/course_model.dart';

class CourseCard extends StatelessWidget {
  final CourseModel course;

  const CourseCard({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. En-tête (Icône + Titre + Niveau)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFE0F2F1), // Vert très clair (Teal 50)
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.menu_book_rounded, color: Colors.teal, size: 24),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      course.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      course.level ?? 'N/A',
                      style: const TextStyle(color: Colors.grey, fontSize: 13),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // 2. Statistiques (Étudiants & Heures)
          Row(
            children: [
              Expanded(
                child: _buildStatBox(
                  icon: Icons.people_outline,
                  label: "Étudiants",
                  value: course.studentCount.toString(),
                  bgColor: const Color(0xFFE3F2FD), // Bleu très clair
                  iconColor: Colors.blue,
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: _buildStatBox(
                  icon: Icons.access_time,
                  label: "Heures",
                  value: '${course.hoursPerWeek}h',
                  bgColor: const Color(0xFFF3E5F5), // Violet très clair
                  iconColor: Colors.purple,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // 3. Prochain cours info
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Prochain cours",
                    style: TextStyle(color: Colors.grey, fontSize: 11),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        course.nextDayTime != null ? '${course.nextDayTime!.day}/${course.nextDayTime!.month} ${course.nextDayTime!.hour}:${course.nextDayTime!.minute.toString().padLeft(2, '0')}' : 'N/A',
                        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                      ),
                      const Text(" • ", style: TextStyle(color: Colors.grey)),
                      Text(
                        course.location ?? 'N/A',
                        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                      ),
                    ],
                  ),
                ],
              ),
              TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: Size.zero),
                child: Row(
                  children: const [
                    Text("Détails", style: TextStyle(color: Colors.teal, fontSize: 13)),
                    Icon(Icons.arrow_forward, size: 14, color: Colors.teal),
                  ],
                ),
              )
            ],
          ),
          const SizedBox(height: 15),

          // 4. Boutons d'action (Voir planning / Documents)
          Row(
            children: [
              Expanded(
                child: _buildActionButton(
                  text: "Voir planning",
                  bgColor: const Color(0xFFE8F5E9), // Vert fond
                  textColor: Colors.teal, // Vert texte
                  onPressed: () {},
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: _buildActionButton(
                  text: "Documents",
                  bgColor: const Color(0xFFE3F2FD), // Bleu fond
                  textColor: Colors.blue, // Bleu texte
                  onPressed: () {},
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildStatBox({
    required IconData icon,
    required String label,
    required String value,
    required Color bgColor,
    required Color iconColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: iconColor),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(color: iconColor, fontSize: 12, fontWeight: FontWeight.w500),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              color: iconColor, // On utilise la couleur principale pour le texte aussi
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required String text,
    required Color bgColor,
    required Color textColor,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      height: 40,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: bgColor,
          foregroundColor: textColor,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          padding: EdgeInsets.zero,
        ),
        child: Text(text, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
      ),
    );
  }
}