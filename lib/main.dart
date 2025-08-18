import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'feature/presentation/page/dashboard_page.dart';
import 'feature/presentation/page/leave_request_page.dart';
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
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/login',
      getPages: [
        GetPage(name: '/dashboard', page: () => const DashboardPage()),
        GetPage(name: '/leave-request', page: () => const LeaveRequestPage()),
        GetPage(name: '/lms', page: () => const LmsPage()),
        GetPage(name: '/login', page: () =>  LoginPage()),
        GetPage(name: '/register', page: () => RegisterPage()),
        GetPage(name: '/notification', page: () => const NotificationPage()),
        // Tambahkan GetPage lain jika ada
      ],
    );
  }
}
