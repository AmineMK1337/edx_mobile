import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/student/ticket_e_viewmodel.dart';
import '../../models/student/ticket_e_model.dart';
import '../../core/constants/app_colors.dart';
import 'ticket_create_e_view.dart';

class TicketsScreen extends StatefulWidget {
  const TicketsScreen({super.key});

  @override
  State<TicketsScreen> createState() => _TicketsScreenState();
}

class _TicketsScreenState extends State<TicketsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TicketViewModel>().fetchTickets();
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<TicketViewModel>();

    return Scaffold(
      backgroundColor: AppColors.backgroundMint,
      appBar: AppBar(
        backgroundColor: AppColors.primaryPink,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Mes Demandes',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const CreateTicketScreen()),
          );
          if (result == true) {
            viewModel.fetchTickets();
          }
        },
        backgroundColor: AppColors.primaryPink,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Nouvelle demande', style: TextStyle(color: Colors.white)),
      ),
      body: _buildBody(viewModel),
    );
  }

  Widget _buildBody(TicketViewModel viewModel) {
    if (viewModel.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (viewModel.tickets.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.assignment_outlined, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'Aucune demande',
              style: TextStyle(color: Colors.grey[600], fontSize: 18),
            ),
            const SizedBox(height: 8),
            Text(
              'Créez une nouvelle demande avec le bouton +',
              style: TextStyle(color: Colors.grey[500], fontSize: 14),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => viewModel.fetchTickets(),
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: viewModel.tickets.length,
        itemBuilder: (context, index) {
          final ticket = viewModel.tickets[index];
          return _buildTicketCard(ticket, viewModel);
        },
      ),
    );
  }

  Widget _buildTicketCard(TicketModel ticket, TicketViewModel viewModel) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with type and status
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: _getTypeColor(ticket.ticketType).withOpacity(0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  _getTypeIcon(ticket.ticketType),
                  color: _getTypeColor(ticket.ticketType),
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    ticket.ticketTypeLabel,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: _getTypeColor(ticket.ticketType),
                    ),
                  ),
                ),
                _buildStatusChip(ticket.status, ticket.statusLabel),
              ],
            ),
          ),
          
          // Content
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  ticket.subject,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                
                if (ticket.ticketType == 'document_request') ...[
                  Row(
                    children: [
                      Icon(Icons.description, size: 16, color: Colors.grey[600]),
                      const SizedBox(width: 4),
                      Text(
                        ticket.documentTypeLabel,
                        style: TextStyle(color: Colors.grey[600], fontSize: 14),
                      ),
                    ],
                  ),
                ],
                
                if (ticket.ticketType == 'exam_review') ...[
                  Row(
                    children: [
                      Icon(Icons.school, size: 16, color: Colors.grey[600]),
                      const SizedBox(width: 4),
                      Text(
                        '${ticket.courseName ?? "N/A"} - Note: ${ticket.currentMark ?? "N/A"}',
                        style: TextStyle(color: Colors.grey[600], fontSize: 14),
                      ),
                    ],
                  ),
                ],
                
                const SizedBox(height: 8),
                Text(
                  ticket.message,
                  style: TextStyle(color: Colors.grey[700], fontSize: 14),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                
                if (ticket.response != null && ticket.response!.isNotEmpty) ...[
                  const Divider(height: 24),
                  Row(
                    children: [
                      Icon(Icons.reply, size: 16, color: Colors.green[600]),
                      const SizedBox(width: 4),
                      Text(
                        'Réponse:',
                        style: TextStyle(
                          color: Colors.green[600],
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    ticket.response!,
                    style: TextStyle(color: Colors.grey[700], fontSize: 14),
                  ),
                ],
                
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      ticket.createdAt,
                      style: TextStyle(color: Colors.grey[500], fontSize: 12),
                    ),
                    if (ticket.status == 'pending')
                      TextButton.icon(
                        onPressed: () => _showCancelDialog(ticket, viewModel),
                        icon: const Icon(Icons.cancel_outlined, size: 16),
                        label: const Text('Annuler'),
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.red,
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(String status, String label) {
    Color color;
    switch (status) {
      case 'pending':
        color = Colors.orange;
        break;
      case 'in_progress':
        color = Colors.blue;
        break;
      case 'approved':
        color = Colors.green;
        break;
      case 'rejected':
        color = Colors.red;
        break;
      case 'closed':
        color = Colors.grey;
        break;
      default:
        color = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Color _getTypeColor(String type) {
    switch (type) {
      case 'document_request':
        return Colors.blue;
      case 'exam_review':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  IconData _getTypeIcon(String type) {
    switch (type) {
      case 'document_request':
        return Icons.description;
      case 'exam_review':
        return Icons.rate_review;
      default:
        return Icons.assignment;
    }
  }

  void _showCancelDialog(TicketModel ticket, TicketViewModel viewModel) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.cancel, color: Colors.red),
            SizedBox(width: 10),
            Text('Annuler la demande'),
          ],
        ),
        content: const Text('Êtes-vous sûr de vouloir annuler cette demande ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Non', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () async {
              Navigator.pop(ctx);
              final success = await viewModel.cancelTicket(ticket.id);
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(success ? 'Demande annulée' : 'Erreur lors de l\'annulation'),
                    backgroundColor: success ? Colors.green : Colors.red,
                  ),
                );
              }
            },
            child: const Text('Oui, annuler', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
