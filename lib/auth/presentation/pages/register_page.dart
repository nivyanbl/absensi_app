import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:employment_attendance/auth/presentation/controllers/auth.controller.dart';

class RegisterPage extends StatelessWidget {
  final RxBool _obscurePassword = true.obs;
  final AuthController authController = Get.put(AuthController());

  RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 40),
                  Image.asset(
                    'assets/image/logo.png',
                    height: 120,
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'SIESTACLICK',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                      letterSpacing: 4,
                    ),
                  ),
                  const SizedBox(height: 32),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Create an account',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 32,
                        ),
                      ),
                      SizedBox(width: 8),
                      Text(
                        '\u{1F44B}',
                        style: TextStyle(fontSize: 32),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  TextField(
                    controller: authController.fullNameController,
                    decoration: const InputDecoration(
                      labelText: 'Full Name',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.person),
                    ),
                    keyboardType: TextInputType.name,
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: authController.registerEmailController,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.email),
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 16),
                  Obx(() => TextField(
                        controller: authController.registerPasswordController,
                        obscureText: _obscurePassword.value,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          border: const OutlineInputBorder(),
                          prefixIcon: const Icon(Icons.lock),
                          suffixIcon: IconButton(
                            icon: Icon(_obscurePassword.value
                                ? Icons.visibility
                                : Icons.visibility_off),
                            onPressed: () {
                              _obscurePassword.value = !_obscurePassword.value;
                            },
                          ),
                        ),
                      )),
                  const SizedBox(height: 16),
                 
                  const SizedBox(height: 24),
                  Obx(() {
                    return ElevatedButton(
                      onPressed: authController.isLoading.value
                          ? null
                          : () => authController.registerUser(),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        textStyle: const TextStyle(fontSize: 18),
                        backgroundColor: const Color(0xFF6EA07A),
                      ),
                      child: authController.isLoading.value
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text('Register',
                              style: TextStyle(color: Colors.white)),
                    );
                  }),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () {
                      Get.back();
                    },
                    child: const Text(
                      'Already have an account? Login',
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 16,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
