import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/doc_request_e_model.dart';
import '../viewmodels/demandedoc_e_viewmodel.dart';

class DemanderDocumentScreen extends StatefulWidget {
  const DemanderDocumentScreen({super.key});

  @override
  State<DemanderDocumentScreen> createState() => _DemanderDocumentScreenState();
}

class _DemanderDocumentScreenState extends State<DemanderDocumentScreen> {
  String? _selectedType;
  final TextEditingController _raisonController = TextEditingController();
  final TextEditingController _detailsController = TextEditingController();

  @override
  void dispose() {
    _raisonController.dispose();
    _detailsController.dispose();
    super.dispose();
  }

  void _handleSubmission(DemandeDocViewModel vm) async {
    final request = DocRequest(
      studentId: "STUDENT_123", // ID Statique pour le moment
      studentName: "Etudiant Test",
      documentType: _selectedType ?? vm.documentTypes[0],
      comment: "Raison: ${_raisonController.text} | Détails: ${_detailsController.text}",
    );

    final success = await vm.submitRequest(request);

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Demande envoyée !"), backgroundColor: Colors.green),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Échec de l'envoi"), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryBlue = Color.fromARGB(255, 64, 179, 255);
    const Color primaryRed = Color.fromARGB(255, 183, 27, 13);

    return ChangeNotifierProvider(
      create: (_) => DemandeDocViewModel(),
      child: Consumer<DemandeDocViewModel>(
        builder: (context, vm, _) {
          return Scaffold(
            backgroundColor: Colors.grey[100],
            appBar: AppBar(
              backgroundColor: primaryBlue,
              title: const Text("Demander un Document", 
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              iconTheme: const IconThemeData(color: Colors.white),
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Type de document", style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  _buildDropdownField(vm, primaryBlue),
                  const SizedBox(height: 20),
                  
                  const Text("Raison (optionnel)", style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  _buildInputField(_raisonController, "Ex: Inscription master...", 2, primaryBlue),
                  const SizedBox(height: 20),
                  
                  const Text("Détails supplémentaires", style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  _buildInputField(_detailsController, "Spécifiez si besoin...", 4, primaryBlue),
                  const SizedBox(height: 30),

                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: vm.isSubmitting ? null : () => _handleSubmission(vm),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryRed,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      child: vm.isSubmitting
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text("Soumettre la Demande", 
                              style: TextStyle(fontSize: 17, color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDropdownField(DemandeDocViewModel vm, Color primaryColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          value: _selectedType ?? vm.documentTypes[0],
          icon: Icon(Icons.arrow_drop_down, color: primaryColor),
          items: vm.documentTypes.map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
          onChanged: (val) => setState(() => _selectedType = val),
        ),
      ),
    );
  }

  Widget _buildInputField(TextEditingController ctrl, String hint, int lines, Color color) {
    return TextField(
      controller: ctrl,
      maxLines: lines,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey.shade300)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: color, width: 2)),
      ),
    );
  }
}