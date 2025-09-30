import 'package:employment_attendance/navigation/app_routes.dart';
import 'package:employment_attendance/task/presentation/widgets/custom_text_field.dart';
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
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
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
                  const Wrap(
                    alignment: WrapAlignment.center,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 8,
                    children: [
                      Text(
                        'Create an account',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 32,
                        ),
                      ),
                      Text(
                        '\u{1F44B}',
                        style: TextStyle(fontSize: 32),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  CustomTextField(
                    label: '',
                    controller: authController.fullNameController,
                    hintText: 'Full Name',
                    prefixIcon: const Icon(Icons.person),
                  ),
                  CustomTextField(
                    label: '',
                    controller: authController.registerEmailController,
                    hintText: 'Email',
                    prefixIcon: const Icon(Icons.email),
                  ),
                  Obx(() => CustomTextField(
                    label: '',
                        controller: authController.registerPasswordController,
                        obscureText: _obscurePassword.value,
                        hintText: 'Password',
                        prefixIcon: const Icon(Icons.lock),
                        suffixIcon: IconButton(
                          icon: Icon(_obscurePassword.value
                              ? Icons.visibility
                              : Icons.visibility_off),
                          onPressed: () {
                            _obscurePassword.value = !_obscurePassword.value;
                          },
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
                        textStyle: const TextStyle(fontSize: 22, fontWeight:  FontWeight.bold),
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
                      Get.toNamed(AppRoutes.LOGIN);
                    },
                    child:  RichText(text: const TextSpan(
                      style:   TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.w500 ),
                      children: <TextSpan>[
                        TextSpan(text: 'Already have account? '),
                        TextSpan(text: " Sign In", style:  TextStyle(color: Colors.blueAccent))
                      ]
                    ))
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

