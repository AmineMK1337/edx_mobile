import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../viewmodels/professor/courses_viewmodel.dart';
import '../../widgets/course_card.dart';

class CoursesView extends StatelessWidget {
  CoursesView({super.key});

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
            Text("Mes Cours", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            Text("Cours enseignés", style: TextStyle(color: Colors.white70, fontSize: 12)),
          ],
        ),
      ),
      body: Consumer<CoursesViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (viewModel.error != null) {
            return Center(child: Text("Erreur: ${viewModel.error}"));
          }

          if (viewModel.courses.isEmpty) {
            return const Center(child: Text("Aucun cours disponible"));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: viewModel.courses.length,
            itemBuilder: (context, index) {
              return CourseCard(course: viewModel.courses[index]);
            },
          );
        },
      ),
    );
  }
}
