import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:my_app/views/home_view.dart';
import 'package:my_app/viewmodels/home_viewmodel.dart';
import 'package:my_app/viewmodels/exams_viewmodel.dart';
import 'package:my_app/viewmodels/calendar_viewmodel.dart';

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
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        home: const HomeView(),
      ),
    );
  }
}
