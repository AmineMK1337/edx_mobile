import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import '../viewmodels/timetable_view_model.dart';
import '../models/timetable_model.dart';
import '../models/user_model.dart';

class TimetableManagementView extends StatefulWidget {
  @override
  _TimetableManagementViewState createState() => _TimetableManagementViewState();
}

class _TimetableManagementViewState extends State<TimetableManagementView> {
  final _formKey = GlobalKey<FormState>();
  String _selectedTargetType = 'all';
  List<String> _selectedUsers = [];
  String _academicYear = '2023-2024';
  String _semester = '1';
  String _description = '';
  PlatformFile? _selectedFile;
  List<UserModel> _availableUsers = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TimetableViewModel>().loadTimetables();
      _loadUsers();
    });
  }

  _loadUsers() async {
    // This would typically load from an API
    // For now, we'll use mock data
    setState(() {
      _availableUsers = [
        // Mock users - in real app, load from API
      ];
    });
  }

  Future<void> _pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      if (result != null) {
        setState(() {
          _selectedFile = result.files.first;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking file: ${e.toString()}')),
      );
    }
  }

  Future<void> _uploadTimetable() async {
    if (_formKey.currentState!.validate() && _selectedFile != null) {
      try {
        await context.read<TimetableViewModel>().uploadTimetable(
          filePath: _selectedFile!.path!,
          fileName: _selectedFile!.name,
          targetType: _selectedTargetType,
          targetUsers: _selectedUsers,
          academicYear: _academicYear,
          semester: _semester,
          description: _description,
        );
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Timetable uploaded successfully')),
        );
        
        _resetForm();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error uploading timetable: ${e.toString()}')),
        );
      }
    }
  }

  void _resetForm() {
    setState(() {
      _selectedTargetType = 'all';
      _selectedUsers.clear();
      _academicYear = '2023-2024';
      _semester = '1';
      _description = '';
      _selectedFile = null;
    });
    _formKey.currentState?.reset();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Timetable Management'),
        backgroundColor: Colors.blue[800],
      ),
      body: Consumer<TimetableViewModel>(
        builder: (context, viewModel, child) {
          return SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Upload Form
                Card(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Upload New Timetable',
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          SizedBox(height: 16),
                          
                          // File Picker
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(vertical: 16),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              children: [
                                Icon(Icons.upload_file, size: 48, color: Colors.grey),
                                SizedBox(height: 8),
                                Text(
                                  _selectedFile?.name ?? 'No file selected',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 8),
                                ElevatedButton(
                                  onPressed: _pickFile,
                                  child: Text('Choose PDF File'),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 16),

                          // Target Type
                          DropdownButtonFormField<String>(
                            value: _selectedTargetType,
                            decoration: InputDecoration(
                              labelText: 'Target Audience',
                              border: OutlineInputBorder(),
                            ),
                            items: [
                              DropdownMenuItem(value: 'all', child: Text('All Users')),
                              DropdownMenuItem(value: 'student', child: Text('Students')),
                              DropdownMenuItem(value: 'professor', child: Text('Professors')),
                              DropdownMenuItem(value: 'specific', child: Text('Specific Users')),
                            ],
                            onChanged: (value) {
                              setState(() {
                                _selectedTargetType = value!;
                                _selectedUsers.clear();
                              });
                            },
                          ),
                          SizedBox(height: 16),

                          // Academic Year
                          DropdownButtonFormField<String>(
                            value: _academicYear,
                            decoration: InputDecoration(
                              labelText: 'Academic Year',
                              border: OutlineInputBorder(),
                            ),
                            items: [
                              DropdownMenuItem(value: '2023-2024', child: Text('2023-2024')),
                              DropdownMenuItem(value: '2024-2025', child: Text('2024-2025')),
                            ],
                            onChanged: (value) {
                              setState(() {
                                _academicYear = value!;
                              });
                            },
                          ),
                          SizedBox(height: 16),

                          // Semester
                          DropdownButtonFormField<String>(
                            value: _semester,
                            decoration: InputDecoration(
                              labelText: 'Semester',
                              border: OutlineInputBorder(),
                            ),
                            items: [
                              DropdownMenuItem(value: '1', child: Text('Semester 1')),
                              DropdownMenuItem(value: '2', child: Text('Semester 2')),
                            ],
                            onChanged: (value) {
                              setState(() {
                                _semester = value!;
                              });
                            },
                          ),
                          SizedBox(height: 16),

                          // Description
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Description',
                              border: OutlineInputBorder(),
                            ),
                            maxLines: 3,
                            onChanged: (value) {
                              _description = value;
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a description';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 20),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton(
                                onPressed: _resetForm,
                                child: Text('Cancel'),
                              ),
                              SizedBox(width: 8),
                              ElevatedButton(
                                onPressed: viewModel.isLoading ? null : _uploadTimetable,
                                child: viewModel.isLoading
                                    ? CircularProgressIndicator(strokeWidth: 2)
                                    : Text('Upload'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 24),

                // Existing Timetables
                Card(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Existing Timetables',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        SizedBox(height: 16),
                        
                        if (viewModel.isLoading)
                          Center(child: CircularProgressIndicator())
                        else if (viewModel.timetables.isEmpty)
                          Center(
                            child: Text(
                              'No timetables found',
                              style: TextStyle(fontSize: 16, color: Colors.grey),
                            ),
                          )
                        else
                          ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: viewModel.timetables.length,
                            itemBuilder: (context, index) {
                              final timetable = viewModel.timetables[index];
                              return _buildTimetableCard(timetable, viewModel);
                            },
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildTimetableCard(TimetableModel timetable, TimetableViewModel viewModel) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        leading: Icon(Icons.picture_as_pdf, color: Colors.red),
        title: Text(timetable.fileName),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(timetable.description),
            Text(
              '${timetable.academicYear} - Semester ${timetable.semester}',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            Text(
              'Target: ${timetable.targetType}',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
        trailing: PopupMenuButton(
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 'delete',
              child: ListTile(
                leading: Icon(Icons.delete, color: Colors.red),
                title: Text('Delete'),
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ],
          onSelected: (value) async {
            if (value == 'delete') {
              final confirmed = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Confirm Delete'),
                  content: Text('Are you sure you want to delete this timetable?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: Text('Delete', style: TextStyle(color: Colors.red)),
                    ),
                  ],
                ),
              );
              
              if (confirmed == true) {
                await viewModel.deleteTimetable(timetable.id);
              }
            }
          },
        ),
      ),
    );
  }
}
