import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../viewmodels/admin/ticket_viewmodel.dart';
import 'ticket_detail_view.dart';

class AdminTicketView extends StatelessWidget {
  const AdminTicketView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AdminTicketViewModel(),
      child: const _AdminTicketViewContent(),
    );
  }
}

class _AdminTicketViewContent extends StatelessWidget {
  const _AdminTicketViewContent();

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<AdminTicketViewModel>(context);

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
                  : _buildTicketList(context, viewModel),
            ),
          ],
        ),
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
            'Tickets',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow(AdminTicketViewModel viewModel) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          _buildStatChip('Nouveau', viewModel.nouveauCount, Colors.blue),
          const SizedBox(width: 8),
          _buildStatChip('En cours', viewModel.enCoursCount, Colors.orange),
          const SizedBox(width: 8),
          _buildStatChip('Résolu', viewModel.resoluCount, Colors.green),
        ],
      ),
    );
  }

  Widget _buildStatChip(String label, int count, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Text(
              count.toString(),
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color),
            ),
            Text(label, style: TextStyle(fontSize: 12, color: color)),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterTabs(AdminTicketViewModel viewModel) {
    final filters = ['Tous', 'nouveau', 'en cours', 'resolu'];
    final labels = ['Tous', 'Nouveau', 'En cours', 'Résolu'];

    return Padding(
      padding: const EdgeInsets.all(20),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(filters.length, (index) {
            final isSelected = viewModel.selectedFilter == filters[index];
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: FilterChip(
                label: Text(labels[index]),
                selected: isSelected,
                onSelected: (_) => viewModel.setFilter(filters[index]),
                selectedColor: AppColors.primaryPink.withOpacity(0.2),
                checkmarkColor: AppColors.primaryPink,
                labelStyle: TextStyle(
                  color: isSelected ? AppColors.primaryPink : Colors.grey[600],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget _buildTicketList(BuildContext context, AdminTicketViewModel viewModel) {
    if (viewModel.tickets.isEmpty) {
      return const Center(
        child: Text('Aucun ticket trouvé', style: TextStyle(color: Colors.grey)),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: viewModel.tickets.length,
      itemBuilder: (context, index) {
        final ticket = viewModel.tickets[index];
        return _buildTicketCard(context, ticket);
      },
    );
  }

  Widget _buildTicketCard(BuildContext context, ticket) {
    Color priorityColor;
    switch (ticket.priority) {
      case 'haute':
        priorityColor = Colors.red;
        break;
      case 'moyenne':
        priorityColor = Colors.orange;
        break;
      default:
        priorityColor = Colors.green;
    }

    Color statusColor;
    switch (ticket.status) {
      case 'nouveau':
        statusColor = Colors.blue;
        break;
      case 'en cours':
        statusColor = Colors.orange;
        break;
      default:
        statusColor = Colors.green;
    }

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => TicketDetailView(ticketId: ticket.id)),
        );
      },
      child: Container(
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
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: priorityColor,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    ticket.title,
                    style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    ticket.status,
                    style: TextStyle(color: statusColor, fontSize: 12, fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.person_outline, size: 16, color: Colors.grey[500]),
                const SizedBox(width: 4),
                Text(ticket.userName, style: TextStyle(color: Colors.grey[600], fontSize: 13)),
                const Spacer(),
                Icon(Icons.calendar_today_outlined, size: 14, color: Colors.grey[500]),
                const SizedBox(width: 4),
                Text(ticket.date, style: TextStyle(color: Colors.grey[500], fontSize: 12)),
              ],
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                ticket.category,
                style: TextStyle(color: Colors.grey[600], fontSize: 11),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
