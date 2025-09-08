import 'dart:async';

import 'package:employment_attendance/navigation/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class CheckOutController extends GetxController {
  final RxString userName = 'John Doe'.obs;
  final RxString userPosition = 'UI/UX Designer'.obs;
  final RxString checkInTime = 'April 12, 2025 08:05 AM'.obs;
  final RxString checkInLocation = 'Inside Office Area'.obs;

  RxString currentTime = ''.obs;
  Timer? _timer;

  @override
  void onInit() {
    super.onInit();
    _startTimer();
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }

  void _startTimer(){
    _timer = Timer.periodic( const Duration(seconds : 1), (timer){
      currentTime.value = DateFormat('hh:mm a').format(DateTime.now());
    });
  }

  void checkOutNow(){
    Get.offAllNamed(AppRoutes.DASHBOARD);
    Get.snackbar('Success', 'You have successfully checked out at ${currentTime.value}',
    backgroundColor: const Color(0xFF6EA07A),
    colorText: Colors.white,
    snackPosition: SnackPosition.TOP
    );
  }
}
