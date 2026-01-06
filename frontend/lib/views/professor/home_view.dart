import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../viewmodels/professor/home_viewmodel.dart';
import '../../viewmodels/student/document_e_viewmodel.dart';
import '../../widgets/custom_card.dart';
import '../../services/api_service.dart';
import 'exams_view.dart';
import 'calendar_view.dart';
import 'notes_view.dart';
import 'messages_view.dart';
import 'announcements_view.dart';
import 'documents_prof_view.dart';
import 'absences_view.dart';
import 'courses_view.dart';
import '../common/login_view.dart';
import '../common/settings_view.dart';
import '../common/about_view.dart';

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
                          } else if (item.title == "Documents") {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ChangeNotifierProvider(
                                  create: (_) => DocumentViewModel(),
                                  child: const DocumentsProfView(),
                                ),
                              ),
                            );
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
              color: const Color.fromARGB(200, 127, 142, 230),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      PopupMenuButton<String>(
                        offset: const Offset(0, 50),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        onSelected: (value) {
                          switch (value) {
                            case 'settings':
                              Navigator.push(context, MaterialPageRoute(builder: (context) => const SettingsView()));
                              break;
                            case 'about':
                              Navigator.push(context, MaterialPageRoute(builder: (context) => const AboutView()));
                              break;
                          }
                        },
                        itemBuilder: (context) => [
                          const PopupMenuItem(
                            value: 'settings',
                            child: Row(
                              children: [
                                Icon(Icons.settings, color: Colors.blueGrey),
                                SizedBox(width: 12),
                                Text('Paramètres'),
                              ],
                            ),
                          ),
                          const PopupMenuItem(
                            value: 'about',
                            child: Row(
                              children: [
                                Icon(Icons.info_outline, color: Colors.blueGrey),
                                SizedBox(width: 12),
                                Text("À propos"),
                              ],
                            ),
                          ),
                        ],
                        child: const CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: 22,
                          child: Icon(Icons.school, color: Color.fromARGB(199, 45, 66, 187)),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            viewModel.userName,
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          Text(
                            viewModel.userRole == 'professor' ? 'Professeur' : viewModel.userRole == 'admin' ? 'Administrateur' : viewModel.userRole,
                            style: const TextStyle(color: Colors.white70, fontSize: 12),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(_getCurrentTime(), style: const TextStyle(color: Colors.white, fontSize: 16)),
                      const SizedBox(width: 10),
                      IconButton(
                        icon: const Icon(Icons.logout, color: Colors.white),
                        onPressed: () => _showLogoutDialog(context),
                        tooltip: 'Déconnexion',
                      ),
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
                  image: AssetImage("assets/supcom.png"), 
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

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.logout, color: Colors.redAccent),
            SizedBox(width: 10),
            Text('Déconnexion'),
          ],
        ),
        content: const Text('Êtes-vous sûr de vouloir vous déconnecter ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Annuler', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () {
              Navigator.pop(ctx);
              ApiService.logout();
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const LoginView()),
                (route) => false,
              );
            },
            child: const Text('Déconnecter', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  String _getCurrentTime() {
    final now = DateTime.now();
    return '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
  }
}
