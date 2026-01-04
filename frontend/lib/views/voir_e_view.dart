import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/document_e_model.dart';
import '../viewmodels/voir_document_e_viewmodel.dart';

class VoirDocumentPage extends StatelessWidget {
  final SchoolDocument document;

  const VoirDocumentPage({
    super.key,
    required this.document,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => VoirDocumentViewModel(),
      child: Consumer<VoirDocumentViewModel>(
        builder: (context, viewModel, child) {
          return Scaffold(
            appBar: AppBar(
              title: Text(document.title, style: const TextStyle(color: Colors.white)),
              backgroundColor: const Color.fromARGB(255, 64, 179, 255),
              iconTheme: const IconThemeData(color: Colors.white),
            ),
            body: Column(
              children: [
                // ---- DOCUMENT PREVIEW ----
                Container(
                  height: 260,
                  width: double.infinity,
                  color: Colors.grey.shade300,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.picture_as_pdf, size: 70, color: Colors.red),
                        const SizedBox(height: 10),
                        Text(document.fileType, style: const TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),

                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          document.title,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          "Par : ${document.author}",
                          style: const TextStyle(color: Colors.grey),
                        ),
                        Text(
                          "Ajouté le : ${document.date} (${document.fileSize})",
                          style: const TextStyle(color: Colors.grey),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          "Description",
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          document.description,
                          style: const TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ),

                // ---- DOWNLOAD BUTTON ----
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(18),
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    icon: viewModel.isDownloading 
                        ? const SizedBox(
                            width: 20, 
                            height: 20, 
                            child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
                          )
                        : const Icon(Icons.download, color: Colors.white),
                    label: Text(
                      viewModel.isDownloading ? "Téléchargement..." : "Télécharger",
                      style: const TextStyle(fontSize: 17, color: Colors.white),
                    ),
                    onPressed: viewModel.isDownloading 
                        ? null 
                        : () => viewModel.downloadFile(document.id),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}