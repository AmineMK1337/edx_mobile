import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/absence_e_viewmodel.dart';
import '../core/constants/app_colors.dart';

class AbsencesScreen extends StatefulWidget {
  const AbsencesScreen({super.key});

  @override
  State<AbsencesScreen> createState() => _AbsencesScreenState();
}

class _AbsencesScreenState extends State<AbsencesScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AbsenceViewModel>().fetchAbsences();
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<AbsenceViewModel>();

    return Scaffold(
      backgroundColor: AppColors.backgroundMint,
      appBar: AppBar(
        title: const Text("Absences", 
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: AppColors.primaryPink,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: viewModel.isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: () => viewModel.fetchAbsences(),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSummaryHeader(viewModel),
                    const SizedBox(height: 20),
                    if (viewModel.unjustifiedCount > 0)
                      _buildWarningAlert(
                        "Attention!",
                        "Vous avez ${viewModel.unjustifiedCount} absence(s) non justifiée(s). Veuillez les justifier au plus vite.",
                      ),
                    const SizedBox(height: 20),
                    if (viewModel.absencesList.isEmpty)
                      const Center(child: Text("Aucune absence enregistrée. Bravo !"))
                    else
                      ...viewModel.absencesList.map((absence) => _buildModuleCard(
                            title: absence.subject,
                            details: absence.formattedDetails,
                            absenceType: absence.isJustified ? "Justifiée" : "Non Justifiée",
                            color: absence.isJustified ? Colors.green.shade100 : Colors.red.shade100,
                            justified: absence.isJustified,
                          )),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildSummaryHeader(AbsenceViewModel vm) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Récapitulatif", 
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primaryPink)),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem('Total absences', vm.totalAbsences.toString(), Colors.teal),
              _buildStatItem('Non justifiées', vm.unjustifiedCount.toString(), Colors.redAccent),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String title, String count, Color color) {
    return Column(
      children: [
        Text(title, style: const TextStyle(fontSize: 14, color: Colors.grey)),
        const SizedBox(height: 5),
        Text(count, style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: color)),
      ],
    );
  }

  Widget _buildModuleCard({required String title, required String details, required String absenceType, required Color color, required bool justified}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(details, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(20)),
              child: Text(
                absenceType,
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, 
                  color: justified ? Colors.green.shade800 : Colors.red.shade800),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWarningAlert(String title, String message) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.alertRedBg,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.red.shade300),
      ),
      child: Row(
        children: [
          const Icon(Icons.warning, color: Colors.redAccent, size: 24),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.redAccent)),
                Text(message, style: const TextStyle(fontSize: 13, color: Colors.black87)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}