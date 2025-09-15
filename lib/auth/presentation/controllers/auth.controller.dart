import 'package:employment_attendance/auth/data/repositories/auth_repository.dart';
import 'package:employment_attendance/navigation/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  final AuthRepository _authRepository = AuthRepository();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final fullNameController = TextEditingController();
  final registerEmailController = TextEditingController();
  final registerPasswordController = TextEditingController();

  var isLoading = false.obs;

  void loginUser() async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    if (email.isEmpty || password.isEmpty) {
      Get.snackbar('Error', 'Email and password are required.');
      return;
    }
    try {
      isLoading.value = true;
      final token = await _authRepository.login(email, password);
      if (token != null) {
        Get.offAllNamed(AppRoutes.DASHBOARD);
      } else {
        Get.snackbar('Failed', 'The email or password you entered is incorrect.');
      }
    } finally {
      isLoading.value = false;
    }
  }

  void registerUser() async {
    String fullName = fullNameController.text.trim();
    String email = registerEmailController.text.trim();
    String password = registerPasswordController.text.trim();

    if (fullName.isEmpty || email.isEmpty || password.isEmpty) {
      Get.snackbar('Error', 'All fields are required.');
      return;
    }

 

    try {
      isLoading.value = true;
      final token = await _authRepository.register(fullName, email, password);

      if (token != null) {
        Get.snackbar('Success', 'Account created successfully!');
        Get.offAllNamed(AppRoutes.LOGIN);
      } else {
        Get.snackbar('Failed', 'Registration failed. Maybe the email is already registered.');
      }
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    fullNameController.dispose();
    registerEmailController.dispose();
    registerPasswordController.dispose();
    super.onClose();
  }
}