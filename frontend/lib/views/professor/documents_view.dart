import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../models/professor/document_model.dart';
import '../../viewmodels/professor/documents_viewmodel.dart';

class DocumentsView extends StatelessWidget {
  final String courseId;
  final String courseName;

  const DocumentsView({
    super.key,
    required this.courseId,
    required this.courseName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundMint,
      appBar: AppBar(
        backgroundColor: AppColors.primaryPink,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Documents', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            Text(courseName, style: const TextStyle(color: Colors.white70, fontSize: 12)),
          ],
        ),
      ),
      body: ChangeNotifierProvider(
        create: (_) => DocumentsViewModel(courseId: courseId),
        child: Consumer<DocumentsViewModel>(
          builder: (context, viewModel, _) {
            if (viewModel.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (viewModel.error != null) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, size: 48, color: Colors.red),
                    const SizedBox(height: 16),
                    Text(viewModel.error!),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: viewModel.fetchDocuments,
                      child: const Text('Réessayer'),
                    )
                  ],
                ),
              );
            }

            if (viewModel.documents.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.folder_open_outlined, size: 64, color: Colors.grey[400]),
                    const SizedBox(height: 16),
                    Text(
                      'Aucun document',
                      style: TextStyle(color: Colors.grey[600], fontSize: 18),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Les documents du cours apparaîtront ici',
                      style: TextStyle(color: Colors.grey[500], fontSize: 14),
                    ),
                  ],
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: viewModel.documents.length,
              itemBuilder: (context, index) {
                final document = viewModel.documents[index];
                return _buildDocumentCard(context, document, viewModel);
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildDocumentCard(BuildContext context, DocumentModel document, DocumentsViewModel viewModel) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
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
          // File Icon
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: _getFileTypeColor(document.fileType),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(_getFileTypeIcon(document.fileType), color: Colors.white),
          ),
          const SizedBox(width: 16),
          // Document Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  document.title,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.calendar_today_outlined, size: 12, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Text(
                      document.formattedDate,
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    ),
                    const SizedBox(width: 12),
                    Icon(Icons.download_outlined, size: 12, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Text(
                      '${document.downloads}',
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Download Button
          IconButton(
            icon: const Icon(Icons.download_outlined, color: AppColors.primaryPink),
            onPressed: () => viewModel.downloadDocument(document),
          ),
        ],
      ),
    );
  }

  Color _getFileTypeColor(String fileType) {
    switch (fileType.toLowerCase()) {
      case 'pdf':
        return Colors.red;
      case 'doc':
      case 'docx':
        return Colors.blue;
      case 'xls':
      case 'xlsx':
        return Colors.green;
      case 'ppt':
      case 'pptx':
        return Colors.orange;
      case 'image':
      case 'jpg':
      case 'png':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  IconData _getFileTypeIcon(String fileType) {
    switch (fileType.toLowerCase()) {
      case 'pdf':
        return Icons.picture_as_pdf;
      case 'doc':
      case 'docx':
        return Icons.description;
      case 'xls':
      case 'xlsx':
        return Icons.table_chart;
      case 'ppt':
      case 'pptx':
        return Icons.slideshow;
      case 'image':
      case 'jpg':
      case 'png':
        return Icons.image;
      default:
        return Icons.insert_drive_file;
    }
  }
}
