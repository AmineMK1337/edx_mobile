import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';
import '../models/professor/absence_model.dart';
import '../viewmodels/professor/absences_viewmodel.dart';
import '../views/professor/absence_marking_view.dart';
import '../views/professor/absence_list_view.dart';

class AbsenceCard extends StatelessWidget {
  final AbsenceModel absence;
  final AbsencesViewModel viewModel = AbsencesViewModel();

  AbsenceCard({super.key, required this.absence});

  @override
  Widget build(BuildContext context) {
    final statusProps = viewModel.getStatusProps(absence.status);
    final isSaisie = absence.status == AbsenceStatus.present;

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
          // 1. En-tête (Icône, Matière/Type, Statut)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: statusProps['iconBg'],
                  shape: BoxShape.circle, // L'image montre des cercles ici
                ),
                child: Icon(
                  statusProps['icon'],
                  color: statusProps['iconColor'],
                  size: 20,
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      absence.subject,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "${absence.sessionType} • ${absence.className}",
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
                  style: TextStyle(
                    color: statusProps['textColor'],
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),

          // 2. Détails (Date et Heure)
          Row(
            children: [
              _buildDetailItem(Icons.calendar_today, absence.formattedDate),
              const SizedBox(width: 20),
              _buildDetailItem(Icons.access_time, absence.time),
            ],
          ),

          // 3. Boîte d'alerte (Seulement si "Saisie")
          if (isSaisie && absence.absentCount != null) ...[
            const SizedBox(height: 15),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.alertRedBg,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Absences enregistrées",
                    style: TextStyle(color: Colors.red[800], fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "${absence.absentCount} étudiant(s) absent(s)",
                    style: TextStyle(
                      color: Colors.red[900],
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ],

          const SizedBox(height: 20),
          
          // 4. Boutons d'action conditionnels
          Row(
            children: [
              Expanded(
                child: isSaisie
                    ? _buildOutlinedButton( // Bouton "Modifier" (Vert)
                        text: "Modifier",
                        color: Colors.green,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AbsenceMarkingView(
                                absenceId: '',
                                subject: absence.subject,
                                sessionType: absence.sessionTypeString,
                                className: absence.className,
                              ),
                            ),
                          );
                        },
                      )
                    : _buildSolidButton( // Bouton "Marquer absences" (Vert plein)
                        text: "Marquer absences",
                        color: const Color(0xFF009688), // Vert teal de l'image
                        icon: Icons.calendar_today_outlined, // Icône similaire
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AbsenceMarkingView(
                                absenceId: '',
                                subject: absence.subject,
                                sessionType: absence.sessionTypeString,
                                className: absence.className,
                              ),
                            ),
                          );
                        },
                      ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: isSaisie
                    ? _buildOutlinedButton( // Bouton "Voir liste" (Bleu)
                        text: "Voir liste",
                        color: Colors.blue,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AbsenceListView(
                                subject: absence.subject,
                                sessionType: absence.sessionTypeString,
                                className: absence.className,
                              ),
                            ),
                          );
                        },
                      )
                    : _buildOutlinedButton( // Bouton "Plus tard" (Gris)
                        text: "Plus tard",
                        color: Colors.grey,
                        borderColor: AppColors.buttonGreyBorder,
                        onPressed: () {},
                      ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildDetailItem(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.textGrey),
        const SizedBox(width: 5),
        Text(text, style: const TextStyle(color: AppColors.textGrey, fontSize: 13)),
      ],
    );
  }

  Widget _buildOutlinedButton({
    required String text,
    required Color color,
    Color? borderColor,
    required VoidCallback onPressed,
  }) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor: color,
        side: BorderSide(color: borderColor ?? color),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        padding: const EdgeInsets.symmetric(vertical: 12),
      ),
      child: Text(text),
    );
  }

  Widget _buildSolidButton({
    required String text,
    required Color color,
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        padding: const EdgeInsets.symmetric(vertical: 12),
        elevation: 0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 18),
          const SizedBox(width: 8),
          Text(text, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
