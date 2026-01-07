import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/professor_session_view_model.dart';
import '../models/professor_session_model.dart';
import '../models/user_model.dart';

class ProfessorSessionView extends StatefulWidget {
  @override
  _ProfessorSessionViewState createState() => _ProfessorSessionViewState();
}

class _ProfessorSessionViewState extends State<ProfessorSessionView> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProfessorSessionViewModel>().loadProfessorsOverview(_selectedDate);
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Professor Sessions'),
        backgroundColor: Colors.blue[800],
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'Overview'),
            Tab(text: 'Schedule'),
            Tab(text: 'Analytics'),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.calendar_today),
            onPressed: () => _selectDate(context),
          ),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildOverviewTab(),
          _buildScheduleTab(),
          _buildAnalyticsTab(),
        ],
      ),
    );
  }

  Widget _buildOverviewTab() {
    return Consumer<ProfessorSessionViewModel>(
      builder: (context, viewModel, child) {
        return Column(
          children: [
            // Date Selector
            Container(
              padding: EdgeInsets.all(16),
              child: Card(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Icon(Icons.date_range),
                      SizedBox(width: 12),
                      Text(
                        'Date: ${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Spacer(),
                      ElevatedButton(
                        onPressed: () => _selectDate(context),
                        child: Text('Change Date'),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Overview Cards
            if (viewModel.isLoading)
              Expanded(child: Center(child: CircularProgressIndicator()))
            else if (viewModel.professorsOverview.isEmpty)
              Expanded(
                child: Center(
                  child: Text(
                    'No professors found',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ),
              )
            else
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.all(16),
                  itemCount: viewModel.professorsOverview.length,
                  itemBuilder: (context, index) {
                    final overview = viewModel.professorsOverview[index];
                    return _buildProfessorOverviewCard(overview, viewModel);
                  },
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _buildScheduleTab() {
    return Consumer<ProfessorSessionViewModel>(
      builder: (context, viewModel, child) {
        return Column(
          children: [
            // Add Session Button
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(16),
              child: ElevatedButton.icon(
                onPressed: () => _showAddSessionDialog(),
                icon: Icon(Icons.add),
                label: Text('Add Session'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),

            // Sessions List
            Expanded(
              child: viewModel.isLoading
                  ? Center(child: CircularProgressIndicator())
                  : viewModel.sessions.isEmpty
                      ? Center(
                          child: Text(
                            'No sessions scheduled for this date',
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                        )
                      : ListView.builder(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          itemCount: viewModel.sessions.length,
                          itemBuilder: (context, index) {
                            final session = viewModel.sessions[index];
                            return _buildSessionCard(session, viewModel);
                          },
                        ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildAnalyticsTab() {
    return Consumer<ProfessorSessionViewModel>(
      builder: (context, viewModel, child) {
        return SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              // Summary Cards
              Row(
                children: [
                  Expanded(
                    child: _buildAnalyticsCard(
                      'Total Professors',
                      viewModel.professorsOverview.length.toString(),
                      Icons.people,
                      Colors.blue,
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: _buildAnalyticsCard(
                      'With Sessions',
                      viewModel.professorsOverview
                          .where((p) => p.hasSession)
                          .length
                          .toString(),
                      Icons.check_circle,
                      Colors.green,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildAnalyticsCard(
                      'Without Sessions',
                      viewModel.professorsOverview
                          .where((p) => !p.hasSession)
                          .length
                          .toString(),
                      Icons.cancel,
                      Colors.red,
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: _buildAnalyticsCard(
                      'Total Hours',
                      viewModel.professorsOverview
                          .fold(0.0, (sum, p) => sum + p.totalHours)
                          .toStringAsFixed(1),
                      Icons.access_time,
                      Colors.orange,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24),

              // Professors without sessions
              Card(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Professors Without Sessions Today',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      SizedBox(height: 12),
                      ...viewModel.professorsOverview
                          .where((p) => !p.hasSession)
                          .map((professor) => ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: Colors.red[100],
                                  child: Icon(Icons.person, color: Colors.red),
                                ),
                                title: Text(professor.professor.name),
                                subtitle: Text(professor.professor.email),
                                trailing: Text(
                                  'No sessions',
                                  style: TextStyle(color: Colors.red),
                                ),
                              ))
                          .toList(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildProfessorOverviewCard(ProfessorOverview overview, ProfessorSessionViewModel viewModel) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 4),
      child: ExpansionTile(
        leading: CircleAvatar(
          backgroundColor: overview.hasSession ? Colors.green[100] : Colors.red[100],
          child: Icon(
            overview.hasSession ? Icons.check : Icons.close,
            color: overview.hasSession ? Colors.green : Colors.red,
          ),
        ),
        title: Text(
          overview.professor.name,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(overview.professor.email),
            Text(
              'Sessions: ${overview.sessionCount} | Hours: ${overview.totalHours.toStringAsFixed(1)}',
              style: TextStyle(fontSize: 12),
            ),
          ],
        ),
        children: overview.sessions.map((session) {
          return ListTile(
            dense: true,
            leading: Icon(Icons.schedule, size: 20),
            title: Text('${session.startTime} - ${session.endTime}'),
            subtitle: Text(session.subject ?? 'No subject'),
            trailing: Text(session.room ?? 'No room'),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildSessionCard(ProfessorSessionModel session, ProfessorSessionViewModel viewModel) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _getSessionStatusColor(session.status),
          child: Icon(Icons.schedule, color: Colors.white),
        ),
        title: Text('${session.startTime} - ${session.endTime}'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(session.professor?.name ?? 'Unknown Professor'),
            Text(session.subject ?? 'No subject'),
            if (session.room != null) Text('Room: ${session.room}'),
          ],
        ),
        trailing: PopupMenuButton(
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 'edit',
              child: ListTile(
                leading: Icon(Icons.edit),
                title: Text('Edit'),
                contentPadding: EdgeInsets.zero,
              ),
            ),
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
              await _confirmDeleteSession(session, viewModel);
            } else if (value == 'edit') {
              _showEditSessionDialog(session);
            }
          },
        ),
      ),
    );
  }

  Widget _buildAnalyticsCard(String title, String value, IconData icon, Color color) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 24),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getSessionStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'completed':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      case 'ongoing':
        return Colors.orange;
      default:
        return Colors.blue;
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now().subtract(Duration(days: 365)),
      lastDate: DateTime.now().add(Duration(days: 365)),
    );
    
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
      context.read<ProfessorSessionViewModel>().loadProfessorsOverview(_selectedDate);
    }
  }

  void _showAddSessionDialog() {
    // Implementation for adding a new session
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add Session'),
        content: Text('Session creation form would go here'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Add'),
          ),
        ],
      ),
    );
  }

  void _showEditSessionDialog(ProfessorSessionModel session) {
    // Implementation for editing a session
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit Session'),
        content: Text('Session editing form would go here'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Save'),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmDeleteSession(ProfessorSessionModel session, ProfessorSessionViewModel viewModel) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirm Delete'),
        content: Text('Are you sure you want to delete this session?'),
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
      await viewModel.deleteSession(session.id);
    }
  }
}
