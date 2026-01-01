import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:my_app/core/constants/app_colors.dart';
import 'package:my_app/viewmodels/exams_viewmodel.dart';
import 'package:my_app/models/exam_model.dart';
import 'package:my_app/widgets/exam_card.dart';

class ExamsView extends StatelessWidget {
  const ExamsView({super.key});

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
            Text("Examens", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            Text("Gestion des examens", style: TextStyle(color: Colors.white70, fontSize: 12)),
          ],
        ),
      ),
      body: Consumer<ExamsViewModel>(
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
                  // 1. Planifier Button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.buttonGreen,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      onPressed: () {},
                      icon: const Icon(Icons.add_circle_outline, color: Colors.white),
                      label: const Text("Planifier un nouvel examen", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // 2. Summary Cards Row
                  Row(
                    children: [
                      _buildSummaryCard(
                        viewModel.exams.where((e) => e.status == ExamStatus.planifie).length.toString(),
                        "À venir",
                      ),
                      const SizedBox(width: 15),
                      _buildSummaryCard(
                        viewModel.exams.where((e) => e.status == ExamStatus.passe).length.toString(),
                        "Passés",
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // 3. Exams List
                  viewModel.exams.isEmpty
                      ? const Center(child: Text("Aucun examen"))
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: viewModel.exams.length,
                          itemBuilder: (context, index) {
                            return ExamCard(exam: viewModel.exams[index]);
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

  Widget _buildSummaryCard(String count, String label) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: AppColors.cardWhite,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
             BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 5, offset: const Offset(0,2))
          ]
        ),
        child: Column(
          children: [
            Text(count, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: label == "À venir" ? Colors.blue : Colors.green)),
            const SizedBox(height: 5),
            Text(label, style: const TextStyle(color: AppColors.textGrey)),
          ],
        ),
      ),
    );
  }
}
