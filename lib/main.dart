import 'package:employment_attendance/feature/presentation/page/edit_profile_page.dart';
import 'package:employment_attendance/feature/presentation/page/login_page.dart';
import 'package:employment_attendance/feature/presentation/page/register_page.dart';
import 'package:flutter/material.dart';
import 'feature/presentation/page/dashboard_page.dart';
import 'feature/presentation/page/profile_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Employment App',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        primarySwatch: Colors.green,
        fontFamily: 'Roboto',
      ),
      home: const ProfilePage(),
    );
  }
}