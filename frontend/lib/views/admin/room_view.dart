import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../models/admin/room_model.dart';
import '../../viewmodels/admin/room_viewmodel.dart';
import 'add_room_view.dart';

class AdminRoomView extends StatelessWidget {
  const AdminRoomView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AdminRoomViewModel(),
      child: const _AdminRoomViewContent(),
    );
  }
}

class _AdminRoomViewContent extends StatelessWidget {
  const _AdminRoomViewContent();

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<AdminRoomViewModel>(context);

    return Scaffold(
      backgroundColor: AppColors.backgroundMint,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            _buildStatsRow(viewModel),
            _buildFilterChips(viewModel),
            Expanded(
              child: viewModel.isLoading
                  ? const Center(child: CircularProgressIndicator(color: AppColors.primaryPink))
                  : _buildRoomList(context, viewModel),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddRoomView()),
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
            'Salles',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow(AdminRoomViewModel viewModel) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          _buildStatChip('Libre', viewModel.freeCount, Colors.green),
          const SizedBox(width: 6),
          _buildStatChip('Occupée', viewModel.occupiedCount, Colors.orange),
          const SizedBox(width: 6),
          _buildStatChip('Maintenance', viewModel.maintenanceCount, Colors.red),
          const SizedBox(width: 6),
          _buildStatChip('Réservée', viewModel.reservedCount, Colors.blue),
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
            Text(label, style: TextStyle(fontSize: 11, color: color)),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChips(AdminRoomViewModel viewModel) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: viewModel.roomTypes.map((filter) {
            final isSelected = viewModel.selectedType == filter;
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: FilterChip(
                label: Text(filter),
                selected: isSelected,
                onSelected: (_) => viewModel.setTypeFilter(filter),
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

  Widget _buildRoomList(BuildContext context, AdminRoomViewModel viewModel) {
    if (viewModel.errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
            const SizedBox(height: 16),
            Text(
              'Erreur de connexion',
              style: TextStyle(fontSize: 18, color: Colors.grey[600]),
            ),
            const SizedBox(height: 8),
            Text(
              viewModel.errorMessage!,
              style: TextStyle(color: Colors.grey[500]),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: viewModel.fetchRooms,
              child: const Text('Réessayer'),
            ),
          ],
        ),
      );
    }

    if (viewModel.rooms.isEmpty) {
      return const Center(
        child: Text('Aucune salle trouvée', style: TextStyle(color: Colors.grey)),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: viewModel.rooms.length,
      itemBuilder: (context, index) {
        final room = viewModel.rooms[index];
        return _buildRoomCard(context, room, viewModel);
      },
    );
  }

  Widget _buildRoomCard(BuildContext context, AdminRoom room, AdminRoomViewModel viewModel) {
    Color statusColor;
    switch (room.status) {
      case 'available':
        statusColor = Colors.green;
        break;
      case 'occupied':
        statusColor = Colors.orange;
        break;
      case 'reserved':
        statusColor = Colors.blue;
        break;
      default:
        statusColor = Colors.red;
    }

    Color typeColor;
    switch (room.type) {
      case 'Amphithéâtre':
        typeColor = Colors.purple;
        break;
      case 'Laboratoire':
        typeColor = Colors.blue;
        break;
      case 'Bureau':
        typeColor = Colors.indigo;
        break;
      case 'Salle de réunion':
        typeColor = Colors.deepOrange;
        break;
      default:
        typeColor = Colors.teal;
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
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: typeColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.meeting_room, color: typeColor, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      room.name,
                      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        room.displayStatus,
                        style: TextStyle(color: statusColor, fontSize: 11, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: typeColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        room.type,
                        style: TextStyle(color: typeColor, fontSize: 11, fontWeight: FontWeight.w500),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(Icons.people, size: 14, color: Colors.grey[500]),
                    const SizedBox(width: 4),
                    Text(
                      'Étage ${room.floor} - ${room.building}',
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      '${room.capacity} places',
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    ),
                    if (room.hasProjector) ...[
                      const SizedBox(width: 12),
                      Icon(Icons.videocam, size: 14, color: Colors.blue[600]),
                      const SizedBox(width: 2),
                      Text('Vidéo', style: TextStyle(color: Colors.blue[600], fontSize: 10)),
                    ],
                    if (room.hasComputers) ...[
                      const SizedBox(width: 12),
                      Icon(Icons.computer, size: 14, color: Colors.green[600]),
                      const SizedBox(width: 2),
                      Text('PC', style: TextStyle(color: Colors.green[600], fontSize: 10)),
                    ],
                    if (room.hasAirConditioning) ...[
                      const SizedBox(width: 12),
                      Icon(Icons.ac_unit, size: 14, color: Colors.cyan[600]),
                      const SizedBox(width: 2),
                      Text('Clim', style: TextStyle(color: Colors.cyan[600], fontSize: 10)),
                    ],
                  ],
                ),
              ],
            ),
          ),
          PopupMenuButton(
            icon: const Icon(Icons.more_vert, color: Colors.grey),
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'details', child: Text('Détails')),
              const PopupMenuItem(value: 'edit', child: Text('Modifier')),
              if (room.status == 'available')
                const PopupMenuItem(value: 'occupy', child: Text('Marquer occupée')),
              if (room.status == 'occupied')
                const PopupMenuItem(value: 'free', child: Text('Libérer')),
              const PopupMenuItem(value: 'maintenance', child: Text('Maintenance')),
              const PopupMenuItem(value: 'delete', child: Text('Supprimer', style: TextStyle(color: Colors.red))),
            ],
            onSelected: (value) {
              switch (value) {
                case 'details':
                  _showRoomDetails(context, room);
                  break;
                case 'edit':
                  _editRoom(context, room, viewModel);
                  break;
                case 'occupy':
                  viewModel.updateRoomStatus(room.id, 'occupied');
                  break;
                case 'free':
                  viewModel.updateRoomStatus(room.id, 'available');
                  break;
                case 'maintenance':
                  viewModel.updateRoomStatus(room.id, 'maintenance');
                  break;
                case 'delete':
                  _showDeleteDialog(context, room, viewModel);
                  break;
              }
            },
          ),
        ],
      ),
    );
  }

  void _showRoomDetails(BuildContext context, AdminRoom room) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Détails - ${room.name}'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _detailRow('Type', room.type),
              _detailRow('Statut', room.displayStatus),
              _detailRow('Capacité', '${room.capacity} personnes'),
              _detailRow('Bâtiment', room.building),
              _detailRow('Étage', '${room.floor}'),
              if (room.description != null)
                _detailRow('Description', room.description!),
              const Divider(),
              Text('Équipements', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              _equipmentRow('Projecteur', room.hasProjector),
              _equipmentRow('Ordinateurs', room.hasComputers),
              _equipmentRow('Climatisation', room.hasAirConditioning),
              if (room.equipment.isNotEmpty) ...[
                const SizedBox(height: 12),
                Text('Équipement spécifique', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                ...room.equipment.map((eq) => Row(
                      children: [
                        Icon(Icons.circle, size: 6, color: Colors.grey[600]),
                        const SizedBox(width: 8),
                        Expanded(child: Text('${eq.name} (Qté: ${eq.quantity})')),
                      ],
                    )),
              ],
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Fermer'),
          ),
        ],
      ),
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(label, style: TextStyle(fontWeight: FontWeight.w500)),
          ),
          const Text(': '),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  Widget _equipmentRow(String label, bool available) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Icon(
            available ? Icons.check_circle : Icons.cancel,
            size: 16,
            color: available ? Colors.green : Colors.red,
          ),
          const SizedBox(width: 8),
          Text(label),
        ],
      ),
    );
  }

  void _editRoom(BuildContext context, AdminRoom room, AdminRoomViewModel viewModel) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddRoomView(room: room),
      ),
    ).then((_) {
      // Refresh rooms list after editing
      viewModel.fetchRooms();
    });
  }

  void _showDeleteDialog(BuildContext context, AdminRoom room, AdminRoomViewModel viewModel) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Supprimer la salle'),
        content: Text('Voulez-vous vraiment supprimer la salle "${room.name}" ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              viewModel.deleteRoom(room.id);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );
  }
}
