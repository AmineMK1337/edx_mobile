import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import 'about_view.dart';
import 'settings_view.dart';

class RoleStat {
  final String label;
  final String count;
  final Color color;
  const RoleStat(
      {required this.label, required this.count, required this.color});
}

class RoleHomeLayout extends StatelessWidget {
  final String titleText; // e.g., ESPACE PROFESSEUR / ÉTUDIANT / ADMINISTRATION
  final String userName;
  final String userRoleDisplay; // e.g., Professeur / Étudiant / Administrateur
  final List<RoleStat> stats; // Optional: if empty, stats card is hidden
  final Widget menuGrid; // The role-specific grid widget
  final VoidCallback onLogout;
  final String bannerAssetPath;

  const RoleHomeLayout({
    super.key,
    required this.titleText,
    required this.userName,
    required this.userRoleDisplay,
    required this.stats,
    required this.menuGrid,
    required this.onLogout,
    this.bannerAssetPath = 'assets/supcom.png',
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundMint,
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeaderSection(context),
            const SizedBox(height: 20),
            Text(
              titleText,
              style: const TextStyle(
                color: Colors.teal,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.0,
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: menuGrid,
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderSection(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.topCenter,
      children: [
        Column(
          children: [
            // Top Bar
            Container(
              padding: const EdgeInsets.only(
                  top: 40, left: 20, right: 20, bottom: 15),
              color: const Color.fromARGB(200, 127, 142, 230),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      _buildPopupMenu(context),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            userName,
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
                          ),
                          Text(
                            userRoleDisplay,
                            style: const TextStyle(
                                color: Colors.white70, fontSize: 12),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(_getCurrentTime(),
                          style: const TextStyle(
                              color: Colors.white, fontSize: 16)),
                      const SizedBox(width: 10),
                      IconButton(
                        icon: const Icon(Icons.logout, color: Colors.white),
                        onPressed: onLogout,
                        tooltip: 'Déconnexion',
                      ),
                    ],
                  )
                ],
              ),
            ),
            // Banner image
            Container(
              height: 140,
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(bannerAssetPath),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
        if (stats.isNotEmpty)
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
                children: stats
                    .map((s) => _buildStatItem(s.count, s.label, s.color))
                    .toList(),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildPopupMenu(BuildContext context) {
    return PopupMenuButton<String>(
      offset: const Offset(0, 50),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      onSelected: (value) {
        switch (value) {
          case 'settings':
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const SettingsView()));
            break;
          case 'about':
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const AboutView()));
            break;
        }
      },
      itemBuilder: (context) => const [
        PopupMenuItem(
          value: 'settings',
          child: Row(
            children: [
              Icon(Icons.settings, color: Colors.blueGrey),
              SizedBox(width: 12),
              Text('Paramètres'),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'about',
          child: Row(
            children: [
              Icon(Icons.info_outline, color: Colors.blueGrey),
              SizedBox(width: 12),
              Text('À propos'),
            ],
          ),
        ),
      ],
      child: const CircleAvatar(
        backgroundColor: Colors.white,
        radius: 22,
        child: Icon(Icons.school, color: Color.fromARGB(199, 45, 66, 187)),
      ),
    );
  }

  Widget _buildStatItem(String count, String label, Color color) {
    return Column(
      children: [
        Text(
          count,
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: color),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(color: Colors.grey, fontSize: 12),
        ),
      ],
    );
  }

  String _getCurrentTime() {
    final now = DateTime.now();
    return '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
  }
}
