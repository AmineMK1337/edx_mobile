import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../models/professor/message_model.dart';
import '../../viewmodels/professor/messages_viewmodel.dart';
import '../../services/api_service.dart';

class MessagesView extends StatelessWidget {
  const MessagesView({super.key});

  void _showNewMessageDialog(BuildContext context, MessagesViewModel viewModel) {
    viewModel.fetchAvailableRecipients();
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => NewMessageDialog(viewModel: viewModel),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => MessagesViewModel(),
      child: Consumer<MessagesViewModel>(
        builder: (context, viewModel, _) {
          return Scaffold(
            backgroundColor: AppColors.backgroundMint,
            appBar: AppBar(
              backgroundColor: AppColors.primaryPink,
              elevation: 0,
              title: const Text('Messages', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              actions: [
                IconButton(
                  icon: const Icon(Icons.refresh, color: Colors.white),
                  onPressed: () => viewModel.fetchConversations(),
                ),
              ],
            ),
            body: _buildConversationsList(viewModel, context),
            floatingActionButton: FloatingActionButton(
              onPressed: () => _showNewMessageDialog(context, viewModel),
              backgroundColor: AppColors.primaryPink,
              child: const Icon(Icons.edit, color: Colors.white),
            ),
          );
        },
      ),
    );
  }

