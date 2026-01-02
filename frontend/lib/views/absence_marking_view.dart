import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/constants/app_colors.dart';
import '../models/student_model.dart';
import '../viewmodels/absence_marking_viewmodel.dart';

class AbsenceMarkingView extends StatelessWidget {
  final String absenceId;
  final String subject;
  final String sessionType;
  final String className;

  const AbsenceMarkingView({
    super.key,
    required this.absenceId,
    required this.subject,
    required this.sessionType,
    required this.className,
  });

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
          children: [
            Text(subject, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
            Text(
              "$sessionType - $className",
              style: const TextStyle(color: Colors.white70, fontSize: 12),
            ),
          ],
        ),
      ),
      body: ChangeNotifierProvider(
        create: (_) => AbsenceMarkingViewModel(),
        builder: (context, child) {
          return Consumer<AbsenceMarkingViewModel>(
            builder: (context, viewModel, child) {
              if (viewModel.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (viewModel.error != null && viewModel.students.isEmpty) {
                return Center(child: Text("Erreur: ${viewModel.error}"));
              }

              return Column(
                children: [
                  // Header with summary
                  Container(
                    color: Colors.white,
                    padding: const EdgeInsets.all(15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStatusBadge("Présents", 
                          viewModel.students.where((s) => s.status == StudentAttendanceStatus.present).length,
                          Colors.green),
                        _buildStatusBadge("Absents", 
                          viewModel.students.where((s) => s.status == StudentAttendanceStatus.absent).length,
                          Colors.red),
                        _buildStatusBadge("Retards", 
                          viewModel.students.where((s) => s.status == StudentAttendanceStatus.late).length,
                          Colors.orange),
                      ],
                    ),
                  ),
                  
                  // Student list
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(10),
                      itemCount: viewModel.students.length,
                      itemBuilder: (context, index) {
                        final student = viewModel.students[index];
                        return StudentAttendanceCard(
                          student: student,
                          onStatusChanged: (status) {
                            viewModel.updateStudentStatus(index, status);
                          },
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
      bottomNavigationBar: ChangeNotifierProvider(
        create: (_) => AbsenceMarkingViewModel(),
        builder: (context, child) {
          return Consumer<AbsenceMarkingViewModel>(
            builder: (context, viewModel, child) {
              return Padding(
                padding: const EdgeInsets.all(15),
                child: ElevatedButton(
                  onPressed: viewModel.isSubmitting
                      ? null
                      : () async {
                          await viewModel.submitAbsences(subject, sessionType, className);
                          if (context.mounted && viewModel.error == null) {
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Absences enregistrées avec succès")),
                            );
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.buttonGreen,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                  child: viewModel.isSubmitting
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation(Colors.white)),
                        )
                      : const Text(
                          "Enregistrer les absences",
                          style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildStatusBadge(String label, int count, Color color) {
    return Column(
      children: [
        Text(count.toString(), style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color)),
        Text(label, style: const TextStyle(fontSize: 12, color: AppColors.textGrey)),
      ],
    );
  }
}

class StudentAttendanceCard extends StatelessWidget {
  final StudentModel student;
  final Function(StudentAttendanceStatus) onStatusChanged;

  const StudentAttendanceCard({
    super.key,
    required this.student,
    required this.onStatusChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Student info
          Row(
            children: [
              CircleAvatar(
                backgroundColor: AppColors.iconBgBlue,
                child: Text(student.name.isNotEmpty ? student.name[0].toUpperCase() : "?",
                    style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      student.name,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      student.matricule,
                      style: const TextStyle(fontSize: 12, color: AppColors.textGrey),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          
          // Status buttons
          Row(
            children: [
              Expanded(
                child: _buildStatusButton(
                  "Présent",
                  StudentAttendanceStatus.present,
                  Colors.green,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildStatusButton(
                  "Absent",
                  StudentAttendanceStatus.absent,
                  Colors.red,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildStatusButton(
                  "Retard",
                  StudentAttendanceStatus.late,
                  Colors.orange,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusButton(
    String label,
    StudentAttendanceStatus status,
    Color color,
  ) {
    final isSelected = student.status == status;
    return GestureDetector(
      onTap: () => onStatusChanged(status),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? color : color.withOpacity(0.2),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: color,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: isSelected ? Colors.white : color,
              fontSize: 12,
            ),
          ),
        ),
      ),
    );
  }
}
