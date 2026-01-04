import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/emploi_e_viewmodel.dart';
import '../models/course_e_model.dart';

class EmploiScreen extends StatefulWidget {
  const EmploiScreen({super.key});

  @override
  State<EmploiScreen> createState() => _EmploiScreenState();
}

class _EmploiScreenState extends State<EmploiScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<EmploiViewModel>().fetchCourses();
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<EmploiViewModel>();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F2FF),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 64, 179, 255),
        elevation: 0,
        title: const Text(
          "Emploi du temps",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: viewModel.isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: () => viewModel.fetchCourses(),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (viewModel.coursesList.isEmpty)
                        const Center(child: Text("Aucun cours disponible.")),

                      ...viewModel.weekDays.map((dayName) {
                        final dailyCourses = viewModel.getCoursesForDay(dayName);

                        if (dailyCourses.isEmpty) return const SizedBox.shrink();

                        return Column(
                          children: [
                            _buildDaySection(dayName, dailyCourses),
                            const SizedBox(height: 20),
                          ],
                        );
                      }),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  Widget _buildDaySection(String day, List<Course> courses) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          day,
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        ...courses.map((course) => _buildCourseCard(course)),
      ],
    );
  }

  Widget _buildCourseCard(Course course) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 2))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(course.time, style: TextStyle(color: Colors.grey[700])),
          const SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  course.subject,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.blue[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  course.type,
                  style: TextStyle(color: Colors.blue[800], fontSize: 12),
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          Text(
            "${course.professor} • ${course.room}",
            style: TextStyle(color: Colors.grey[700]),
          ),
        ],
      ),
    );
  }
}