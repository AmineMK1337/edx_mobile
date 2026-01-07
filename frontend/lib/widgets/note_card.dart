import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/constants/app_colors.dart';
import '../models/professor/note_model.dart';
import '../viewmodels/professor/notes_viewmodel.dart';

class NoteCard extends StatelessWidget {
  final NoteModel note;

  NoteCard({super.key, required this.note});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<NotesViewModel>();
    final statusProps = viewModel.getStatusProps(note.isPublished);
    final isPubliee = note.isPublished;

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
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.assignment_turned_in_outlined,
                  color: statusProps['iconColor'],
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      note.subject,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      note.type,
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

          // 2. Détails (Date et Classe)
          Row(
            children: [
              _buildDetailItem(Icons.calendar_today, note.date),
              const SizedBox(width: 20),
              _buildDetailItem(Icons.school_outlined, note.className),
            ],
          ),

          // 3. Boîte de Moyenne (Seulement si "Publiée")
          if (isPubliee && note.classAverage != null) ...[
            const SizedBox(height: 15),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.gradeBoxBg,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Moyenne de classe",
                    style: TextStyle(color: Colors.blue[800], fontSize: 12),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "${note.classAverage}/20",
                    style: TextStyle(
                      color: Colors.blue[900],
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],

          const SizedBox(height: 20),
          
          // 4. Boutons d'action
          Row(
            children: [
              Expanded(
                child: isPubliee
                    ? _buildOutlinedButton(
                        text: "Modifier",
                        color: Colors.green,
                        icon: Icons.edit_outlined,
                        onPressed: () {},
                      )
                    : _buildSolidButton(
                        text: "Saisir notes",
                        color: Colors.green,
                        icon: Icons.upload_file,
                        onPressed: () {},
                      ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: isPubliee
                    ? _buildOutlinedButton(
                        text: "Voir détails",
                        color: Colors.blue,
                        onPressed: () {},
                      )
                    : _buildOutlinedButton(
                        text: "Annuler",
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
    IconData? icon,
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null) ...[Icon(icon, size: 18), const SizedBox(width: 8)],
          Text(text),
        ],
      ),
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
