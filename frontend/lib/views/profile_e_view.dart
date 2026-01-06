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
          : SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: (studentBase?.photoUrl != null)
                        ? NetworkImage(studentBase!.photoUrl!)
                        : const AssetImage('assets/user.jpg') as ImageProvider,
                  ),
                  const SizedBox(height: 10),
                  Text("${studentBase?.firstName ?? ''} ${studentBase?.lastName ?? ''}",
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 5),
                  Text(studentBase?.studentClass ?? '', 
                      style: const TextStyle(fontSize: 14, color: Colors.grey)),
                  const SizedBox(height: 20),

                  // Section: Informations personnelles
                  _buildSectionTitle("Informations personnelles"),
                  _buildInfoCard(Icons.badge, "Numéro étudiant", studentBase?.id),
                  _buildInfoCard(Icons.email, "Email", profileVM.profile?.email),
                  _buildInfoCard(Icons.phone, "Téléphone", profileVM.profile?.phone),
                  _buildInfoCard(Icons.location_on, "Adresse", profileVM.profile?.address),
                  _buildInfoCard(Icons.cake, "Date de naissance", profileVM.profile?.birthDate),

                  const SizedBox(height: 20),

                  // Section: Informations académiques
                  _buildSectionTitle("Informations académiques"),
                  _buildInfoCard(Icons.school, "Filière", studentBase?.studentClass),
                  _buildInfoCard(Icons.calendar_today, "Année académique", "2024-2025"),
                  _buildInfoCard(Icons.group, "Groupe", studentBase?.studentClass),
                  
                  const SizedBox(height: 30),
                ],
              ),
            ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.teal,
          ),
        ),
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
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                Text(value ?? "Non renseigné", style: const TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}