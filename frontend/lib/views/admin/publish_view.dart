import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../viewmodels/admin/publish_viewmodel.dart';
import 'publish_form_view.dart';
import 'verify_view.dart';

class AdminPublishView extends StatelessWidget {
  const AdminPublishView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AdminPublishViewModel(),
      child: const _AdminPublishViewContent(),
    );
  }
}

class _AdminPublishViewContent extends StatelessWidget {
  const _AdminPublishViewContent();

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<AdminPublishViewModel>(context);

    return Scaffold(
      backgroundColor: AppColors.backgroundMint,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            _buildSteps(viewModel),
            Expanded(
              child: viewModel.isLoading
                  ? const Center(child: CircularProgressIndicator(color: AppColors.primaryPink))
                  : _buildCurrentStep(context, viewModel),
            ),
            if (viewModel.currentStep > 0) _buildNavigationButtons(context, viewModel),
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
            'Publier Notes',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87),
          ),
        ],
      ),
    );
  }

  Widget _buildSteps(AdminPublishViewModel viewModel) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          _buildStepIndicator(0, 'Sélectionner', viewModel.currentStep),
          _buildStepConnector(viewModel.currentStep >= 1),
          _buildStepIndicator(1, 'Formulaire', viewModel.currentStep),
          _buildStepConnector(viewModel.currentStep >= 2),
          _buildStepIndicator(2, 'Vérifier', viewModel.currentStep),
        ],
      ),
    );
  }

  Widget _buildStepIndicator(int step, String label, int currentStep) {
    final isActive = currentStep == step;
    final isCompleted = currentStep > step;

    return Expanded(
      child: Column(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: isCompleted
                  ? Colors.green
                  : isActive
                      ? AppColors.primaryPink
                      : Colors.grey[300],
              shape: BoxShape.circle,
            ),
            child: Center(
              child: isCompleted
                  ? const Icon(Icons.check, color: Colors.white, size: 18)
                  : Text(
                      '${step + 1}',
                      style: TextStyle(
                        color: isActive ? Colors.white : Colors.grey[600],
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              color: isActive || isCompleted ? Colors.black87 : Colors.grey[600],
              fontSize: 12,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepConnector(bool isCompleted) {
    return Container(
      height: 2,
      width: 30,
      margin: const EdgeInsets.only(bottom: 24),
      color: isCompleted ? Colors.green : Colors.grey[300],
    );
  }

  Widget _buildCurrentStep(BuildContext context, AdminPublishViewModel viewModel) {
    switch (viewModel.currentStep) {
      case 0:
        return _buildSelectionStep(viewModel);
      case 1:
        return PublishFormView(selectedSessions: viewModel.selectedSessions);
      case 2:
        return VerifyView(selectedSessions: viewModel.selectedSessions);
      default:
        return _buildSelectionStep(viewModel);
    }
  }

  Widget _buildSelectionStep(AdminPublishViewModel viewModel) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Examens disponibles',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Row(
                children: [
                  TextButton(
                    onPressed: viewModel.selectAll,
                    child: const Text('Tout sélectionner'),
                  ),
                  TextButton(
                    onPressed: viewModel.clearSelection,
                    child: const Text('Tout désélectionner'),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            '${viewModel.selectedSessions.length} session(s) sélectionnée(s)',
            style: TextStyle(color: Colors.grey[600]),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: viewModel.examSessions.length,
              itemBuilder: (context, index) {
                final session = viewModel.examSessions[index];
                final isSelected = viewModel.selectedSessions.contains(session);
                
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected ? AppColors.primaryPink : Colors.transparent,
                      width: 2,
                    ),
                  ),
                  child: CheckboxListTile(
                    value: isSelected,
                    onChanged: session.isReady ? (bool? value) {
                      viewModel.toggleSessionSelection(session);
                    } : null,
                    title: Text(
                      session.subject,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: session.isReady ? Colors.black87 : Colors.grey,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${session.type} - ${session.group}'),
                        Text('Prof: ${session.professor}'),
                        Text('Date: ${session.date} • ${session.studentCount} étudiants'),
                      ],
                    ),
                    secondary: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: session.isReady ? Colors.green.withOpacity(0.1) : Colors.grey.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        session.isReady ? 'Prêt' : 'En cours',
                        style: TextStyle(
                          color: session.isReady ? Colors.green : Colors.grey,
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    activeColor: AppColors.primaryPink,
                    enabled: session.isReady,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationButtons(BuildContext context, AdminPublishViewModel viewModel) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Row(
        children: [
          if (viewModel.currentStep > 0)
            Expanded(
              child: OutlinedButton(
                onPressed: viewModel.previousStep,
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Précédent'),
              ),
            ),
          if (viewModel.currentStep > 0) const SizedBox(width: 16),
          Expanded(
            child: ElevatedButton(
              onPressed: viewModel.currentStep == 2
                  ? () => _publishGrades(context, viewModel)
                  : viewModel.selectedSessions.isNotEmpty
                      ? viewModel.nextStep
                      : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryPink,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: Text(
                viewModel.currentStep == 2 ? 'Publier' : 'Suivant',
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _publishGrades(BuildContext context, AdminPublishViewModel viewModel) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Publier les notes'),
        content: Text(
          'Voulez-vous publier les notes pour ${viewModel.selectedSessions.length} session(s) sélectionnée(s) ?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              final success = await viewModel.publishGrades({});
              if (success) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Notes publiées avec succès'),
                    backgroundColor: Colors.green,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryPink),
            child: const Text('Publier', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
