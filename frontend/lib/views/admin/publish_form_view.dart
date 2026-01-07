import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../models/admin/publish_model.dart';

class PublishFormView extends StatefulWidget {
  final List<ExamSession> selectedSessions;
  
  const PublishFormView({super.key, required this.selectedSessions});

  @override
  State<PublishFormView> createState() => _PublishFormViewState();
}

class _PublishFormViewState extends State<PublishFormView> {
  final _notificationController = TextEditingController();
  bool _sendEmail = true;
  bool _sendSMS = false;
  bool _publishOnPortal = true;
  DateTime _publishDate = DateTime.now();

  @override
  void dispose() {
    _notificationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Configuration de publication',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          _buildSessionsSummary(),
          const SizedBox(height: 24),
          _buildNotificationSettings(),
          const SizedBox(height: 24),
          _buildPublishSettings(),
        ],
      ),
    );
  }

  Widget _buildSessionsSummary() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Sessions sélectionnées (${widget.selectedSessions.length})',
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
          ),
          const SizedBox(height: 12),
          ...widget.selectedSessions.take(3).map((session) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: [
                Container(
                  width: 4,
                  height: 4,
                  decoration: const BoxDecoration(
                    color: AppColors.primaryPink,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '${session.subject} - ${session.group} (${session.studentCount} étudiants)',
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
              ],
            ),
          )),
          if (widget.selectedSessions.length > 3)
            Text(
              '... et ${widget.selectedSessions.length - 3} autre(s)',
              style: TextStyle(color: Colors.grey[600], fontSize: 13),
            ),
        ],
      ),
    );
  }

  Widget _buildNotificationSettings() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Notifications aux étudiants',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
          ),
          const SizedBox(height: 16),
          SwitchListTile(
            title: const Text('Email'),
            subtitle: const Text('Envoyer par email'),
            value: _sendEmail,
            onChanged: (value) {
              setState(() {
                _sendEmail = value;
              });
            },
            activeColor: AppColors.primaryPink,
          ),
          SwitchListTile(
            title: const Text('SMS'),
            subtitle: const Text('Envoyer par SMS'),
            value: _sendSMS,
            onChanged: (value) {
              setState(() {
                _sendSMS = value;
              });
            },
            activeColor: AppColors.primaryPink,
          ),
          const SizedBox(height: 16),
          const Text(
            'Message personnalisé (optionnel)',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _notificationController,
            maxLines: 3,
            decoration: InputDecoration(
              hintText: 'Message à inclure dans la notification...',
              filled: true,
              fillColor: Colors.grey[100],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPublishSettings() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Paramètres de publication',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
          ),
          const SizedBox(height: 16),
          SwitchListTile(
            title: const Text('Publier sur le portail étudiant'),
            subtitle: const Text('Visible immédiatement sur le portail'),
            value: _publishOnPortal,
            onChanged: (value) {
              setState(() {
                _publishOnPortal = value;
              });
            },
            activeColor: AppColors.primaryPink,
          ),
          const SizedBox(height: 16),
          const Text(
            'Date de publication',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          InkWell(
            onTap: () async {
              final date = await showDatePicker(
                context: context,
                initialDate: _publishDate,
                firstDate: DateTime.now(),
                lastDate: DateTime.now().add(const Duration(days: 365)),
              );
              if (date != null) {
                final time = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.fromDateTime(_publishDate),
                );
                if (time != null) {
                  setState(() {
                    _publishDate = DateTime(
                      date.year,
                      date.month,
                      date.day,
                      time.hour,
                      time.minute,
                    );
                  });
                }
              }
            },
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: Row(
                children: [
                  const Icon(Icons.schedule, color: AppColors.primaryPink),
                  const SizedBox(width: 12),
                  Text(
                    '${_publishDate.day}/${_publishDate.month}/${_publishDate.year} à ${_publishDate.hour.toString().padLeft(2, '0')}:${_publishDate.minute.toString().padLeft(2, '0')}',
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
