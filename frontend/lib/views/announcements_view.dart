import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/constants/app_colors.dart';
import '../models/announcement_model.dart';
import '../models/course_model.dart';
import '../viewmodels/announcements_viewmodel.dart';
import '../viewmodels/courses_viewmodel.dart';

class AnnouncementsView extends StatefulWidget {
  const AnnouncementsView({super.key});

  @override
  State<AnnouncementsView> createState() => _AnnouncementsViewState();
}

class _AnnouncementsViewState extends State<AnnouncementsView> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AnnouncementsViewModel(),
      child: Scaffold(
        backgroundColor: AppColors.backgroundMint,
        appBar: AppBar(
          backgroundColor: AppColors.primaryPink,
          elevation: 0,
          title: const Text('Annonces', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ),
        body: Consumer<AnnouncementsViewModel>(
          builder: (context, viewModel, _) {
            // Show error if present
            if (viewModel.error != null) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(viewModel.error!), backgroundColor: Colors.red),
                );
              });
            }

            if (viewModel.isLoading && viewModel.announcements.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }

            if (viewModel.announcements.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.notifications_none_outlined, size: 64, color: Colors.grey[400]),
                    const SizedBox(height: 16),
                    Text(
                      'Aucune annonce',
                      style: TextStyle(color: Colors.grey[600], fontSize: 18),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Les annonces apparaîtront ici',
                      style: TextStyle(color: Colors.grey[500], fontSize: 14),
                    ),
                  ],
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: viewModel.announcements.length,
              itemBuilder: (context, index) {
                final announcement = viewModel.announcements[index];
                return _buildAnnouncementCard(context, announcement, viewModel);
              },
            );
          },
        ),
        floatingActionButton: Consumer<AnnouncementsViewModel>(
          builder: (context, viewModel, _) {
            return FloatingActionButton(
              onPressed: () {
                _showCreateAnnouncementDialog(context, viewModel);
              },
              backgroundColor: AppColors.primaryPink,
              child: const Icon(Icons.add, color: Colors.white),
            );
          },
        ),
      ),
    );
  }

  Widget _buildAnnouncementCard(BuildContext context, AnnouncementModel announcement, AnnouncementsViewModel viewModel) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
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
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title and priority badge
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              if (announcement.isPinned)
                                const Icon(Icons.push_pin, size: 16, color: Colors.orange)
                              else
                                const SizedBox(width: 16),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  announcement.title,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            announcement.className,
                            style: TextStyle(color: Colors.grey[600], fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: announcement.priorityColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        announcement.priorityLabel,
                        style: TextStyle(
                          color: announcement.priorityColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  announcement.content,
                  style: TextStyle(color: Colors.grey[700], fontSize: 14),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Par ${announcement.creatorName}',
                          style: TextStyle(color: Colors.grey[500], fontSize: 12),
                        ),
                        Text(
                          announcement.formattedDate,
                          style: TextStyle(color: Colors.grey[500], fontSize: 12),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(
                            announcement.isPinned ? Icons.push_pin : Icons.push_pin_outlined,
                            color: announcement.isPinned ? Colors.orange : Colors.grey[400],
                            size: 20,
                          ),
                          onPressed: () {
                            viewModel.togglePin(announcement.id!);
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete_outline, color: Colors.red, size: 20),
                          onPressed: () {
                            _showDeleteConfirmation(context, announcement, viewModel);
                          },
                        ),
                      ],
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

  void _showDeleteConfirmation(
    BuildContext context,
    AnnouncementModel announcement,
    AnnouncementsViewModel viewModel,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Supprimer l\'annonce'),
        content: const Text('Êtes-vous sûr de vouloir supprimer cette annonce?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () {
              viewModel.deleteAnnouncement(announcement.id!);
              Navigator.pop(context);
            },
            child: const Text('Supprimer', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showCreateAnnouncementDialog(BuildContext context, AnnouncementsViewModel announcementsVM) {
    final titleController = TextEditingController();
    final contentController = TextEditingController();
    String selectedPriority = 'medium';
    String? selectedClassId;
    
    // Get coursesVM from context
    final coursesVM = Provider.of<CoursesViewModel>(context, listen: false);
    
    // Get unique classes from courses
    final Map<String, String> classes = {};
    for (var course in coursesVM.courses) {
      if (course.classId != null && course.className.isNotEmpty) {
        classes[course.classId!] = course.className;
      }
    }

    showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
                  title: const Text('Nouvelle annonce'),
                  content: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('Titre', style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        TextField(
                          controller: titleController,
                          decoration: InputDecoration(
                            hintText: 'Entrez le titre',
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text('Contenu', style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        TextField(
                          controller: contentController,
                          maxLines: 4,
                          decoration: InputDecoration(
                            hintText: 'Entrez le contenu',
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text('Classe', style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        if (classes.isEmpty)
                          const Text(
                            'Aucune classe disponible',
                            style: TextStyle(color: Colors.red, fontSize: 12),
                          )
                        else
                          DropdownButton<String>(
                            isExpanded: true,
                            value: selectedClassId,
                            hint: const Text('Sélectionnez une classe'),
                            items: classes.entries.map((entry) {
                              return DropdownMenuItem(
                                value: entry.key,
                                child: Text(entry.value),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                selectedClassId = value;
                              });
                            },
                          ),
                        const SizedBox(height: 16),
                        const Text('Priorité', style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        DropdownButton<String>(
                          isExpanded: true,
                          value: selectedPriority,
                          items: const [
                            DropdownMenuItem(value: 'low', child: Text('Basse')),
                            DropdownMenuItem(value: 'medium', child: Text('Normale')),
                            DropdownMenuItem(value: 'high', child: Text('Haute')),
                          ],
                          onChanged: (value) {
                            if (value != null) {
                              setState(() {
                                selectedPriority = value;
                              });
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Annuler'),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        if (titleController.text.isNotEmpty &&
                            contentController.text.isNotEmpty &&
                            selectedClassId != null) {
                          await announcementsVM.createAnnouncement(
                            titleController.text,
                            contentController.text,
                            selectedClassId!,
                            selectedPriority,
                          );
                          Navigator.pop(context);
                          if (announcementsVM.error == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Annonce créée avec succès')),
                            );
                          }
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Veuillez remplir tous les champs')),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryPink),
                      child: const Text('Créer', style: TextStyle(color: Colors.white)),
                    ),
                  ],
            );
          },
        );
      },
    );
  }
}
