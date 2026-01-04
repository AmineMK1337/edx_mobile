import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/messages_e_viewmodel.dart';
import 'nmessage_e_view.dart';

class MessagesScreen extends StatefulWidget {
  const MessagesScreen({super.key});

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  @override
  void initState() {
    super.initState();
    // Chargement initial
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MessagesViewModel>().fetchMessages();
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<MessagesViewModel>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color.fromARGB(255, 64, 179, 255),
        title: const Text(
          "Messages",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: viewModel.isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: () => viewModel.fetchMessages(),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  children: [
                    const SizedBox(height: 18),
                    if (viewModel.messagesList.isEmpty)
                      const Padding(
                        padding: EdgeInsets.all(20.0),
                        child: Text("Aucun message."),
                      ),
                    
                    // Liste générée
                    ...viewModel.messagesList.map((msg) => _buildMessageCard(
                          sender: msg.sender,
                          role: msg.role,
                          preview: msg.preview,
                          time: msg.time,
                          unread: msg.unread,
                        )),

                    const SizedBox(height: 20),

                    // Bouton Nouveau Message
                    _buildNewMessageButton(context),
                    
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildNewMessageButton(BuildContext context) {
    return SizedBox(
      width: 260,
      height: 48,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromARGB(255, 3, 126, 214),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const NouveauMessageScreen()),
          );
        },
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.send, color: Colors.white, size: 20),
            SizedBox(width: 8),
            Text(
              "Nouveau message",
              style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageCard({
    required String sender,
    required String role,
    required String preview,
    required String time,
    required int unread,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: const Color(0xfff6f4ff),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CircleAvatar(
            radius: 24,
            backgroundColor: Colors.white,
            child: Icon(Icons.person, color: Colors.grey, size: 28),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(sender, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                Text(role, style: const TextStyle(color: Colors.grey, fontSize: 13)),
                const SizedBox(height: 5),
                Text(
                  preview,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 13, color: Colors.black54),
                ),
              ],
            ),
          ),
          Column(
            children: [
              if (time.isNotEmpty)
                Text(time, style: const TextStyle(fontSize: 12, color: Colors.grey)),
              if (unread > 0)
                Container(
                  margin: const EdgeInsets.only(top: 8),
                  padding: const EdgeInsets.all(6),
                  decoration: const BoxDecoration(color: Color.fromARGB(255, 239, 76, 6), shape: BoxShape.circle),
                  child: Text(
                    unread.toString(),
                    style: const TextStyle(fontSize: 11, color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                )
            ],
          ),
        ],
      ),
    );
  }
}