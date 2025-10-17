// lib/main.dart

import 'package:employment_attendance/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:employment_attendance/navigation/app_pages.dart';
import 'package:employment_attendance/navigation/app_routes.dart';
import 'package:get_storage/get_storage.dart';
// ...existing imports
import 'package:employment_attendance/core/services/api_service.dart';
import 'package:employment_attendance/core/widgets/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");
  await GetStorage.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Note: dark mode wiring reverted to original behavior (always light)
    final lightTheme = ThemeData(
      brightness: Brightness.light,
      primaryColor: AppColors.primary,
      scaffoldBackgroundColor: Colors.grey[100],
      cardColor: Colors.white,
      colorScheme: const ColorScheme.light(
        primary: AppColors.primary,
        secondary: AppColors.primary,
        onPrimary: Colors.white,
      ),
      appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white, foregroundColor: Colors.black),
    );

    // Reverted: always use light theme by default (dark-mode toggle not wired here)
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      themeMode: ThemeMode.light,
      home: const _StartupRouter(),
      getPages: AppPages.pages,
    );
  }
}

class _StartupRouter extends StatefulWidget {
  const _StartupRouter();

  @override
  State<_StartupRouter> createState() => _StartupRouterState();
}

class _StartupRouterState extends State<_StartupRouter> {
  final ApiService _api = ApiService();
  final box = GetStorage();

  @override
  void initState() {
    super.initState();
    _validateToken();
  }

  Future<void> _validateToken() async {
    final token = box.read('authToken') as String?;

    if (token == null || token.isEmpty) {
      _navigateTo(AppRoutes.login);
      return;
    }

    // Validate token with backend (no time-based expiry check)
    // Token refresh will be handled automatically by ApiService interceptor
    try {
      final resp = await _api.get('/auth/me');
      if (resp.statusCode == 200) {
        _navigateTo(AppRoutes.dashboard);
      } else {
        _clearAuthData();
        _navigateTo(AppRoutes.login);
      }
    } catch (_) {
      // Network error - try to proceed to dashboard
      // ApiService will handle token refresh on next API call
      _navigateTo(AppRoutes.dashboard);
    }
  }

  void _clearAuthData() {
    box.remove('authToken');
    box.remove('authIssuedAt');
    box.remove('refreshToken');
    box.remove('expiresIn');
    box.remove('lastCheckDate');
    box.remove('user');
  }

  void _navigateTo(String route) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      try {
        Get.offAllNamed(route);
      } catch (_) {}
    });
  }

  @override
  Widget build(BuildContext context) {
    return const SplashScreen();
  }
}
