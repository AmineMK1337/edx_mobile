import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/profile_e_viewmodel.dart';
import '../viewmodels/student_e_viewmodel.dart';
import '../core/constants/app_colors.dart';

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
      backgroundColor: AppColors.backgroundMint,
      appBar: AppBar(
        title: const Text("Mon Profil", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: AppColors.primaryPink,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
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
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
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
          Icon(icon, color: AppColors.primaryPink),
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