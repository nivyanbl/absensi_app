// lib/main.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:employment_attendance/navigation/app_pages.dart';
import 'package:employment_attendance/navigation/app_routes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.LOGIN,
      getPages: AppPages.pages,
    );
  }
}