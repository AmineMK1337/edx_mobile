import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/nmessage_e_viewmodel.dart';
import '../models/message_request_e_model.dart';
import '../core/constants/app_colors.dart';

class NouveauMessageScreen extends StatefulWidget {
  const NouveauMessageScreen({super.key});

  @override
  State<NouveauMessageScreen> createState() => _NouveauMessageScreenState();
}

class _NouveauMessageScreenState extends State<NouveauMessageScreen> {
  final TextEditingController _destinataireController = TextEditingController();
  final TextEditingController _objetController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();

  @override
  void dispose() {
    _destinataireController.dispose();
    _objetController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _handleSend(NMessageViewModel viewModel) async {
    final myMessage = MessageRequest(
      role: viewModel.selectedRole ?? 'Professeur',
      specificName: _destinataireController.text,
      subject: _objetController.text,
      content: _messageController.text,
    );

    final success = await viewModel.sendMessage(myMessage);

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Message envoyé avec succès !"), backgroundColor: Colors.green),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Erreur lors de l'envoi. Vérifiez vos champs."), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<NMessageViewModel>();

    return Scaffold(
      backgroundColor: AppColors.backgroundMint,
      appBar: AppBar(
        backgroundColor: AppColors.primaryPink,
        elevation: 0,
        title: const Text("Nouveau Message", 
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          viewModel.isLoading
              ? const Padding(
                  padding: EdgeInsets.all(12),
                  child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                )
              : IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () => _handleSend(viewModel),
                ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildRoleSelector(viewModel),
            const SizedBox(height: 15),
            _buildInputField(
              controller: _objetController,
              labelText: "Objet",
              hintText: "Sujet du message",
              icon: Icons.subject,
            ),
            const SizedBox(height: 15),
            _buildMessageBodyField(_messageController),
          ],
        ),
      ),
    );
  }

  Widget _buildRoleSelector(NMessageViewModel vm) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          const Icon(Icons.person_outline, color: AppColors.primaryPink),
          const SizedBox(width: 10),
          DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: vm.selectedRole,
              items: vm.roles.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value, style: const TextStyle(color: AppColors.primaryPink, fontWeight: FontWeight.bold)),
                );
              }).toList(),
              onChanged: (val) => vm.setSelectedRole(val),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: _destinataireController,
              decoration: const InputDecoration(
                hintText: "Nom (optionnel)",
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String labelText,
    required String hintText,
    required IconData icon,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        prefixIcon: Icon(icon, color: AppColors.primaryPink),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.primaryPink, width: 2),
        ),
      ),
    );
  }

  Widget _buildMessageBodyField(TextEditingController controller) {
    return TextField(
      controller: controller,
      maxLines: 12,
      decoration: InputDecoration(
        labelText: "Message",
        alignLabelWithHint: true,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}