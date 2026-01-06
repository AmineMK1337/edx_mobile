import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// Common imports
import 'package:my_app/views/common/login_view.dart';
import 'package:my_app/viewmodels/common/settings_viewmodel.dart';
import 'package:my_app/viewmodels/common/about_viewmodel.dart';
import 'package:my_app/viewmodels/common/general_info_viewmodel.dart';
// Professor viewmodels
import 'package:my_app/viewmodels/professor/home_viewmodel.dart';
import 'package:my_app/viewmodels/professor/exams_viewmodel.dart';
import 'package:my_app/viewmodels/professor/calendar_viewmodel.dart';
import 'package:my_app/viewmodels/professor/notes_viewmodel.dart';
import 'package:my_app/viewmodels/professor/courses_viewmodel.dart';
import 'package:my_app/viewmodels/professor/absences_viewmodel.dart';
// Student viewmodels
import 'package:my_app/viewmodels/student/student_e_viewmodel.dart';
import 'package:my_app/viewmodels/student/profile_e_viewmodel.dart';
import 'package:my_app/viewmodels/student/resultats_e_viewmodel.dart';
import 'package:my_app/viewmodels/student/emploi_e_viewmodel.dart';
import 'package:my_app/viewmodels/student/group_e_viewmodel.dart';
import 'package:my_app/viewmodels/student/messages_e_viewmodel.dart';
import 'package:my_app/viewmodels/student/info_e_viewmodel.dart';
import 'package:my_app/viewmodels/student/absence_e_viewmodel.dart';
import 'package:my_app/viewmodels/student/document_e_viewmodel.dart';
import 'package:my_app/viewmodels/student/partage_e_viewmodel.dart';
import 'package:my_app/viewmodels/student/demandedoc_e_viewmodel.dart';
import 'package:my_app/viewmodels/student/nmessage_e_viewmodel.dart';
import 'package:my_app/viewmodels/student/voir_document_e_viewmodel.dart';
import 'package:my_app/viewmodels/student/partager_e_viewmodel.dart';
import 'package:my_app/viewmodels/student/ticket_e_viewmodel.dart';

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
