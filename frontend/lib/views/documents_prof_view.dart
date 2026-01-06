import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/document_e_viewmodel.dart';
import '../models/document_e_model.dart';
import '../core/constants/app_colors.dart';
import 'partager_e_view.dart';
import 'voir_e_view.dart';

class DocumentsProfView extends StatefulWidget {
  const DocumentsProfView({super.key});

  @override
  State<DocumentsProfView> createState() => _DocumentsProfViewState();
}

class _DocumentsProfViewState extends State<DocumentsProfView> {
  @override
  void initState() {
    super.initState();
    // Charger les documents au démarrage
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DocumentViewModel>().fetchDocuments();
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<DocumentViewModel>();

    return Scaffold(
      backgroundColor: AppColors.backgroundMint,
      appBar: AppBar(
        backgroundColor: AppColors.primaryPink,
        elevation: 0,
        title: const Text("Documents", 
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          // --- FILTRES (ONGLETS) ---
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: viewModel.categories.map((cat) {
                  return _buildPillTab(cat, viewModel);
                }).toList(),
              ),
            ),
          ),
          
          // --- LISTE DES DOCUMENTS ---
          Expanded(
            child: viewModel.isLoading
                ? const Center(child: CircularProgressIndicator())
                : viewModel.filteredDocuments.isEmpty
                    ? const Center(child: Text("Aucun document trouvé."))
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: viewModel.filteredDocuments.length,
                        itemBuilder: (context, index) {
                          final doc = viewModel.filteredDocuments[index];
                          return _buildDocumentCard(doc, viewModel, context);
                        },
                      ),
          ),
        ],
      ),
      
      // --- BOUTON DE PUBLICATION ---
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: () async {
            final result = await Navigator.push(
              context, 
              MaterialPageRoute(builder: (context) => const UploadDocumentPage())
            );
            if (result == true) {
              // Refresh documents after upload
              context.read<DocumentViewModel>().fetchDocuments();
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryPink,
            padding: const EdgeInsets.symmetric(vertical: 15),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          child: const Text("Publier un document", 
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }

  Widget _buildPillTab(String text, DocumentViewModel vm) {
    bool isSelected = vm.selectedCategory == text;
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: GestureDetector(
        onTap: () => vm.setCategory(text),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primaryPink : Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: isSelected ? AppColors.primaryPink : Colors.grey.shade300),
          ),
          child: Text(
            text,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.grey[700],
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDocumentCard(SchoolDocument doc, DocumentViewModel vm, BuildContext context) {
    return GestureDetector(
      onTap: () {
        // NAVIGATION VERS LA PAGE DE DÉTAIL
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VoirDocumentPage(document: doc),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12.0),
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05), 
              blurRadius: 8, 
              offset: const Offset(0, 2)
            )
          ],
        ),
        child: Row(
          children: [
            Icon(vm.getIconForCategory(doc.category), color: AppColors.primaryPink, size: 28),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(doc.title, 
                      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text("${doc.fileType} | ${doc.fileSize}", 
                          style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.primaryPink.withOpacity(0.1), 
                          borderRadius: BorderRadius.circular(5)
                        ),
                        child: Text(doc.category, 
                            style: const TextStyle(
                              fontSize: 10, 
                              color: AppColors.primaryPink, 
                              fontWeight: FontWeight.bold
                            )),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 16),
          ],
        ),
      ),
    );
  }
}
