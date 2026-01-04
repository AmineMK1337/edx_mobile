import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/profile_e_viewmodel.dart';
import '../viewmodels/student_e_viewmodel.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  @override
  void initState() {
    super.initState();
    // On récupère l'ID depuis le StudentViewModel déjà chargé
    final studentId = context.read<StudentViewModel>().student?.id;
    if (studentId != null && studentId.isNotEmpty) {
      context.read<ProfileViewModel>().fetchProfile(studentId);
    }
  }

  @override
  Widget build(BuildContext context) {
    final profileVM = context.watch<ProfileViewModel>();
    final studentBase = context.watch<StudentViewModel>().student;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Mon Profil", style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.blue),
      ),
      body: profileVM.isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                const SizedBox(height: 20),
                CircleAvatar(
                  radius: 50,
                  backgroundImage: (studentBase?.photoUrl != null)
                      ? NetworkImage(studentBase!.photoUrl!)
                      : const AssetImage('assets/user.jpg') as ImageProvider,
                ),
                const SizedBox(height: 10),
                Text("${studentBase?.firstName} ${studentBase?.lastName}",
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 30),
                
                // Affichage du téléphone (Ligne qui posait problème)
                _buildInfoCard(Icons.phone, "Téléphone", profileVM.profile?.phone),
                _buildInfoCard(Icons.email, "Email", profileVM.profile?.email),
                _buildInfoCard(Icons.location_on, "Adresse", profileVM.profile?.address),
              ],
            ),
    );
  }

  Widget _buildInfoCard(IconData icon, String title, String? value) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.blue),
          const SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontSize: 12, color: Colors.grey)),
              Text(value ?? "Chargement...", style: const TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }
}