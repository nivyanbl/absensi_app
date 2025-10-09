import 'package:employment_attendance/core/constants/app_colors.dart';
import 'package:employment_attendance/core/constants/app_strings.dart';
import 'package:employment_attendance/core/widgets/custom.button.dart';
import 'package:employment_attendance/navigation/app_routes.dart';
import 'package:employment_attendance/core/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:employment_attendance/features/auth/presentation/controllers/auth.controller.dart';

class RegisterPage extends StatelessWidget {
  final RxBool _obscurePassword = true.obs;
  final AuthController authController = Get.put(AuthController());

  RegisterPage({super.key});

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
                  const Wrap(
                    alignment: WrapAlignment.center,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 8,
                    children: [
                      Text(
                        AppStrings.createAccount,
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
                    hintText: AppStrings.fullName,
                    prefixIcon: const Icon(Icons.person),
                  ),
                  CustomTextField(
                    label: '',
                    controller: authController.registerEmailController,
                    hintText: AppStrings.email,
                    prefixIcon: const Icon(Icons.email),
                  ),
                  Obx(() => CustomTextField(
                        label: '',
                        controller: authController.registerPasswordController,
                        obscureText: _obscurePassword.value,
                        hintText: AppStrings.password,
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
                    return CustomButton(
                      text: AppStrings.register,
                      onPressed: authController.isLoading.value
                          ? null
                          : () => authController.registerUser(),
                      isLoading: authController.isLoading.value,
                    );
                  }),
                  const SizedBox(height: 16),
                  TextButton(
                      onPressed: () {
                        Get.toNamed(AppRoutes.login);
                      },
                      child: RichText(
                          text: const TextSpan(
                              style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.textSecondary,
                                  fontWeight: FontWeight.w500),
                              children: <TextSpan>[
                            TextSpan(text: AppStrings.haveAccount),
                            TextSpan(
                                text: AppStrings.signIn,
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
