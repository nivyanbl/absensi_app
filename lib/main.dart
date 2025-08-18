import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'feature/presentation/page/dashboard_page.dart';
import 'feature/presentation/page/lms_page.dart';
import 'feature/presentation/page/login_page.dart';
import 'feature/presentation/page/register_page.dart';
import 'feature/presentation/page/notification_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: DashboardPage(),
    );
  }
}
