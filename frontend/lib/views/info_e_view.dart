import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/info_e_viewmodel.dart';

class NoteInfoScreen extends StatefulWidget {
  const NoteInfoScreen({super.key});

  @override
  State<NoteInfoScreen> createState() => _NoteInfoScreenState();
}

class _NoteInfoScreenState extends State<NoteInfoScreen> {
  @override
  void initState() {
    super.initState();
    // Charger les notes au lancement
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<InfoViewModel>().fetchNotes();
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<InfoViewModel>();

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 64, 179, 255),
        elevation: 0,
        title: const Text(
          "Note d'info",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: viewModel.isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: () => viewModel.fetchNotes(),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Informations importantes",
                      style: TextStyle(fontSize: 14, color: Colors.blue, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 15),
                    
                    if (viewModel.notes.isEmpty)
                      const Center(child: Padding(
                        padding: EdgeInsets.only(top: 50),
                        child: Text("Aucune information disponible."),
                      )),

                    ...viewModel.notes.map((note) => _buildInfoCard(
                          icon: viewModel.getIconForCategory(note.category),
                          title: note.title,
                          description: note.description,
                          date: note.date,
                          category: note.category,
                          categoryColor: Colors.blue,
                        )),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String description,
    required String date,
    required String category,
    required Color categoryColor,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: const Color.fromARGB(255, 205, 24, 15), size: 24),
              const SizedBox(width: 10),
              Expanded(
                child: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(description, style: TextStyle(fontSize: 13, color: Colors.grey[700])),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(date, style: TextStyle(fontSize: 11, color: Colors.grey[500])),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: categoryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Text(
                  category,
                  style: TextStyle(fontSize: 11, color: categoryColor, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}