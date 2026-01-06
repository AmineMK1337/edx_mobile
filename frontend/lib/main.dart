import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:my_app/views/login_view.dart';
import 'package:my_app/viewmodels/home_viewmodel.dart';
import 'package:my_app/viewmodels/exams_viewmodel.dart';
import 'package:my_app/viewmodels/calendar_viewmodel.dart';
import 'package:my_app/viewmodels/notes_viewmodel.dart';
import 'package:my_app/viewmodels/courses_viewmodel.dart';
import 'package:my_app/viewmodels/absences_viewmodel.dart';
// Student viewmodels
import 'package:my_app/viewmodels/student_e_viewmodel.dart';
import 'package:my_app/viewmodels/profile_e_viewmodel.dart';
import 'package:my_app/viewmodels/resultats_e_viewmodel.dart';
import 'package:my_app/viewmodels/emploi_e_viewmodel.dart';
import 'package:my_app/viewmodels/group_e_viewmodel.dart';
import 'package:my_app/viewmodels/messages_e_viewmodel.dart';
import 'package:my_app/viewmodels/info_e_viewmodel.dart';
import 'package:my_app/viewmodels/absence_e_viewmodel.dart';
import 'package:my_app/viewmodels/document_e_viewmodel.dart';
import 'package:my_app/viewmodels/partage_e_viewmodel.dart';
import 'package:my_app/viewmodels/demandedoc_e_viewmodel.dart';
import 'package:my_app/viewmodels/nmessage_e_viewmodel.dart';
import 'package:my_app/viewmodels/voir_document_e_viewmodel.dart';
import 'package:my_app/viewmodels/partager_e_viewmodel.dart';
import 'package:my_app/viewmodels/ticket_e_viewmodel.dart';
import 'package:my_app/viewmodels/settings_viewmodel.dart';
import 'package:my_app/viewmodels/about_viewmodel.dart';
import 'package:my_app/viewmodels/general_info_viewmodel.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => HomeViewModel()),
        ChangeNotifierProvider(create: (_) => ExamsViewModel()),
        ChangeNotifierProvider(create: (_) => CalendarViewModel()),
        ChangeNotifierProvider(create: (_) => NotesViewModel()),
        ChangeNotifierProvider(create: (_) => CoursesViewModel()),
        ChangeNotifierProvider(create: (_) => AbsencesViewModel()),
        // Student viewmodels
        ChangeNotifierProvider(create: (_) => StudentViewModel()),
        ChangeNotifierProvider(create: (_) => ProfileViewModel()),
        ChangeNotifierProvider(create: (_) => ResultatsViewModel()),
        ChangeNotifierProvider(create: (_) => EmploiViewModel()),
        ChangeNotifierProvider(create: (_) => GroupViewModel()),
        ChangeNotifierProvider(create: (_) => MessagesViewModel()),
        ChangeNotifierProvider(create: (_) => InfoViewModel()),
        ChangeNotifierProvider(create: (_) => AbsenceViewModel()),
        ChangeNotifierProvider(create: (_) => DocumentViewModel()),
        ChangeNotifierProvider(create: (_) => PartageViewModel()),
        ChangeNotifierProvider(create: (_) => DemandeDocViewModel()),
        ChangeNotifierProvider(create: (_) => NMessageViewModel()),
        ChangeNotifierProvider(create: (_) => VoirDocumentViewModel()),
        ChangeNotifierProvider(create: (_) => PartagerViewModel()),
        ChangeNotifierProvider(create: (_) => TicketViewModel()),
        ChangeNotifierProvider(create: (_) => SettingsViewModel()),
        ChangeNotifierProvider(create: (_) => AboutViewModel()),
        ChangeNotifierProvider(create: (_) => GeneralInfoViewModel()),
      ],
      child: MaterialApp(
        title: 'Mon Application',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        home: const LoginView(),
      ),
    );
  }
}
