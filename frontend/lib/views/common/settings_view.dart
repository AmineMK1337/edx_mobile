import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/common/settings_viewmodel.dart';
import '../../viewmodels/student/student_e_viewmodel.dart';
import '../../core/constants/app_colors.dart';
import 'about_view.dart';
import 'general_info_view.dart';
import '../student/profile_e_view.dart';
import 'login_view.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<SettingsViewModel>();
    final settings = vm.settings;
    final studentVM = context.watch<StudentViewModel>();

    return Scaffold(
      backgroundColor: AppColors.backgroundMint,
      appBar: AppBar(
        backgroundColor: AppColors.primaryPink,
        title: const Text('Paramètres', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildSection(
              title: 'Mon Compte',
              icon: Icons.person_outline,
              items: [
                _buildNavigationTile(
                  'Mon Profil',
                  '${studentVM.student?.firstName ?? settings.userName} - ${settings.userPhone}',
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfileView())),
                ),
              ],
            ),
            _buildSection(
              title: 'Notifications',
              icon: Icons.notifications_none,
              items: [
                _buildSwitchTile(
                  'Notifications push',
                  'Recevoir les alertes importantes',
                  settings.pushNotifications,
                  (val) => vm.updatePushNotifications(val),
                ),
                _buildSwitchTile(
                  'Nouvelles notes',
                  'Alertes pour les nouvelles notes',
                  settings.gradeAlerts,
                  (val) => vm.updateGradeAlerts(val),
                ),
                _buildSwitchTile(
                  'Messages',
                  'Alertes pour les nouveaux messages',
                  settings.messageAlerts,
                  (val) => vm.updateMessageAlerts(val),
                ),
                _buildSwitchTile(
                  'Absences',
                  'Alertes pour les absences',
                  settings.absenceAlerts,
                  (val) => vm.updateAbsenceAlerts(val),
                ),
              ],
            ),
            _buildSection(
              title: 'Aide & Informations',
              icon: Icons.help_outline,
              items: [
                _buildNavigationTile(
                  'Informations Générales',
                  'Calendrier, règlement et contacts',
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const GeneralInfoView())),
                ),
                _buildNavigationTile(
                  "À propos de SUP'COM",
                  'Chiffres clés et présentation',
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const AboutView())),
                ),
              ],
            ),
            _buildSection(
              title: 'Apparence',
              icon: Icons.phone_android,
              items: [
                _buildSwitchTile(
                  'Mode sombre',
                  'Activer le thème sombre',
                  settings.isDarkMode,
                  (val) => vm.updateDarkMode(val),
                ),
                _buildNavigationTile('Langue', settings.currentLanguage, onTap: () {}),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFD81B60),
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                onPressed: () {
                  vm.logout();
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginView()),
                    (route) => false,
                  );
                },
                icon: const Icon(Icons.logout, color: Colors.white),
                label: const Text('Se déconnecter', style: TextStyle(color: Colors.white, fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({required String title, required IconData icon, required List<Widget> items}) {
    return Container(
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(children: [
              Icon(icon, color: Colors.blueGrey),
              const SizedBox(width: 8),
              Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ]),
          ),
          ...items,
        ],
      ),
    );
  }

  Widget _buildSwitchTile(String title, String subtitle, bool value, ValueChanged<bool> onChanged) {
    return ListTile(
      title: Text(title),
      subtitle: Text(subtitle, style: const TextStyle(fontSize: 12)),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: AppColors.primaryPink,
      ),
    );
  }

  Widget _buildNavigationTile(String title, String subtitle, {required VoidCallback onTap}) {
    return ListTile(
      title: Text(title),
      subtitle: Text(subtitle, style: const TextStyle(fontSize: 12)),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
