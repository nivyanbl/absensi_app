import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:employment_attendance/feature/presentation/page/login_page.dart';
import 'package:employment_attendance/feature/presentation/page/register_page.dart';
import 'package:employment_attendance/feature/presentation/page/notification_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Absensi App',
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    );
  }
}

class HomePage extends StatelessWidget {
  // variabel reaktif pakai GetX
  final counter = 0.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Absensi App")),
      body: Center(
        child: Obx(() => Text(
              "Counter: ${counter.value}",
              style: const TextStyle(fontSize: 20),
            )),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => counter.value++, // tambah counter
        child: const Icon(Icons.add),
      ),
    );
  }
}
