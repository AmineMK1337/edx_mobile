import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../viewmodels/professor/exams_viewmodel.dart';
import '../../models/professor/exam_model.dart';
import '../../widgets/exam_card.dart';

class ExamsView extends StatelessWidget {
  const ExamsView({super.key});

  Future<void> _openExamSheet(BuildContext context, {ExamModel? initialExam}) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (sheetContext) => _ExamFormSheet(initialExam: initialExam),
    );
  }

  Future<void> _openDetailsSheet(BuildContext context, ExamModel exam) async {
    await showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (sheetContext) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                exam.title,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(exam.subject, style: const TextStyle(color: AppColors.textGrey)),
              const SizedBox(height: 12),
              _detailRow(Icons.calendar_today, '${exam.formattedDate} • ${exam.time}'),
              _detailRow(Icons.group_outlined, '${exam.className} • ${exam.studentCount} étudiants'),
              _detailRow(Icons.access_time, '${exam.duration} min'),
              _detailRow(Icons.location_on_outlined, exam.location),
              _detailRow(Icons.info_outline, ExamsViewModel.statusPropsFor(exam.status)['text']),
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => Navigator.of(sheetContext).pop(),
                  child: const Text('Fermer'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _detailRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 16, color: AppColors.textGrey),
          const SizedBox(width: 8),
          Expanded(child: Text(text, style: const TextStyle(color: Colors.black87))),
        ],
      ),
    );
  }

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
                      onPressed: () => _openExamSheet(context),
                      icon: const Icon(Icons.add_circle_outline, color: Colors.white),
                      label: const Text("Planifier un nouvel examen", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // 2. Summary Cards Row
                  Row(
                    children: [
                      _buildSummaryCard(
                        viewModel.exams.where((e) => e.status == ExamStatus.scheduled).length.toString(),
                        "À venir",
                      ),
                      const SizedBox(width: 15),
                      _buildSummaryCard(
                        viewModel.exams.where((e) => e.status == ExamStatus.completed).length.toString(),
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
                            final exam = viewModel.exams[index];
                            return ExamCard(
                              exam: exam,
                              onEdit: () => _openExamSheet(context, initialExam: exam),
                              onDetails: () => _openDetailsSheet(context, exam),
                            );
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

// Bottom sheet with its own lifecycle so controllers are disposed safely.
class _ExamFormSheet extends StatefulWidget {
  const _ExamFormSheet({this.initialExam});

  final ExamModel? initialExam;

  @override
  State<_ExamFormSheet> createState() => _ExamFormSheetState();
}

class _ExamFormSheetState extends State<_ExamFormSheet> {
  final formKey = GlobalKey<FormState>();
  late final TextEditingController titleController;
  late final TextEditingController subjectController;
  late final TextEditingController dateController;
  late final TextEditingController timeController;
  late final TextEditingController classController;
  late final TextEditingController studentController;
  late final TextEditingController durationController;
  late final TextEditingController locationController;
  late ExamStatus selectedStatus;

  @override
  void initState() {
    super.initState();
    final exam = widget.initialExam;

    titleController = TextEditingController(text: exam?.title ?? '');
    subjectController = TextEditingController(text: exam?.subject ?? '');
    dateController = TextEditingController(text: exam?.formattedDate ?? '');
    timeController = TextEditingController(text: exam?.time ?? '');
    classController = TextEditingController(text: exam?.className ?? '');
    studentController = TextEditingController(text: exam?.studentCount != null ? exam!.studentCount.toString() : '');
    durationController = TextEditingController(text: exam?.duration != null ? exam!.duration.toString() : '');
    locationController = TextEditingController(text: exam?.location ?? '');
    selectedStatus = exam?.status ?? ExamStatus.scheduled;
  }

  @override
  void dispose() {
    titleController.dispose();
    subjectController.dispose();
    dateController.dispose();
    timeController.dispose();
    classController.dispose();
    studentController.dispose();
    durationController.dispose();
    locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ExamsViewModel>();
    final isEdit = widget.initialExam != null;

    Future<void> submit() async {
      if (!formKey.currentState!.validate()) return;

      final newExam = ExamModel(
        id: widget.initialExam?.id,
        title: titleController.text.trim(),
        courseId: null, // This should come from a course selector
        classId: null, // This should come from a class selector
        status: selectedStatus,
        date: DateTime.tryParse(dateController.text.trim()) ?? DateTime.now(),
        startTime: timeController.text.trim(),
        studentCount: int.tryParse(studentController.text.trim()) ?? 0,
        duration: int.tryParse(durationController.text.trim()) ?? 0,
        location: locationController.text.trim(),
      );

      try {
        if (isEdit) {
          await viewModel.updateExam(newExam);
        } else {
          await viewModel.addExam(newExam);
        }
        final navigator = Navigator.of(context);
        if (!navigator.mounted) return;

        navigator.pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(isEdit ? 'Examen mis à jour' : 'Examen ajouté avec succès')),
        );
      } catch (e) {
        final navigator = Navigator.of(context);
        if (!navigator.mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(isEdit ? "Impossible de mettre à jour l'examen: $e" : "Impossible d'ajouter l'examen: $e")),
        );
      }
    }

    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isEdit ? 'Modifier l\'examen' : 'Planifier un nouvel examen',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Titre'),
                validator: (value) => (value == null || value.trim().isEmpty) ? 'Titre requis' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: subjectController,
                decoration: const InputDecoration(labelText: 'Matière'),
                validator: (value) => (value == null || value.trim().isEmpty) ? 'Matière requise' : null,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<ExamStatus>(
                decoration: const InputDecoration(labelText: 'Statut'),
                value: selectedStatus,
                items: const [
                  DropdownMenuItem(value: ExamStatus.scheduled, child: Text('Planifié')),
                  DropdownMenuItem(value: ExamStatus.completed, child: Text('Passé')),
                  DropdownMenuItem(value: ExamStatus.cancelled, child: Text('Annulé')),
                ],
                onChanged: (value) {
                  if (value == null) return;
                  setState(() => selectedStatus = value);
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: dateController,
                decoration: const InputDecoration(labelText: 'Date (ex: 2026-01-15)'),
                validator: (value) => (value == null || value.trim().isEmpty) ? 'Date requise' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: timeController,
                decoration: const InputDecoration(labelText: 'Heure (ex: 09:00)'),
                validator: (value) => (value == null || value.trim().isEmpty) ? 'Heure requise' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: classController,
                decoration: const InputDecoration(labelText: 'Classe'),
                validator: (value) => (value == null || value.trim().isEmpty) ? 'Classe requise' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: studentController,
                decoration: const InputDecoration(labelText: "Nombre d'étudiants"),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) return 'Nombre requis';
                  return int.tryParse(value.trim()) == null ? 'Veuillez entrer un nombre' : null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: durationController,
                decoration: const InputDecoration(labelText: 'Durée (ex: 2h)'),
                validator: (value) => (value == null || value.trim().isEmpty) ? 'Durée requise' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: locationController,
                decoration: const InputDecoration(labelText: 'Lieu'),
                validator: (value) => (value == null || value.trim().isEmpty) ? 'Lieu requis' : null,
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.buttonGreen,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: viewModel.isSubmitting ? null : submit,
                  child: viewModel.isSubmitting
                      ? const SizedBox(
                          height: 18,
                          width: 18,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                        )
                      : const Text(
                          'Enregistrer',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
