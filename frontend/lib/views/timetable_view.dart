import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/timetable_viewmodel.dart';
import '../models/timetable_model.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';
import 'upload_timetable_view.dart';

class TimetableView extends StatefulWidget {
  const TimetableView({Key? key}) : super(key: key);

  @override
  _TimetableViewState createState() => _TimetableViewState();
}

class _TimetableViewState extends State<TimetableView> {
  final AuthService _authService = AuthService();
  UserModel? _currentUser;
  bool _isAdmin = false;

  @override
  void initState() {
    super.initState();
    _loadCurrentUser();
  }

  Future<void> _loadCurrentUser() async {
    final user = await _authService.getCurrentUser();
    if (user != null) {
      setState(() {
        _currentUser = user;
        _isAdmin = user.role == 'admin';
      });
      
      final viewModel = context.read<TimetableViewModel>();
      if (_isAdmin) {
        viewModel.getAllTimetables();
      } else {
        // For students/professors, load timetables for their class
        if (user.classId != null) {
          viewModel.getTimetablesByClass(user.classId!);
        }
      }
    }
  }

  Future<void> _refreshTimetables() async {
    final viewModel = context.read<TimetableViewModel>();
    if (_isAdmin) {
      viewModel.getAllTimetables();
    } else if (_currentUser?.classId != null) {
      viewModel.getTimetablesByClass(_currentUser!.classId!);
    }
  }

  Future<void> _deleteTimetable(String id) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Delete'),
        content: const Text('Are you sure you want to delete this timetable?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final viewModel = context.read<TimetableViewModel>();
      final success = await viewModel.deleteTimetable(id);
      
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Timetable deleted successfully')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(viewModel.error ?? 'Failed to delete timetable'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Timetables'),
        backgroundColor: const Color(0xFF2E3192),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: _refreshTimetables,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: Consumer<TimetableViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (viewModel.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Error: ${viewModel.error}',
                    style: const TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _refreshTimetables,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (viewModel.timetables.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.schedule,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No timetables available',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[600],
                    ),
                  ),
                  if (_isAdmin) ...[
                    const SizedBox(height: 8),
                    Text(
                      'Upload a timetable to get started',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: _refreshTimetables,
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: viewModel.timetables.length,
              itemBuilder: (context, index) {
                final timetable = viewModel.timetables[index];
                return _buildTimetableCard(timetable);
              },
            ),
          );
        },
      ),
      floatingActionButton: _isAdmin
          ? FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const UploadTimetableView(),
                  ),
                ).then((_) => _refreshTimetables());
              },
              backgroundColor: const Color(0xFF2E3192),
              child: const Icon(Icons.add, color: Colors.white),
            )
          : null,
    );
  }

  Widget _buildTimetableCard(TimetableModel timetable) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 4,
      child: Column(
        children: [
          ListTile(
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF2E3192).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.picture_as_pdf,
                color: Color(0xFF2E3192),
                size: 32,
              ),
            ),
            title: Text(
              timetable.title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Class: ${timetable.classRef.level}${timetable.classRef.section}'),
                Text('${timetable.semesterDisplay} • ${timetable.academicYear}'),
                if (timetable.description.isNotEmpty)
                  Text(
                    timetable.description,
                    style: TextStyle(color: Colors.grey[600]),
                  ),
              ],
            ),
            isThreeLine: true,
          ),
          
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Icon(Icons.file_download, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text(
                  '${timetable.downloadCount} downloads',
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
                const Spacer(),
                Text(
                  timetable.formattedFileSize,
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
                const SizedBox(width: 8),
                Text(
                  '${timetable.createdAt.day}/${timetable.createdAt.month}/${timetable.createdAt.year}',
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
              ],
            ),
          ),

          ButtonBar(
            alignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton.icon(
                onPressed: () {
                  // TODO: Implement download functionality
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Download feature will be implemented')),
                  );
                },
                icon: const Icon(Icons.download),
                label: const Text('Download'),
              ),
              if (_isAdmin)
                TextButton.icon(
                  onPressed: () => _deleteTimetable(timetable.id),
                  icon: const Icon(Icons.delete, color: Colors.red),
                  label: const Text('Delete', style: TextStyle(color: Colors.red)),
                ),
            ],
          ),
        ],
      ),
    );
  }
}