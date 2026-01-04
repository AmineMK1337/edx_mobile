import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/resultats_e_viewmodel.dart';
import '../core/constants/app_colors.dart';

class ResultatsScreen extends StatefulWidget {
  const ResultatsScreen({super.key});

  @override
  State<ResultatsScreen> createState() => _ResultatsScreenState();
}

class _ResultatsScreenState extends State<ResultatsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ResultatsViewModel>().fetchResults();
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ResultatsViewModel>();

    return Scaffold(
      backgroundColor: AppColors.backgroundMint,
      appBar: AppBar(
        backgroundColor: AppColors.primaryPink,
        elevation: 0,
        title: const Text(
          "Résultats",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: viewModel.isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildGeneralAverageCard(
                    average: viewModel.generalAverage.toStringAsFixed(2),
                    semester: "Semestre 1 - 2024/2025",
                  ),
                  const SizedBox(height: 20),
                  if (viewModel.resultsList.isEmpty)
                    const Center(child: Text("Aucun résultat disponible.")),
                  ...viewModel.resultsList.map((result) => _buildModuleResultCard(
                        title: result.moduleName,
                        cc: result.cc.toString(),
                        exam: result.exam.toString(),
                        moduleAverage: result.average.toStringAsFixed(1),
                        credits: "${result.credits} crédits",
                        status: result.isValidated ? "Validé" : "Rattrapage",
                        statusColor: result.isValidated ? Colors.green : Colors.red,
                      )),
                ],
              ),
            ),
    );
  }

  Widget _buildGeneralAverageCard({required String average, required String semester}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: AppColors.primaryPink,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          Text("Moyenne générale", style: TextStyle(color: Colors.white.withOpacity(0.8))),
          Text(average, style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Colors.white)),
          Text(semester, style: TextStyle(color: Colors.white.withOpacity(0.9))),
        ],
      ),
    );
  }

  Widget _buildModuleResultCard({
    required String title,
    required String cc,
    required String exam,
    required String moduleAverage,
    required String credits,
    required String status,
    required Color statusColor,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white, 
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold))),
                Text(credits, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
              ],
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildMarkDetail("CC", cc, Colors.black87),
                _buildMarkDetail("Examen", exam, Colors.black87),
                _buildMarkDetail("Moyenne", moduleAverage, AppColors.primaryPink),
              ],
            ),
            const SizedBox(height: 15),
            Align(
              alignment: Alignment.centerRight,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(color: statusColor.withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
                child: Text(status, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: statusColor)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMarkDetail(String label, String value, Color valueColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 11, color: Colors.grey[500])),
        Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: valueColor)),
      ],
    );
  }
}