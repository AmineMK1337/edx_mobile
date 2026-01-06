import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/student/ticket_e_viewmodel.dart';
import '../../core/constants/app_colors.dart';

class CreateTicketScreen extends StatefulWidget {
  const CreateTicketScreen({super.key});

  @override
  State<CreateTicketScreen> createState() => _CreateTicketScreenState();
}

class _CreateTicketScreenState extends State<CreateTicketScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  
  // Document request controllers
  String? _selectedDocumentType;
  final _docSubjectController = TextEditingController();
  final _docMessageController = TextEditingController();
  
  // Exam review controllers
  final _courseNameController = TextEditingController();
  final _currentMarkController = TextEditingController();
  final _examSubjectController = TextEditingController();
  final _examMessageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _docSubjectController.dispose();
    _docMessageController.dispose();
    _courseNameController.dispose();
    _currentMarkController.dispose();
    _examSubjectController.dispose();
    _examMessageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TicketViewModel(),
      child: Consumer<TicketViewModel>(
        builder: (context, viewModel, _) => Scaffold(
          backgroundColor: AppColors.backgroundMint,
          appBar: AppBar(
            backgroundColor: AppColors.primaryPink,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: const Text(
              'Nouvelle Demande',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            bottom: TabBar(
              controller: _tabController,
              indicatorColor: Colors.white,
              indicatorWeight: 3,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white70,
              tabs: const [
                Tab(
                  icon: Icon(Icons.description),
                  text: 'Document',
                ),
                Tab(
                  icon: Icon(Icons.rate_review),
                  text: 'Révision Copie',
                ),
              ],
            ),
          ),
          body: TabBarView(
            controller: _tabController,
            children: [
              _buildDocumentRequestForm(viewModel),
              _buildExamReviewForm(viewModel),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDocumentRequestForm(TicketViewModel viewModel) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.blue.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline, color: Colors.blue[700]),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Demandez un document administratif. Votre demande sera traitée dans les plus brefs délais.',
                    style: TextStyle(color: Colors.blue[700], fontSize: 13),
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Document type dropdown
          const Text(
            'Type de document *',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            decoration: const InputDecoration(
              hintText: 'Sélectionnez le type de document',
              border: OutlineInputBorder(),
              filled: true,
              fillColor: Colors.white,
            ),
            value: _selectedDocumentType,
            items: viewModel.documentTypes.map((type) {
              return DropdownMenuItem(
                value: type['value'],
                child: Text(type['label']!),
              );
            }).toList(),
            onChanged: (value) => setState(() => _selectedDocumentType = value),
          ),
          
          const SizedBox(height: 20),
          
          // Subject field
          const Text(
            'Objet *',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _docSubjectController,
            decoration: const InputDecoration(
              hintText: 'Ex: Demande d\'attestation de présence',
              border: OutlineInputBorder(),
              filled: true,
              fillColor: Colors.white,
            ),
          ),
          
          const SizedBox(height: 20),
          
          // Message field
          const Text(
            'Message / Détails',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _docMessageController,
            maxLines: 4,
            decoration: const InputDecoration(
              hintText: 'Précisez votre demande (motif, nombre de copies, etc.)',
              border: OutlineInputBorder(),
              filled: true,
              fillColor: Colors.white,
            ),
          ),
          
          const SizedBox(height: 30),
          
          // Submit button
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryPink,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: viewModel.isSubmitting ? null : () => _submitDocumentRequest(viewModel),
              child: viewModel.isSubmitting
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                    )
                  : const Text(
                      'Soumettre la demande',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExamReviewForm(TicketViewModel viewModel) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.orange.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.orange.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline, color: Colors.orange[700]),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Demandez une révision de votre copie d\'examen si vous pensez qu\'il y a une erreur dans la notation.',
                    style: TextStyle(color: Colors.orange[700], fontSize: 13),
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Course name field
          const Text(
            'Matière / Cours *',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _courseNameController,
            decoration: const InputDecoration(
              hintText: 'Ex: Programmation C, Analyse, etc.',
              border: OutlineInputBorder(),
              filled: true,
              fillColor: Colors.white,
            ),
          ),
          
          const SizedBox(height: 20),
          
          // Current mark field
          const Text(
            'Note actuelle *',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _currentMarkController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              hintText: 'Ex: 12.5',
              border: OutlineInputBorder(),
              filled: true,
              fillColor: Colors.white,
              suffixText: '/ 20',
            ),
          ),
          
          const SizedBox(height: 20),
          
          // Subject field
          const Text(
            'Objet *',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _examSubjectController,
            decoration: const InputDecoration(
              hintText: 'Ex: Demande de révision - Examen de mi-semestre',
              border: OutlineInputBorder(),
              filled: true,
              fillColor: Colors.white,
            ),
          ),
          
          const SizedBox(height: 20),
          
          // Message field
          const Text(
            'Justification *',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _examMessageController,
            maxLines: 4,
            decoration: const InputDecoration(
              hintText: 'Expliquez pourquoi vous pensez que votre note devrait être révisée...',
              border: OutlineInputBorder(),
              filled: true,
              fillColor: Colors.white,
            ),
          ),
          
          const SizedBox(height: 30),
          
          // Submit button
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryPink,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: viewModel.isSubmitting ? null : () => _submitExamReview(viewModel),
              child: viewModel.isSubmitting
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                    )
                  : const Text(
                      'Soumettre la demande',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  void _submitDocumentRequest(TicketViewModel viewModel) async {
    if (_selectedDocumentType == null) {
      _showError('Veuillez sélectionner un type de document');
      return;
    }
    if (_docSubjectController.text.trim().isEmpty) {
      _showError('Veuillez entrer un objet');
      return;
    }

    final success = await viewModel.createDocumentRequest(
      documentType: _selectedDocumentType!,
      subject: _docSubjectController.text.trim(),
      message: _docMessageController.text.trim(),
    );

    if (mounted) {
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Demande envoyée avec succès !'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context, true);
      } else {
        _showError(viewModel.error ?? 'Erreur lors de l\'envoi');
      }
    }
  }

  void _submitExamReview(TicketViewModel viewModel) async {
    if (_courseNameController.text.trim().isEmpty) {
      _showError('Veuillez entrer le nom du cours');
      return;
    }
    if (_currentMarkController.text.trim().isEmpty) {
      _showError('Veuillez entrer votre note actuelle');
      return;
    }
    if (_examSubjectController.text.trim().isEmpty) {
      _showError('Veuillez entrer un objet');
      return;
    }
    if (_examMessageController.text.trim().isEmpty) {
      _showError('Veuillez fournir une justification');
      return;
    }

    final mark = double.tryParse(_currentMarkController.text.trim());
    if (mark == null || mark < 0 || mark > 20) {
      _showError('Veuillez entrer une note valide (0-20)');
      return;
    }

    final success = await viewModel.createExamReviewRequest(
      courseName: _courseNameController.text.trim(),
      currentMark: mark,
      subject: _examSubjectController.text.trim(),
      message: _examMessageController.text.trim(),
    );

    if (mounted) {
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Demande de révision envoyée avec succès !'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context, true);
      } else {
        _showError(viewModel.error ?? 'Erreur lors de l\'envoi');
      }
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }
}
