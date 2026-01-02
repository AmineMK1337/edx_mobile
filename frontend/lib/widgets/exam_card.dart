import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';
import '../models/exam_model.dart';
import '../viewmodels/exams_viewmodel.dart';

class ExamCard extends StatelessWidget {
  final ExamModel exam;
  final VoidCallback onEdit;
  final VoidCallback onDetails;

  ExamCard({super.key, required this.exam, required this.onEdit, required this.onDetails});

  @override
  Widget build(BuildContext context) {
    final statusProps = ExamsViewModel.statusPropsFor(exam.status);
    final isPlanifie = exam.status == ExamStatus.scheduled;

    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: AppColors.cardWhite,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // 1. Header (Icon, Title, Status)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: isPlanifie ? AppColors.iconBgYellow : AppColors.iconBgGreen,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.edit_note,
                  color: isPlanifie ? Colors.amber[800] : Colors.green,
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      exam.title,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      exam.subject,
                      style: const TextStyle(color: AppColors.textGrey, fontSize: 13),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: statusProps['bg'],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  statusProps['text'],
                  style: TextStyle(color: statusProps['textColor'], fontSize: 12, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // 2. Info Blocks (Date & Class)
          Row(
            children: [
              _buildInfoBlock(
                Icons.calendar_today,
                "Date",
                "${exam.formattedDate}\n${exam.time}",
                AppColors.infoPurpleBg,
                Colors.purple,
              ),
              const SizedBox(width: 15),
              _buildInfoBlock(
                Icons.group_outlined,
                "Classe",
                "${exam.className}\n${exam.studentCount} étudiants",
                AppColors.infoBlueBg,
                Colors.blue,
              ),
            ],
          ),
          const SizedBox(height: 15),

          // 3. Duration and Location Footer
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.access_time, size: 18, color: AppColors.textGrey),
                  const SizedBox(width: 5),
                  Text('${exam.duration} min', style: const TextStyle(color: AppColors.textGrey)),
                ],
              ),
              Row(
                children: [
                  const Icon(Icons.location_on_outlined, size: 18, color: Colors.redAccent),
                  const SizedBox(width: 5),
                  Text(exam.location, style: const TextStyle(color: AppColors.textGrey)),
                ],
              ),
            ],
          ),

          // 4. Action Buttons (Only if Planifié)
          if (isPlanifie) ...[
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: onEdit,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.green,
                      side: const BorderSide(color: Colors.green),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: const Text("Modifier"),
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: OutlinedButton(
                    onPressed: onDetails,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.blue,
                      side: const BorderSide(color: Colors.blue),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: const Text("Détails"),
                  ),
                ),
              ],
            )
          ]
        ],
      ),
    );
  }

  Widget _buildInfoBlock(IconData icon, String label, String value, Color bgColor, Color iconColor) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
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
                const SizedBox(width: 8),
                Text(label, style: TextStyle(color: iconColor, fontWeight: FontWeight.w600)),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(fontSize: 13, height: 1.3, color: Colors.black87),
            ),
          ],
        ),
      ),
    );
  }
}