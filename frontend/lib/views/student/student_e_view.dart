import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

// Import du ViewModel
import '../../viewmodels/student/student_e_viewmodel.dart';
import '../../core/constants/app_colors.dart';
import '../../services/api_service.dart';

// Imports des vues
import '../common/login_view.dart';
import 'emploi_e_view.dart';
import 'group_e_view.dart';
import 'messages_e_view.dart';
import 'partage_e_view.dart';
import 'absences_e_view.dart';
import 'info_e_view.dart';
import 'resultats_e_view.dart';
import 'documents_e_view.dart'; 
import 'profile_e_view.dart';
import 'tickets_e_view.dart';
import '../common/settings_view.dart';
import '../common/about_view.dart';

class StudentHome extends StatefulWidget {
  const StudentHome({super.key});

  @override
  State<StudentHome> createState() => _StudentHomeState();
}

class _StudentHomeState extends State<StudentHome> {
  @override
  void initState() {
    super.initState();
    // Récupération des données via le ViewModel
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<StudentViewModel>().fetchStudent();
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<StudentViewModel>();
    final student = viewModel.student;

    return Scaffold(
      backgroundColor: AppColors.backgroundMint,
      appBar: AppBar(
        backgroundColor: AppColors.primaryPink,
        elevation: 0,
        title: Row(
          children: [
            // --- PHOTO DE PROFIL INTERACTIVE AVEC MENU POPUP ---
            PopupMenuButton<String>(
              offset: const Offset(0, 50),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              onSelected: (value) {
                switch (value) {
                  case 'profile':
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfileView()));
                    break;
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
                  value: 'profile',
                  child: Row(
                    children: [
                      Icon(Icons.person, color: Colors.blueGrey),
                      SizedBox(width: 12),
                      Text('Mon Profil'),
                    ],
                  ),
                ),
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
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white.withOpacity(0.3), width: 1),
                ),
                child: CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.white,
                  backgroundImage: (student?.photoUrl != null)
                      ? NetworkImage(student!.photoUrl!)
                      : const AssetImage('assets/user.jpg') as ImageProvider,
                ),
              ),
            ),
            const SizedBox(width: 12),
            
            // --- NOM ET PRÉNOM ---
            viewModel.isLoading
                ? const Text("Chargement...", style: TextStyle(color: Colors.white, fontSize: 12))
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${student?.firstName ?? ''} ${student?.lastName ?? ''}",
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      if (student?.studentClass != null)
                        Text(
                          student!.studentClass!,
                          style: const TextStyle(fontSize: 10, color: Colors.white70),
                        ),
                    ],
                  ),
            
            const Spacer(),
            IconButton(
              icon: const Icon(Icons.logout, size: 20, color: Colors.white),
              onPressed: () {
                _showLogoutDialog(context);
              },
            ),
          ],
        ),
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [
            // Banner Supcom
            Container(
              height: 160,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/supcom.png"),
                  fit: BoxFit.cover,
                ),
              ),
            ),

            const SizedBox(height: 15),
            const Text(
              "ESPACE ÉTUDIANT",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.teal,
                letterSpacing: 1.0,
              ),
            ),
            const SizedBox(height: 10),

            // GRID MENU
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: GridView.count(
                crossAxisCount: 3,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 15,
                crossAxisSpacing: 15,
                children: [
                  buildMenu(context, "Note d’info", Icons.description, onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const NoteInfoScreen()));
                  }),
                  buildMenu(context, "Messages", Icons.message, onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const MessagesScreen()));
                  }),
                  buildMenu(context, "Absences", Icons.event_busy, onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const AbsencesScreen()));
                  }),
                  buildMenu(context, "Résultats", Icons.school, onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const ResultatsScreen()));
                  }),
                  buildMenu(context, "Emploi", Icons.calendar_today, onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const EmploiScreen()));
                  }),
                  buildMenu(context, "Mon Groupe", Icons.group, onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const GroupScreen()));
                  }),
                  buildMenu(context, "Documents", Icons.folder, onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const DocumentsScreen()));
                  }),
                  buildMenu(context, "Partage", Icons.share, onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const PartageDocumentsPage()));
                  }),
                  buildMenu(context, "Demandes", Icons.assignment, onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const TicketsScreen()));
                  }),
                  buildMenu(context, "Site Web", Icons.public, onTap: () async {
                    final Uri url = Uri.parse("https://supcom.tn/");
                    if (await canLaunchUrl(url)) {
                      await launchUrl(url, mode: LaunchMode.externalApplication);
                    }
                  }),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // --- WIDGET D'AIDE POUR LE MENU ---
  Widget buildMenu(BuildContext context, String title, IconData icon, {VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: AppColors.primaryPink, size: 30),
            const SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
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
}
