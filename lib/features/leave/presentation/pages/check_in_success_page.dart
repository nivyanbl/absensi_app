import 'package:employment_attendance/core/widgets/custom.button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:employment_attendance/navigation/app_routes.dart';
import '../../../../core/constants/app_colors.dart';

class CheckInSuccessPage extends StatelessWidget {
  const CheckInSuccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    final Map<String, String> data = Get.arguments ?? {};
    final String time = data['time'] ?? 'Unknown Time';
    final String location = data['location'] ?? 'Unknown Location';

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          child: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Check-in \nSuccessful',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 45,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 7, 30, 122),
                ),
              ),

              const SizedBox(height: 24),

              const CircleAvatar(
                radius: 70,
                backgroundColor: AppColors.primary,
                child: Icon(
                  Icons.check,
                  size: 120,
                  weight: 40.0,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),

              RichText(
                text: TextSpan(
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                  children: <TextSpan>[
                    const TextSpan(text: 'You check in at '),
                    TextSpan(
                      text: time,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                  children: <TextSpan>[
                    const TextSpan(text: 'Location Verifed at '),
                    TextSpan(
                      text: location,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 60),

              //button
              CustomButton(
                width: double.infinity,
                text: 'Back to Home',
                onPressed: () {
                  Get.toNamed(AppRoutes.dashboard);
                },
              )
            ],
          ),
        ),
      )),
    );
  }
}
