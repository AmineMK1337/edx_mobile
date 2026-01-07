import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/chat_view_model.dart';
import '../../models/chat_model.dart';
import '../../models/user_model.dart';

class AdminChatView extends StatefulWidget {
  @override
  _AdminChatViewState createState() => _AdminChatViewState();
}

class _AdminChatViewState extends State<AdminChatView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ChatViewModel>().loadChats();
      context.read<ChatViewModel>().loadProfessors();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat with Professors'),
        backgroundColor: Colors.blue[800],
        actions: [
          IconButton(
            icon: Icon(Icons.add_comment),
            onPressed: () => _showNewChatDialog(),
          ),
        ],
      ),
      body: Consumer<ChatViewModel>(
        builder: (context, viewModel, child) {
          return Column(
            children: [
              // Chat List
              Expanded(
                child: viewModel.isLoading
                    ? Center(child: CircularProgressIndicator())
                    : viewModel.chats.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.chat_bubble_outline,
                                  size: 80,
                                  color: Colors.grey[400],
                                ),
                                SizedBox(height: 16),
                                Text(
                                  'No conversations yet',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Start a conversation with a professor',
                                  style: TextStyle(
                                    color: Colors.grey[500],
                                  ),
                                ),
                                SizedBox(height: 24),
                                ElevatedButton.icon(
                                  onPressed: _showNewChatDialog,
                                  icon: Icon(Icons.add),
                                  label: Text('Start Chat'),
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            padding: EdgeInsets.all(16),
                            itemCount: viewModel.chats.length,
                            itemBuilder: (context, index) {
                              final chat = viewModel.chats[index];
                              return _buildChatCard(chat, viewModel);
                            },
                          ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildChatCard(ChatModel chat, ChatViewModel viewModel) {
    final professor = chat.participants.firstWhere(
      (p) => p.role == 'professor',
      orElse: () => UserModel(
        id: '',
        name: 'Unknown Professor',
        email: '',
        role: 'professor',
        isActive: true,
        createdAt: DateTime.now(),
      ),
    );

    return Card(
      margin: EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.blue[100],
          child: Text(
            professor.name.isNotEmpty ? professor.name[0].toUpperCase() : 'P',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.blue[800],
            ),
          ),
        ),
        title: Text(
          professor.name,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(professor.email),
            if (chat.lastMessage != null) ...[
              SizedBox(height: 4),
              Text(
                chat.lastMessage!.content,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (chat.lastMessage != null)
              Text(
                _formatTime(chat.lastMessage!.timestamp),
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey[500],
                ),
              ),
            if (chat.unreadCount > 0) ...[
              SizedBox(height: 4),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '${chat.unreadCount}',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ],
        ),
        onTap: () => _openChatMessages(chat),
      ),
    );
  }

  void _showNewChatDialog() {
    showDialog(
      context: context,
      builder: (context) => Consumer<ChatViewModel>(
        builder: (context, viewModel, child) {
          return AlertDialog(
            title: Text('Start New Chat'),
            content: Container(
              width: double.maxFinite,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Select a professor to start chatting:'),
                  SizedBox(height: 16),
                  if (viewModel.professors.isEmpty)
                    Text(
                      'No professors available',
                      style: TextStyle(color: Colors.grey[600]),
                    )
                  else
                    Container(
                      height: 200,
                      child: ListView.builder(
                        itemCount: viewModel.professors.length,
                        itemBuilder: (context, index) {
                          final professor = viewModel.professors[index];
                          return ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.blue[100],
                              child: Text(
                                professor.name[0].toUpperCase(),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue[800],
                                ),
                              ),
                            ),
                            title: Text(professor.name),
                            subtitle: Text(professor.email),
                            onTap: () async {
                              Navigator.pop(context);
                              await viewModel.createChat(professor.id);
                            },
                          );
                        },
                      ),
                    ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Cancel'),
              ),
            ],
          );
        },
      ),
    );
  }

  void _openChatMessages(ChatModel chat) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatMessagesView(chat: chat),
      ),
    );
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final messageDate = DateTime(time.year, time.month, time.day);

    if (messageDate == today) {
      return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
    } else if (messageDate == today.subtract(Duration(days: 1))) {
      return 'Yesterday';
    } else {
      return '${time.day}/${time.month}';
    }
  }
}

