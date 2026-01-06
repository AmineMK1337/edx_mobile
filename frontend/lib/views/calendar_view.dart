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
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: () {
              Provider.of<CalendarViewModel>(context, listen: false).fetchAllEvents();
            },
          ),
        ],
      ),
      body: Consumer<CalendarViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (viewModel.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Erreur: ${viewModel.error}"),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => viewModel.fetchAllEvents(),
                    child: const Text("Réessayer"),
                  ),
                ],
              ),
            );
          }

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. Widget Calendrier (Mois) - passez les events
                  MonthCalendarWidget(events: viewModel.events),
                  
                  const SizedBox(height: 25),
                  
                  // 2. Titre de section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Événements à venir",
                        style: TextStyle(
                          color: Colors.teal,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "${viewModel.upcomingEvents.length} événement(s)",
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 15),

                  // 3. Liste des événements à venir
                  viewModel.upcomingEvents.isEmpty
                      ? Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 10,
                              ),
                            ],
                          ),
                          child: const Center(
                            child: Column(
                              children: [
                                Icon(Icons.event_available, size: 48, color: Colors.grey),
                                SizedBox(height: 12),
                                Text(
                                  "Aucun événement à venir",
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ],
                            ),
                          ),
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: viewModel.upcomingEvents.length,
                          itemBuilder: (context, index) {
                            return EventCard(event: viewModel.upcomingEvents[index]);
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
