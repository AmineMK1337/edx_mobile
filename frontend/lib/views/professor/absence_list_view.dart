import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../viewmodels/professor/absence_list_viewmodel.dart';
import '../../models/professor/student_model.dart';

class AbsenceListView extends StatelessWidget {
  final String subject;
  final String sessionType;
  final String className;

  const AbsenceListView({
    super.key,
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
        create: (_) => AbsenceListViewModel(subject, sessionType, className),
        builder: (context, child) {
          return Consumer<AbsenceListViewModel>(
            builder: (context, viewModel, child) {
              if (viewModel.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (viewModel.error != null) {
                return Center(child: Text("Erreur: ${viewModel.error}"));
              }

              if (viewModel.students.isEmpty) {
                return const Center(child: Text("Aucune donnée d'absence pour cette séance"));
              }

              return SingleChildScrollView(
                child: Column(
                  children: [
                    // Summary header
                    Container(
                      color: Colors.white,
                      padding: const EdgeInsets.all(15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildStatusBadge(
                            "Présents",
                            viewModel.students.where((s) => s.status == StudentAttendanceStatus.present).length,
                            Colors.green,
                          ),
                          _buildStatusBadge(
                            "Absents",
                            viewModel.students.where((s) => s.status == StudentAttendanceStatus.absent).length,
                            Colors.red,
                          ),
                          _buildStatusBadge(
                            "Retards",
                            viewModel.students.where((s) => s.status == StudentAttendanceStatus.late).length,
                            Colors.orange,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    
                    // Student list
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(10),
                      itemCount: viewModel.students.length,
                      itemBuilder: (context, index) {
                        final student = viewModel.students[index];
                        final statusColor = _getStatusColor(student.status);
                        final statusText = _getStatusText(student.status);

                        return Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border(
                              left: BorderSide(color: statusColor, width: 4),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 3,
                                offset: const Offset(0, 1),
                              )
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      student.name,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      student.matricule ?? "N/A",
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: AppColors.textGrey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: statusColor.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  statusText,
                                  style: TextStyle(
                                    color: statusColor,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
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

  Color _getStatusColor(StudentAttendanceStatus status) {
    switch (status) {
      case StudentAttendanceStatus.present:
        return Colors.green;
      case StudentAttendanceStatus.absent:
        return Colors.red;
      case StudentAttendanceStatus.late:
        return Colors.orange;
      case StudentAttendanceStatus.justified:
        return Colors.blue;
    }
  }

  String _getStatusText(StudentAttendanceStatus status) {
    switch (status) {
      case StudentAttendanceStatus.present:
        return "Présent";
      case StudentAttendanceStatus.absent:
        return "Absent";
      case StudentAttendanceStatus.late:
        return "Retard";
      case StudentAttendanceStatus.justified:
        return "Justifié";
    }
  }
}
