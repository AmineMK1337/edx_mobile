import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:my_app/views/login_view.dart';
import 'package:my_app/viewmodels/home_viewmodel.dart';
import 'package:my_app/viewmodels/exams_viewmodel.dart';
import 'package:my_app/viewmodels/calendar_viewmodel.dart';
import 'package:my_app/viewmodels/notes_viewmodel.dart';
import 'package:my_app/viewmodels/courses_viewmodel.dart';
import 'package:my_app/viewmodels/absences_viewmodel.dart';
import 'package:my_app/viewmodels/absence_marking_viewmodel.dart';

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
