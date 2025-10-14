import 'package:employment_attendance/core/constants/app_colors.dart';
import 'package:employment_attendance/core/widgets/custom.button.dart';
import 'package:employment_attendance/core/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'login_page.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
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
                        'Forgot Password',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 32,
                        ),
                      ),
                      Text(
                        '\u{1F512}',
                        style: TextStyle(fontSize: 32),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  CustomTextField(
                    label: 'Email',
                    controller: _emailController,
                    hintText: 'Enter your email',
                    prefixIcon: const Icon(Icons.email),
                  ),
                  const SizedBox(height: 24),
                  CustomButton(
                    width: double.infinity,
                    text: 'Send Reset Link',
                    onPressed: () {
                      Get.snackbar(
                        'Success',
                        'Link reset password sudah dikirim ke email kamu.',
                        snackPosition: SnackPosition.TOP,
                        backgroundColor: Colors.white,
                        colorText: Colors.black,
                        margin: const EdgeInsets.all(16),
                        borderRadius: 16,
                        icon: const Icon(Icons.check_circle,
                            color: AppColors.primary, size: 32),
                        duration: const Duration(seconds: 2),
                        isDismissible: true,
                        overlayBlur: 0.0,
                      );
                      Future.delayed(const Duration(seconds: 2), () {
                        Get.offAll(() => const LoginPage());
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () {
                      Get.to(() => const LoginPage());
                    },
                    child: const Text(
                      'Back to Login',
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
