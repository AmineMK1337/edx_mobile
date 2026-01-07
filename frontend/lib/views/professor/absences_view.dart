import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../viewmodels/professor/absences_viewmodel.dart';
import '../../widgets/absence_card.dart';

class AbsencesView extends StatelessWidget {
  AbsencesView({super.key});

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
            Text("Absences", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            Text("Gestion des absences", style: TextStyle(color: Colors.white70, fontSize: 12)),
          ],
        ),
      ),
      body: Consumer<AbsencesViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (viewModel.error != null) {
            return Center(child: Text("Erreur: ${viewModel.error}"));
          }

          final saisieCount = viewModel.absences.where((a) => a.status.toString().contains('saisie')).length;
          final aSaisirCount = viewModel.absences.where((a) => a.status.toString().contains('aSaisir')).length;

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  // 1. Cartes de résumé en haut
                  Row(
                    children: [
                      _buildSummaryCard(viewModel.absences.length.toString(), "Séances", Colors.teal),
                      const SizedBox(width: 15),
                      _buildSummaryCard(saisieCount.toString(), "Saisies", Colors.green),
                      const SizedBox(width: 15),
                      _buildSummaryCard(aSaisirCount.toString(), "En attente", Colors.redAccent),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // 2. Liste des absences
                  if (viewModel.absences.isEmpty)
                    const Center(child: Text("Aucune absence disponible"))
                  else
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: viewModel.absences.length,
                      itemBuilder: (context, index) {
                        return AbsenceCard(absence: viewModel.absences[index]);
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