  Widget _buildConversationsList(MessagesViewModel viewModel, BuildContext context) {
    if (viewModel.isLoading && viewModel.conversations.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    // Show error if there is one
    if (viewModel.error != null && viewModel.conversations.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
            const SizedBox(height: 16),
            Text(
              'Erreur de chargement',
              style: TextStyle(color: Colors.grey[600], fontSize: 18),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                viewModel.error!,
                style: TextStyle(color: Colors.grey[500], fontSize: 14),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => viewModel.fetchConversations(),
              icon: const Icon(Icons.refresh),
              label: const Text('Réessayer'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryPink,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      );
    }

    if (viewModel.conversations.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.chat_bubble_outline, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'Aucune conversation',
              style: TextStyle(color: Colors.grey[600], fontSize: 18),
            ),
            const SizedBox(height: 8),
            Text(
              'Envoyez un message pour commencer',
              style: TextStyle(color: Colors.grey[500], fontSize: 14),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => _showNewMessageDialog(context, viewModel),
              icon: const Icon(Icons.add),
              label: const Text('Nouveau message'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryPink,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.only(left: 8, right: 8, top: 8, bottom: 80),
      itemCount: viewModel.conversations.length,
      itemBuilder: (context, index) {
        final conversation = viewModel.conversations[index];
        return GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => ChangeNotifierProvider.value(
                  value: viewModel,
                  child: ConversationView(
                    recipientId: conversation.userId,
                    recipientName: conversation.name,
                  ),
                ),
              ),
            );
          },
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            padding: const EdgeInsets.all(12),
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
            child: Row(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: AppColors.primaryPink,
                  child: Text(
                    conversation.name.isNotEmpty ? conversation.name[0].toUpperCase() : '?',
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              conversation.name,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text(
                            conversation.formattedTime,
                            style: TextStyle(color: Colors.grey[500], fontSize: 12),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        conversation.lastMessage,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: conversation.unreadCount > 0 ? Colors.black87 : Colors.grey[600],
                          fontSize: 14,
                          fontWeight: conversation.unreadCount > 0 ? FontWeight.w500 : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
                if (conversation.unreadCount > 0)
                  Container(
                    margin: const EdgeInsets.only(left: 8),
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: AppColors.primaryPink,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '${conversation.unreadCount}',
                      style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// Dialog for creating new message
class NewMessageDialog extends StatefulWidget {
  final MessagesViewModel viewModel;

  const NewMessageDialog({super.key, required this.viewModel});

  @override
  State<NewMessageDialog> createState() => _NewMessageDialogState();
}

class _NewMessageDialogState extends State<NewMessageDialog> {
  final _messageController = TextEditingController();
  UserRecipient? _selectedRecipient;
  bool _isSending = false;
  String _searchQuery = '';

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  List<UserRecipient> get _filteredRecipients {
    if (_searchQuery.isEmpty) {
      return widget.viewModel.availableRecipients;
    }
    return widget.viewModel.availableRecipients
        .where((r) =>
            r.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            r.email.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();
  }

  Future<void> _sendMessage() async {
    if (_selectedRecipient == null || _messageController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez sélectionner un destinataire et écrire un message')),
      );
      return;
    }

    setState(() => _isSending = true);

    final success = await widget.viewModel.createNewConversation(
      _selectedRecipient!.id,
      _messageController.text.trim(),
    );

    setState(() => _isSending = false);

    if (success && mounted) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Message envoyé avec succès'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.primaryPink,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close, color: Colors.white),
                ),
                const Text(
                  'Nouveau message',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: _isSending ? null : _sendMessage,
                  child: _isSending
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text(
                          'Envoyer',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ],
            ),
          ),
          
          // Selected recipient indicator
          if (_selectedRecipient != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              color: Colors.grey[100],
              child: Row(
                children: [
                  const Text('À: ', style: TextStyle(color: Colors.grey)),
                  Chip(
                    avatar: CircleAvatar(
                      backgroundColor: AppColors.primaryPink,
                      child: Text(
                        _selectedRecipient!.name[0].toUpperCase(),
                        style: const TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ),
                    label: Text(_selectedRecipient!.name),
                    deleteIcon: const Icon(Icons.close, size: 16),
                    onDeleted: () => setState(() => _selectedRecipient = null),
                  ),
                ],
              ),
            ),

          // Search / Recipient selection
          if (_selectedRecipient == null)
            Expanded(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: TextField(
                      onChanged: (value) => setState(() => _searchQuery = value),
                      decoration: InputDecoration(
                        hintText: 'Rechercher un destinataire...',
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey[300]!),
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListenableBuilder(
                      listenable: widget.viewModel,
                      builder: (context, _) {
                        if (widget.viewModel.isLoadingRecipients) {
                          return const Center(child: CircularProgressIndicator());
                        }

                        if (_filteredRecipients.isEmpty) {
                          return Center(
                            child: Text(
                              _searchQuery.isEmpty
                                  ? 'Aucun utilisateur disponible'
                                  : 'Aucun résultat trouvé',
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                          );
                        }

                        return ListView.builder(
                          itemCount: _filteredRecipients.length,
                          itemBuilder: (context, index) {
                            final recipient = _filteredRecipients[index];
                            return ListTile(
                              leading: CircleAvatar(
                                backgroundColor: AppColors.primaryPink,
                                child: Text(
                                  recipient.name[0].toUpperCase(),
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                              title: Text(recipient.name),
                              subtitle: Text(
                                '${recipient.email} • ${_getRoleLabel(recipient.role)}',
                                style: TextStyle(color: Colors.grey[500], fontSize: 12),
                              ),
                              onTap: () => setState(() => _selectedRecipient = recipient),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),

          // Message input (shown when recipient is selected)
          if (_selectedRecipient != null)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: TextField(
                  controller: _messageController,
                  maxLines: null,
                  expands: true,
                  textAlignVertical: TextAlignVertical.top,
                  decoration: InputDecoration(
                    hintText: 'Écrire votre message...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    contentPadding: const EdgeInsets.all(16),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  String _getRoleLabel(String role) {
    switch (role.toLowerCase()) {
      case 'prof':
      case 'professor':
        return 'Professeur';
      case 'student':
        return 'Étudiant';
      case 'admin':
        return 'Administrateur';
      default:
        return role;
    }
  }
}

class ConversationView extends StatefulWidget {
  final String recipientId;
  final String recipientName;

  const ConversationView({
    super.key,
    required this.recipientId,
    required this.recipientName,
  });

  @override
  State<ConversationView> createState() => _ConversationViewState();
}

class _ConversationViewState extends State<ConversationView> {
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentUserId = ApiService.getCurrentUser()?['_id'];
    
    return Scaffold(
      backgroundColor: AppColors.backgroundMint,
      appBar: AppBar(
        backgroundColor: AppColors.primaryPink,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: Colors.white,
              child: Text(
                widget.recipientName.isNotEmpty ? widget.recipientName[0].toUpperCase() : '?',
                style: const TextStyle(color: AppColors.primaryPink, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                widget.recipientName,
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
      body: Consumer<MessagesViewModel>(
        builder: (context, viewModel, _) {
          // Load conversation when widget builds
          if (viewModel.currentRecipientId != widget.recipientId) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              viewModel.fetchConversation(widget.recipientId);
            });
          }

          // Scroll to bottom when messages change
          WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());

          return Column(
            children: [
              Expanded(
                child: viewModel.isLoading && viewModel.currentMessages.isEmpty
                    ? const Center(child: CircularProgressIndicator())
                    : viewModel.currentMessages.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.chat_bubble_outline, size: 48, color: Colors.grey[400]),
                                const SizedBox(height: 12),
                                Text(
                                  'Aucun message',
                                  style: TextStyle(color: Colors.grey[600]),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Envoyez un message pour commencer',
                                  style: TextStyle(color: Colors.grey[500], fontSize: 12),
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            controller: _scrollController,
                            padding: const EdgeInsets.all(16),
                            itemCount: viewModel.currentMessages.length,
                            itemBuilder: (context, index) {
                              final message = viewModel.currentMessages[index];
                              final isCurrentUserSender = message.senderId == currentUserId;

                              return Align(
                                alignment: isCurrentUserSender ? Alignment.centerRight : Alignment.centerLeft,
                                child: Container(
                                  margin: const EdgeInsets.only(bottom: 12),
                                  constraints: BoxConstraints(
                                    maxWidth: MediaQuery.of(context).size.width * 0.75,
                                  ),
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                  decoration: BoxDecoration(
                                    color: isCurrentUserSender ? AppColors.primaryPink : Colors.white,
                                    borderRadius: BorderRadius.only(
                                      topLeft: const Radius.circular(16),
                                      topRight: const Radius.circular(16),
                                      bottomLeft: isCurrentUserSender ? const Radius.circular(16) : const Radius.circular(4),
                                      bottomRight: isCurrentUserSender ? const Radius.circular(4) : const Radius.circular(16),
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.05),
                                        blurRadius: 8,
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    crossAxisAlignment: isCurrentUserSender ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        message.content,
                                        style: TextStyle(
                                          color: isCurrentUserSender ? Colors.white : Colors.black87,
                                          fontSize: 15,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            message.formattedTime,
                                            style: TextStyle(
                                              color: isCurrentUserSender ? Colors.white70 : Colors.grey[500],
                                              fontSize: 11,
                                            ),
                                          ),
                                          if (isCurrentUserSender) ...[
                                            const SizedBox(width: 4),
                                            Icon(
                                              message.isRead ? Icons.done_all : Icons.done,
                                              size: 14,
                                              color: Colors.white70,
                                            ),
                                          ],
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
              ),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 8,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: SafeArea(
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _messageController,
                          maxLines: null,
                          minLines: 1,
                          textCapitalization: TextCapitalization.sentences,
                          decoration: InputDecoration(
                            hintText: 'Écrire un message...',
                            filled: true,
                            fillColor: Colors.grey[100],
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(24),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        decoration: const BoxDecoration(
                          color: AppColors.primaryPink,
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          onPressed: () async {
                            if (_messageController.text.trim().isNotEmpty) {
                              await viewModel.sendMessage(
                                widget.recipientId,
                                _messageController.text.trim(),
                              );
                              _messageController.clear();
                              _scrollToBottom();
                            }
                          },
                          icon: const Icon(Icons.send, color: Colors.white, size: 20),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
