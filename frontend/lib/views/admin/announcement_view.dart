import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../viewmodels/admin/announcement_viewmodel.dart';
import 'add_announcement_view.dart';

class AdminAnnouncementView extends StatelessWidget {
  const AdminAnnouncementView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AdminAnnouncementViewModel(),
      child: const _AdminAnnouncementViewContent(),
    );
  }
}

class _AdminAnnouncementViewContent extends StatelessWidget {
  const _AdminAnnouncementViewContent();

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<AdminAnnouncementViewModel>(context);

    return Scaffold(
      backgroundColor: AppColors.backgroundMint,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            _buildStatsRow(viewModel),
            _buildFilterTabs(viewModel),
            Expanded(
              child: viewModel.isLoading
                  ? const Center(child: CircularProgressIndicator(color: AppColors.primaryPink))
                  : _buildAnnouncementList(context, viewModel),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddAnnouncementView()),
          );
        },
        backgroundColor: AppColors.primaryPink,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          InkWell(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.arrow_back_ios_new, color: AppColors.primaryPink, size: 20),
            ),
          ),
          const SizedBox(width: 16),
          const Text(
            'Annonces',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow(AdminAnnouncementViewModel viewModel) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          _buildStatChip('Total', viewModel.allCount, Colors.grey),
          const SizedBox(width: 8),
          _buildStatChip('Publié', viewModel.publishedCount, Colors.green),
          const SizedBox(width: 8),
          _buildStatChip('Programmé', viewModel.scheduledCount, Colors.blue),
          const SizedBox(width: 8),
          _buildStatChip('Brouillon', viewModel.draftCount, Colors.orange),
        ],
      ),
    );
  }

  Widget _buildStatChip(String label, int count, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Text(
              count.toString(),
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color),
            ),
            Text(label, style: TextStyle(fontSize: 10, color: color)),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterTabs(AdminAnnouncementViewModel viewModel) {
    final filters = ['Tous', 'Publié', 'Programmé', 'Brouillon'];

    return Padding(
      padding: const EdgeInsets.all(20),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: filters.map((filter) {
            final isSelected = viewModel.selectedFilter == filter;
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: FilterChip(
                label: Text(filter),
                selected: isSelected,
                onSelected: (_) => viewModel.setFilter(filter),
                selectedColor: AppColors.primaryPink.withOpacity(0.2),
                checkmarkColor: AppColors.primaryPink,
                labelStyle: TextStyle(
                  color: isSelected ? AppColors.primaryPink : Colors.grey[600],
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildAnnouncementList(BuildContext context, AdminAnnouncementViewModel viewModel) {
    final announcements = viewModel.getFilteredAnnouncements();
    
    if (announcements.isEmpty) {
      return const Center(
        child: Text('Aucune annonce trouvée', style: TextStyle(color: Colors.grey)),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: announcements.length,
      itemBuilder: (context, index) {
        final announcement = announcements[index];
        return _buildAnnouncementCard(context, announcement, viewModel);
      },
    );
  }

  Widget _buildAnnouncementCard(BuildContext context, announcement, AdminAnnouncementViewModel viewModel) {
    Color statusColor;
    switch (announcement.status) {
      case 'Publié':
        statusColor = Colors.green;
        break;
      case 'Programmé':
        statusColor = Colors.blue;
        break;
      default:
        statusColor = Colors.orange;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.purple.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.campaign, color: Colors.purple, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      announcement.title,
                      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: statusColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            announcement.status,
                            style: TextStyle(color: statusColor, fontSize: 11, fontWeight: FontWeight.w500),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          announcement.audience,
                          style: TextStyle(color: Colors.grey[500], fontSize: 12),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              PopupMenuButton(
                icon: const Icon(Icons.more_vert, color: Colors.grey),
                itemBuilder: (context) => [
                  const PopupMenuItem(value: 'edit', child: Text('Modifier')),
                  const PopupMenuItem(value: 'delete', child: Text('Supprimer')),
                ],
                onSelected: (value) {
                  if (value == 'delete') {
                    _showDeleteDialog(context, announcement, viewModel);
                  }
                },
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(Icons.calendar_today, size: 14, color: Colors.grey[500]),
              const SizedBox(width: 4),
              Text(announcement.date, style: TextStyle(color: Colors.grey[500], fontSize: 12)),
              const Spacer(),
              Icon(Icons.visibility, size: 14, color: Colors.grey[500]),
              const SizedBox(width: 4),
              Text('${announcement.views} vues', style: TextStyle(color: Colors.grey[500], fontSize: 12)),
            ],
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, announcement, AdminAnnouncementViewModel viewModel) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Supprimer l\'annonce'),
        content: Text('Voulez-vous vraiment supprimer "${announcement.title}" ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              viewModel.deleteAnnouncement(announcement.id);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Supprimer', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
