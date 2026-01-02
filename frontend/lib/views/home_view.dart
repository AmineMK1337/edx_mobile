import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:my_app/core/constants/app_colors.dart';
import 'package:my_app/viewmodels/home_viewmodel.dart';
import 'package:my_app/widgets/custom_card.dart';
import 'package:my_app/views/exams_view.dart';
import 'package:my_app/views/calendar_view.dart';
import 'package:my_app/views/notes_view.dart';
import 'package:my_app/views/messages_view.dart';
import 'package:my_app/views/announcements_view.dart';
import 'absences_view.dart';
import 'courses_view.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundMint,
      body: Consumer<HomeViewModel>(
        builder: (context, viewModel, child) {
          return SingleChildScrollView(
            child: Column(
              children: [
                // 1. Header Section with Stack (Pink Header + Image + Stats Card)
                _buildHeaderSection(context, viewModel),

                const SizedBox(height: 20),

                // 2. Section Title
                const Text(
                  "ESPACE PROFESSEUR",
                  style: TextStyle(
                    color: Colors.teal,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.0,
                  ),
                ),

                const SizedBox(height: 20),

                // 3. Grid Menu
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: viewModel.menuItems.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 15,
                      mainAxisSpacing: 15,
                      childAspectRatio: 0.85,
                    ),
                    itemBuilder: (context, index) {
                      final item = viewModel.menuItems[index];

                      return InkWell(
                        onTap: () {
                          if (item.title == "Examens") {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const ExamsView()),
                            );
                          } else if (item.title == "Calendrier") {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => CalendarView()),
                            );
                          } else if (item.title == "Notes") {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => NotesView()),
                            );
                          } else if (item.title == "Absences") {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => AbsencesView()));
                          } else if (item.title == "Mes Cours") {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => CoursesView()));
                          } else if (item.title == "Messages") {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const MessagesView()));
                          } else if (item.title == "Annonces") {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const AnnouncementsView()));
                          }
                        },
                        child: MenuGridItem(item: item),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeaderSection(BuildContext context, HomeViewModel viewModel) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.topCenter,
      children: [
        // Background Container for Image/Color
        Column(
          children: [
            // Pink Top Bar
            Container(
              padding: const EdgeInsets.only(top: 40, left: 20, right: 20, bottom: 15),
              color: AppColors.primaryPink,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 22,
                        child: Icon(Icons.school, color: AppColors.primaryPink),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            "Dr. BENALI Ahmed",
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          Text(
                            "Professeur",
                            style: TextStyle(color: Colors.white70, fontSize: 12),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    children: const [
                      Text("20:49", style: TextStyle(color: Colors.white, fontSize: 16)),
                      SizedBox(width: 10),
                      Icon(Icons.logout, color: Colors.white),
                    ],
                  )
                ],
              ),
            ),
            // University Image Placeholder
            Container(
              height: 140,
              width: double.infinity,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage('https://images.unsplash.com/photo-1562774053-701939374585?ixlib=rb-1.2.1&auto=format&fit=crop&w=1000&q=80'), 
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 40), // Spacing for the floating card
          ],
        ),
        
        // Floating Stats Card
        Positioned(
          bottom: 0, 
          left: 20, 
          right: 20,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildStatItem(viewModel.stats["Cours"] ?? "0", "Cours", Colors.teal),
                _buildStatItem(viewModel.stats["Étudiants"] ?? "0", "Étudiants", Colors.blue),
                _buildStatItem(viewModel.stats["Examens"] ?? "0", "Examens", Colors.purple),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatItem(String count, String label, Color color) {
    return Column(
      children: [
        Text(
          count,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(color: Colors.grey, fontSize: 12),
        ),
      ],
    );
  }
}
