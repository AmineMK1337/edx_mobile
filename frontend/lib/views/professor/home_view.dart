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
import '../common/role_home_layout.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeViewModel>(
      builder: (context, viewModel, child) {
        final statsList = <RoleStat>[
          RoleStat(
              label: 'Cours',
              count: viewModel.stats["Cours"] ?? "0",
              color: Colors.teal),
          RoleStat(
              label: 'Étudiants',
              count: viewModel.stats["Étudiants"] ?? "0",
              color: Colors.blue),
          RoleStat(
              label: 'Examens',
              count: viewModel.stats["Examens"] ?? "0",
              color: Colors.purple),
        ];

        final grid = GridView.builder(
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
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => AbsencesView()));
                } else if (item.title == "Mes Cours") {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => CoursesView()));
                } else if (item.title == "Messages") {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const MessagesView()));
                } else if (item.title == "Annonces") {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AnnouncementsView()));
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
        );

        return RoleHomeLayout(
          titleText: 'ESPACE PROFESSEUR',
          userName: viewModel.userName,
          userRoleDisplay: viewModel.userRole == 'professor'
              ? 'Professeur'
              : viewModel.userRole == 'admin'
                  ? 'Administrateur'
                  : viewModel.userRole,
          stats: statsList,
          menuGrid: grid,
          onLogout: () => _showLogoutDialog(context),
        );
      },
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
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () {
              Navigator.pop(ctx);
              ApiService.logout();
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const LoginView()),
                (route) => false,
              );
            },
            child: const Text('Déconnecter',
                style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
