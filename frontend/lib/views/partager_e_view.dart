import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/partager_e_viewmodel.dart';
import '../models/upload_request_e_model.dart';
import '../core/constants/app_colors.dart';

class UploadDocumentPage extends StatefulWidget {
  const UploadDocumentPage({super.key});

  @override
  State<UploadDocumentPage> createState() => _UploadDocumentPageState();
}

class _UploadDocumentPageState extends State<UploadDocumentPage> {
  final descCtrl = TextEditingController();
  String? selClass;

  @override
  void dispose() {
    descCtrl.dispose();
    super.dispose();
  }

  void _onPublish(PartagerViewModel vm) async {
    if (selClass == null || vm.fileName == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Veuillez sélectionner une classe et choisir un document")),
      );
      return;
    }

    final request = UploadRequest(
      title: vm.fileName!,
      targetClass: selClass!,
      description: descCtrl.text,
    );

    final success = await vm.uploadDocument(request);
    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Document publié avec succès !"), backgroundColor: Colors.green));
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Erreur lors de la publication"), backgroundColor: Colors.red));
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => PartagerViewModel(),
      child: Consumer<PartagerViewModel>(
        builder: (context, vm, _) => Scaffold(
          backgroundColor: AppColors.backgroundMint,
          appBar: AppBar(
            title: const Text("Publier un document", style: TextStyle(color: Colors.white)),
            backgroundColor: AppColors.primaryPink,
            elevation: 0,
            iconTheme: const IconThemeData(color: Colors.white),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildUploadArea(vm),
                const SizedBox(height: 20),
                _buildForm(vm),
                const SizedBox(height: 30),
                _buildButton(vm),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildForm(PartagerViewModel vm) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text("À quelle classe", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
      const SizedBox(height: 8),
      DropdownButtonFormField<String>(
        decoration: const InputDecoration(
          hintText: "Sélectionner une classe",
          border: OutlineInputBorder(),
          filled: true,
          fillColor: Colors.white,
        ),
        items: vm.classes.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
        onChanged: (v) => setState(() => selClass = v),
      ),
      const SizedBox(height: 20),
      const Text("Détails supplémentaires", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
      const SizedBox(height: 8),
      TextField(
        controller: descCtrl, 
        maxLines: 4, 
        decoration: const InputDecoration(
          hintText: "Spécifiez des informations supplémentaires si nécessaire...",
          border: OutlineInputBorder(),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
    ],
  );

  Widget _buildUploadArea(PartagerViewModel vm) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text("Sélectionner le document", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
      const SizedBox(height: 8),
      GestureDetector(
        onTap: vm.pickFile,
        child: Container(
          height: 120, width: double.infinity,
          decoration: BoxDecoration(
            border: Border.all(color: vm.fileName == null ? Colors.grey : Colors.green, width: 2),
            borderRadius: BorderRadius.circular(10),
            color: vm.fileName == null ? Colors.white : Colors.green[50],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(vm.fileName == null ? Icons.cloud_upload : Icons.check_circle, size: 40, color: vm.fileName == null ? AppColors.primaryPink : Colors.green),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  vm.fileName ?? "Appuyez pour choisir un document",
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
              ),
            ],
          ),
        ),
      ),
    ],
  );

  Widget _buildButton(PartagerViewModel vm) => SizedBox(
    width: double.infinity, height: 50,
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryPink),
      onPressed: vm.isSubmitting ? null : () => _onPublish(vm),
      child: vm.isSubmitting ? const CircularProgressIndicator(color: Colors.white) : const Text("PUBLIER", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 17)),
    ),
  );
}