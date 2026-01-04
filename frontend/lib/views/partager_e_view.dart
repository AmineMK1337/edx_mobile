import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/partager_e_viewmodel.dart';
import '../models/upload_request_e_model.dart';

class UploadDocumentPage extends StatefulWidget {
  const UploadDocumentPage({super.key});

  @override
  State<UploadDocumentPage> createState() => _UploadDocumentPageState();
}

class _UploadDocumentPageState extends State<UploadDocumentPage> {
  final titleCtrl = TextEditingController();
  final descCtrl = TextEditingController();
  String? selType;
  String? selSub;

  @override
  void dispose() {
    titleCtrl.dispose();
    descCtrl.dispose();
    super.dispose();
  }

  void _onPublish(PartagerViewModel vm) async {
    if (titleCtrl.text.isEmpty || selSub == null || selType == null || vm.fileName == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Veuillez remplir tous les champs et choisir un PDF")),
      );
      return;
    }

    final request = UploadRequest(
      title: titleCtrl.text,
      subject: selSub!,
      tag: selType!,
      description: descCtrl.text,
    );

    final success = await vm.uploadDocument(request);
    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Succès !"), backgroundColor: Colors.green));
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Erreur d'envoi"), backgroundColor: Colors.red));
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => PartagerViewModel(),
      child: Consumer<PartagerViewModel>(
        builder: (context, vm, _) => Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: const Text("Partager un document", style: TextStyle(color: Colors.white)),
            backgroundColor: const Color.fromARGB(255, 64, 179, 255),
            iconTheme: const IconThemeData(color: Colors.white),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                _buildForm(vm),
                const SizedBox(height: 20),
                _buildUploadArea(vm),
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
    children: [
      TextField(controller: titleCtrl, decoration: const InputDecoration(labelText: "Titre", border: OutlineInputBorder())),
      const SizedBox(height: 15),
      DropdownButtonFormField<String>(
        decoration: const InputDecoration(labelText: "Matière", border: OutlineInputBorder()),
        items: vm.subjects.map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
        onChanged: (v) => selSub = v,
      ),
      const SizedBox(height: 15),
      DropdownButtonFormField<String>(
        decoration: const InputDecoration(labelText: "Type", border: OutlineInputBorder()),
        items: vm.types.map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
        onChanged: (v) => selType = v,
      ),
      const SizedBox(height: 15),
      TextField(controller: descCtrl, maxLines: 2, decoration: const InputDecoration(labelText: "Description", border: OutlineInputBorder())),
    ],
  );

  Widget _buildUploadArea(PartagerViewModel vm) => GestureDetector(
    onTap: vm.pickFile,
    child: Container(
      height: 120, width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(color: vm.fileName == null ? Colors.grey : Colors.green, width: 2),
        borderRadius: BorderRadius.circular(10),
        color: vm.fileName == null ? Colors.grey[50] : Colors.green[50],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(vm.fileName == null ? Icons.cloud_upload : Icons.check_circle, size: 40, color: vm.fileName == null ? Colors.blue : Colors.green),
          const SizedBox(height: 8),
          Text(vm.fileName ?? "Appuyez pour choisir le PDF"),
        ],
      ),
    ),
  );

  Widget _buildButton(PartagerViewModel vm) => SizedBox(
    width: double.infinity, height: 50,
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
      onPressed: vm.isSubmitting ? null : () => _onPublish(vm),
      child: vm.isSubmitting ? const CircularProgressIndicator(color: Colors.white) : const Text("PUBLIER", style: TextStyle(color: Colors.white)),
    ),
  );
}