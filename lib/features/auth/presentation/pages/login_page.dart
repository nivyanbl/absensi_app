import 'package:employment_attendance/core/constants/app_colors.dart';
import 'package:employment_attendance/core/constants/app_strings.dart';
import 'package:employment_attendance/core/widgets/custom.button.dart';
import 'package:employment_attendance/features/auth/presentation/controllers/auth.controller.dart';
import 'package:employment_attendance/navigation/app_routes.dart';
import 'package:employment_attendance/core/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginPage extends StatelessWidget {
  final RxBool _obscurePassword = true.obs;

  final AuthController authController = Get.put(AuthController());

  LoginPage({super.key});

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
                    AppStrings.appName,
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
                    label: AppStrings.email,
                    controller: authController.emailController,
                    hintText: AppStrings.enterEmail,
                  ),
                  const SizedBox(height: 24),
                  Obx(() => CustomTextField(
                        label: AppStrings.password,
                        controller: authController.passwordController,
                        hintText: AppStrings.enterPassword,
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
                        Get.toNamed(AppRoutes.forgotPassword);
                      },
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: const Size(0, 0),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        alignment: Alignment.centerLeft,
                      ),
                      child: const Text(
                        AppStrings.forgotPassword,
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
                      child: CustomButton(
                        text: AppStrings.signIn,
                        onPressed: authController.isLoading.value
                            ? null
                            : () => authController.loginUser(),
                        isLoading: authController.isLoading.value,
                      ),
                    );
                  }),
                  const SizedBox(height: 16),
                  TextButton(
                      onPressed: () {
                        Get.toNamed(AppRoutes.register);
                      },
                      child: RichText(
                          text: const TextSpan(
                              style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w500),
                              children: <TextSpan>[
                            TextSpan(text: AppStrings.noAccount),
                            TextSpan(
                                text: AppStrings.register,
                                style: TextStyle(color: Colors.blueAccent))
                          ]))),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
