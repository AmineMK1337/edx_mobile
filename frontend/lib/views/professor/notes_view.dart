import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../models/professor/note_model.dart';
import '../../viewmodels/professor/notes_viewmodel.dart';
import '../../widgets/note_card.dart';

class NotesView extends StatelessWidget {
  NotesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundMint,
      appBar: AppBar(
        backgroundColor: AppColors.primaryPink,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text("Notes", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            Text("Gestion des notes", style: TextStyle(color: Colors.white70, fontSize: 12)),
          ],
        ),
      ),
      body: Consumer<NotesViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (viewModel.error != null) {
            return Center(child: Text("Erreur: ${viewModel.error}"));
          }

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  // 1. Cartes de résumé en haut
                  Row(
                    children: [
                      _buildSummaryCard(viewModel.notes.length.toString(), "Examens", Colors.teal),
                      const SizedBox(width: 15),
                      _buildSummaryCard(
                        viewModel.notes.where((n) => n.status == NoteStatus.publiee).length.toString(),
                        "Publiées",
                        Colors.green,
                      ),
                      const SizedBox(width: 15),
                      _buildSummaryCard(
                        viewModel.notes.where((n) => n.status == NoteStatus.nonPubliee).length.toString(),
                        "En attente",
                        Colors.orange,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // 2. Liste des notes
                  viewModel.notes.isEmpty
                      ? const Center(child: Text("Aucune note"))
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: viewModel.notes.length,
                          itemBuilder: (context, index) {
                            return NoteCard(note: viewModel.notes[index]);
                          },
                        ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSummaryCard(String count, String label, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(
          color: AppColors.cardWhite,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 5, offset: const Offset(0, 2))
          ],
        ),
        child: Column(
          children: [
            Text(count, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: color)),
            const SizedBox(height: 4),
            Text(label, style: const TextStyle(color: AppColors.textGrey, fontSize: 12)),
          ],
        ),
      ),
    );
  }
}
