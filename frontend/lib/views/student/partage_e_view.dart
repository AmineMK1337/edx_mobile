import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../viewmodels/student/partage_e_viewmodel.dart';
import '../../core/constants/app_colors.dart';
import 'partager_e_view.dart';

class PartageDocumentsPage extends StatefulWidget {
  const PartageDocumentsPage({super.key});

  @override
  State<PartageDocumentsPage> createState() => _PartageDocumentsPageState();
}

class _PartageDocumentsPageState extends State<PartageDocumentsPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PartageViewModel>().fetchDocuments();
    });
  }

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Impossible d'ouvrir le fichier : $url")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<PartageViewModel>();

    return Scaffold(
      backgroundColor: AppColors.backgroundMint,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.primaryPink,
        title: const Text("Partage Documents",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: () => viewModel.fetchDocuments(),
          )
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => viewModel.fetchDocuments(),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSearchBar(),
              const SizedBox(height: 20),
              _buildFilters(viewModel),
              const SizedBox(height: 15),
              _buildUploadButton(context, viewModel),
              const SizedBox(height: 25),
              Text(
                "${viewModel.documents.length} document(s) trouvé(s)",
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 10),
              _buildDocumentList(viewModel),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14)),
      child: const TextField(
        decoration: InputDecoration(
          hintText: "Rechercher un document…",
          border: InputBorder.none,
          icon: Icon(Icons.search),
        ),
      ),
    );
  }

  Widget _buildFilters(PartageViewModel vm) {
    return Row(
      children: [
        _buildDropdown(
          value: vm.selectedMatiere,
          items: ["Toutes les matières", "Analyse", "Réseaux", "Programmation C", "Algorithmique"],
          onChanged: (v) => vm.updateMatiere(v!),
        ),
        const SizedBox(width: 12),
        _buildDropdown(
          value: vm.selectedType,
          items: ["Tous les types", "TD", "Examen", "Cours", "TP", "Rapport"],
          onChanged: (v) => vm.updateType(v!),
        ),
      ],
    );
  }

  Widget _buildUploadButton(BuildContext context, PartageViewModel vm) {
    return Center(
      child: ElevatedButton.icon(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const UploadDocumentPage()),
          );
          if (result == true) vm.fetchDocuments();
        },
        icon: const Icon(Icons.add, color: AppColors.primaryPink),
        label: const Text("Publier un document", style: TextStyle(color: AppColors.primaryPink)),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          minimumSize: const Size(200, 45),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }

  Widget _buildDocumentList(PartageViewModel vm) {
    if (vm.isLoading) return const Center(child: CircularProgressIndicator());
    if (vm.documents.isEmpty) return const Center(child: Text("Aucun document partagé."));

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: vm.documents.length,
      itemBuilder: (context, index) {
        final doc = vm.documents[index];
        return _buildDocumentCard(doc);
      },
    );
  }

  Widget _buildDropdown({required String value, required List<String> items, required Function(String?) onChanged}) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: DropdownButton<String>(
          value: items.contains(value) ? value : items[0],
          onChanged: onChanged,
          underline: Container(),
          isExpanded: true,
          items: items.map((e) => DropdownMenuItem(value: e, child: Text(e, overflow: TextOverflow.ellipsis))).toList(),
        ),
      ),
    );
  }

  Widget _buildDocumentCard(dynamic doc) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white, 
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(color: AppColors.primaryPink.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
            child: Text(doc.tag, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primaryPink)),
          ),
          const SizedBox(height: 8),
          Text(doc.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          Text(doc.description),
          Text("${doc.teacher} • ${doc.date}", style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(children: [
                const Icon(Icons.remove_red_eye, size: 18),
                Text(" ${doc.views}"),
                const SizedBox(width: 12),
                const Icon(Icons.star, color: Colors.amber, size: 18),
                Text(" ${doc.note}"),
              ]),
              Row(children: [
                TextButton(onPressed: () => doc.fileUrl != null ? _launchURL(doc.fileUrl!) : null, child: const Text("Voir", style: TextStyle(color: AppColors.primaryPink))),
                ElevatedButton(
                  onPressed: () => doc.fileUrl != null ? _launchURL(doc.fileUrl!) : null,
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryPink, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                  child: const Text("Télécharger", style: TextStyle(color: Colors.white)),
                )
              ])
            ],
          )
        ],
      ),
    );
  }
}