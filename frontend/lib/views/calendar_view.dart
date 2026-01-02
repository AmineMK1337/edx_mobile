import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/constants/app_colors.dart';
import '../viewmodels/calendar_viewmodel.dart';
import '../widgets/calendar_widgets.dart';

class CalendarView extends StatelessWidget {
  CalendarView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundMint,
      appBar: AppBar(
        backgroundColor: AppColors.primaryPink,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text("Calendrier", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            Text("Événements à venir", style: TextStyle(color: Colors.white70, fontSize: 12)),
          ],
        ),
      ),
      body: Consumer<CalendarViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (viewModel.error != null) {
            return Center(child: Text("Erreur: ${viewModel.error}"));
          }

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. Widget Calendrier (Mois)
                  const MonthCalendarWidget(),
                  
                  const SizedBox(height: 25),
                  
                  // 2. Titre de section
                  const Text(
                    "Événements à venir",
                    style: TextStyle(
                      color: Colors.teal,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  
                  const SizedBox(height: 15),

                  // 3. Liste des événements
                  viewModel.events.isEmpty
                      ? const Center(child: Text("Aucun événement"))
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: viewModel.events.length,
                          itemBuilder: (context, index) {
                            return EventCard(event: viewModel.events[index]);
                          },
                        ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