class ChatMessagesView extends StatefulWidget {
  final ChatModel chat;

  const ChatMessagesView({Key? key, required this.chat}) : super(key: key);

  @override
  _ChatMessagesViewState createState() => _ChatMessagesViewState();
}

class _ChatMessagesViewState extends State<ChatMessagesView> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ChatViewModel>().loadChatMessages(widget.chat.id);
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final professor = widget.chat.participants.firstWhere(
      (p) => p.role == 'professor',
      orElse: () => UserModel(
        id: '',
        name: 'Unknown Professor',
        email: '',
        role: 'professor',
        isActive: true,
        createdAt: DateTime.now(),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.blue[100],
              radius: 18,
              child: Text(
                professor.name.isNotEmpty ? professor.name[0].toUpperCase() : 'P',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[800],
                ),
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    professor.name,
                    style: TextStyle(fontSize: 16),
                  ),
                  Text(
                    'Professor',
                    style: TextStyle(fontSize: 12, color: Colors.white70),
                  ),
                ],
              ),
            ),
          ],
        ),
        backgroundColor: Colors.blue[800],
      ),
      body: Consumer<ChatViewModel>(
        builder: (context, viewModel, child) {
          return Column(
            children: [
              // Messages
              Expanded(
                child: viewModel.isLoadingMessages
                    ? Center(child: CircularProgressIndicator())
                    : viewModel.messages.isEmpty
                        ? Center(
                            child: Text(
                              'No messages yet\nSend a message to start the conversation',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 16,
                              ),
                            ),
                          )
                        : ListView.builder(
                            controller: _scrollController,
                            padding: EdgeInsets.all(16),
                            itemCount: viewModel.messages.length,
                            itemBuilder: (context, index) {
                              final message = viewModel.messages[index];
                              final isFromAdmin = message.sender.role == 'admin';
                              return _buildMessageBubble(message, isFromAdmin);
                            },
                          ),
              ),

              // Message Input
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(top: BorderSide(color: Colors.grey[300]!)),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _messageController,
                        decoration: InputDecoration(
                          hintText: 'Type a message...',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(24),
                            borderSide: BorderSide(color: Colors.grey[300]!),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                        ),
                        maxLines: null,
                        textInputAction: TextInputAction.send,
                        onSubmitted: (_) => _sendMessage(viewModel),
                      ),
                    ),
                    SizedBox(width: 8),
                    FloatingActionButton(
                      onPressed: () => _sendMessage(viewModel),
                      child: Icon(Icons.send),
                      mini: true,
                      backgroundColor: Colors.blue[800],
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildMessageBubble(MessageModel message, bool isFromAdmin) {
    return Align(
      alignment: isFromAdmin ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 4),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.8,
        ),
        decoration: BoxDecoration(
          color: isFromAdmin ? Colors.blue[800] : Colors.grey[200],
          borderRadius: BorderRadius.circular(18).copyWith(
            bottomRight: isFromAdmin ? Radius.zero : null,
            bottomLeft: !isFromAdmin ? Radius.zero : null,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message.content,
              style: TextStyle(
                color: isFromAdmin ? Colors.white : Colors.black87,
                fontSize: 16,
              ),
            ),
            SizedBox(height: 4),
            Text(
              _formatMessageTime(message.timestamp),
              style: TextStyle(
                color: isFromAdmin ? Colors.white70 : Colors.grey[600],
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _sendMessage(ChatViewModel viewModel) async {
    final content = _messageController.text.trim();
    if (content.isNotEmpty) {
      _messageController.clear();
      await viewModel.sendMessage(widget.chat.id, content);
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  String _formatMessageTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }
}
