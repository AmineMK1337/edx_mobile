import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../viewmodels/admin/admin_viewmodel.dart';
import '../../services/auth_service.dart';
import '../../services/api_service.dart';
import '../common/login_view.dart';
import '../common/role_home_layout.dart';

// Import all admin views
import 'user_view.dart';
import 'ticket_view.dart';
import 'rattrapage_view.dart';
import 'announcement_view.dart';
import 'schedule_view.dart';
import 'subject_view.dart';
import 'room_view.dart';
import 'document_view.dart';
import 'publish_view.dart';
import '../timetable_view.dart';
import '../professor_session_view.dart';
import 'chat_view.dart';

class AdminView extends StatelessWidget {
  const AdminView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AdminViewModel(),
      child: const _AdminViewContent(),
    );
  }
}

class _AdminViewContent extends StatelessWidget {
  const _AdminViewContent();

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<AdminViewModel>(context);

    final statsList = viewModel.stats == null
        ? <RoleStat>[]
        : <RoleStat>[
            RoleStat(
                label: 'Tickets',
                count: viewModel.stats!.ticketsCount.toString(),
                color: Colors.orange),
            RoleStat(
                label: 'Utilisateurs',
                count: viewModel.stats!.usersCount.toString(),
                color: Colors.blue),
            RoleStat(
                label: 'Rattrapages',
                count: viewModel.stats!.rattrapagesCount.toString(),
                color: Colors.green),
          ];

    final grid = GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1,
      ),
      itemCount: viewModel.menuItems.length,
      itemBuilder: (context, index) {
        final item = viewModel.menuItems[index];
        return _buildMenuItem(
            context, item.title, item.icon, item.color, index);
      },
    );

    return RoleHomeLayout(
      titleText: 'ESPACE ADMINISTRATION',
      userName: ApiService.getUserName(),
      userRoleDisplay: 'Administrateur',
      stats: statsList,
      menuGrid: grid,
      onLogout: () => _handleLogout(context),
    );
  }

  void _handleLogout(BuildContext context) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Déconnexion'),
        content: const Text('Voulez-vous vraiment vous déconnecter ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child:
                const Text('Déconnexion', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await AuthService().logout();
      if (context.mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const LoginView()),
          (route) => false,
        );
      }
    }
  }

  Widget _buildStatsRow(AdminViewModel viewModel) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          _buildStatCard(
            'Tickets',
            viewModel.stats!.ticketsCount.toString(),
            Icons.confirmation_number,
            Colors.orange,
          ),
          const SizedBox(width: 12),
          _buildStatCard(
            'Utilisateurs',
            viewModel.stats!.usersCount.toString(),
            Icons.people,
            Colors.blue,
          ),
          const SizedBox(width: 12),
          _buildStatCard(
            'Rattrapages',
            viewModel.stats!.rattrapagesCount.toString(),
            Icons.refresh,
            Colors.green,
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
      String title, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: color, size: 18),
                ),
                const Spacer(),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              value,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // _buildMenuGrid not used in new layout; retained helpers below

  Widget _buildMenuItem(BuildContext context, String title, IconData icon,
      Color color, int index) {
    return InkWell(
      onTap: () => _navigateToPage(context, index),
      borderRadius: BorderRadius.circular(20),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToPage(BuildContext context, int index) {
    Widget page;
    switch (index) {
      case 0:
        page = const AdminUserView();
        break;
      case 1:
        page = const AdminTicketView();
        break;
      case 2:
        page = const AdminRattrapageView();
        break;
      case 3:
        page = const AdminAnnouncementView();
        break;
      case 4:
        page = const AdminScheduleView();
        break;
      case 5:
        page = const AdminSubjectView();
        break;
      case 6:
        page = const AdminRoomView();
        break;
      case 7:
        page = const AdminDocumentView();
        break;
      case 8:
        page = const AdminPublishView();
        break;
      case 9:
        page = const TimetableView();
        break;
      case 10:
        page = ProfessorSessionView();
        break;
      case 11:
        page = AdminChatView();
        break;
      default:
        return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }
}
