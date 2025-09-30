import 'package:employment_attendance/auth/presentation/controllers/auth.controller.dart';
import 'package:employment_attendance/navigation/app_routes.dart';
import 'package:employment_attendance/task/presentation/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginPage extends StatelessWidget {
  final RxBool _obscurePassword = true.obs;

  final AuthController authController = Get.put(AuthController());

  LoginPage({super.key});

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
                  // Use Wrap so text+emoji don't overflow on small widths
                  const Wrap(
                    alignment: WrapAlignment.center,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 8,
                    children: [
                      Text(
                        'Welcome back',
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
                  const SizedBox(height: 40),
                  CustomTextField(
                    label: 'Email',
                    controller: authController.emailController,
                    hintText: 'Enter your email',
                  ),
                  const SizedBox(height: 24),
                  Obx(() => CustomTextField(
                        label: 'Password',
                        controller: authController.passwordController,
                        hintText: 'Enter your password',
                        obscureText: _obscurePassword.value,
                        suffixIcon: IconButton(
                          icon: Icon(_obscurePassword.value
                              ? Icons.visibility_off
                              : Icons.visibility),
                          onPressed: () {
                            _obscurePassword.value = !_obscurePassword.value;
                          },
                        ),
                      )),
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton(
                      onPressed: () {
                        Get.toNamed(AppRoutes.FORGOT_PASSWORD);
                      },
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: const Size(0, 0),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        alignment: Alignment.centerLeft,
                      ),
                      child: const Text(
                        'Forgot your password?',
                        style: TextStyle(
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Obx(() {
                    return SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: authController.isLoading.value
                            ? null
                            : () => authController.loginUser(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF6EA07A),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: authController.isLoading.value
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : const Text(
                                'Sign In',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 22,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    );
                  }),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () {
                      Get.toNamed(AppRoutes.REGISTER);
                    },
                    child:  RichText(text: const TextSpan(
                      style:   TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.w500 ),
                      children: <TextSpan>[
                        TextSpan(text: 'Don\'t have an account? '),
                        TextSpan(text: " Register", style:  TextStyle(color: Colors.blueAccent))
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
