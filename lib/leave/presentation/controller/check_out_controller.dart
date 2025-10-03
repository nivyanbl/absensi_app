import 'dart:async';
import 'package:dio/dio.dart';
import 'package:employment_attendance/core/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:employment_attendance/profile/presentation/controller/profile_controller.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';

class CheckOutController extends GetxController {
  final ApiService _apiService = ApiService();
  final ProfileController _profileController = Get.find<ProfileController>();

  var isCheckingOut = false.obs;
  var canCheckOut = false.obs;
  final _storage = GetStorage();
  Timer? _timer;
  Timer? _midnightTimer;

  var userName = 'Loading...'.obs;
  var userPosition = '...'.obs;
  var checkInTime = 'N/A'.obs;
  var checkInLocation = '...'.obs;
  var currentTime = '--:--:--'.obs;

  @override
  void onInit() {
    super.onInit();
  _maybeResetDailyFlags();
  _loadInitialData();
    _startTimer();
  }

  void _maybeResetDailyFlags() {
    final todayKey = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final lastDate = _storage.read('lastCheckDate') as String?;
    if (lastDate == null || lastDate != todayKey) {
      canCheckOut.value = false;
      _storage.write('lastCheckDate', todayKey);
    }
  }

  @override
  void onClose() {
  _timer?.cancel();
  _midnightTimer?.cancel();
    super.onClose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      currentTime.value = DateFormat('hh:mm a').format(DateTime.now());
    });
    _scheduleMidnightReset();
  }

  void _scheduleMidnightReset() {
    _midnightTimer?.cancel();
    final now = DateTime.now();
    final tomorrow = DateTime(now.year, now.month, now.day).add(const Duration(days: 1));
    final untilMidnight = tomorrow.difference(now);
    _midnightTimer = Timer(untilMidnight, () {
      canCheckOut.value = false;
      _storage.write('lastCheckDate', DateFormat('yyyy-MM-dd').format(DateTime.now()));
      _scheduleMidnightReset();
    });
  }

  Future<void> _loadInitialData() async {
    userName.value = _profileController.user.value?.fullName ?? 'Name Not Found';
    userPosition.value = "UI UX Designer";

    try {
      final now = DateTime.now();
      final fromDate = DateFormat('yyyy-MM-dd').format(now);

      final response = await _apiService.get(
        '/attendance',
        queryParameters: {
          'from': fromDate,
          'to': fromDate,
          'status': 'open',
        },
      );

      if (response.statusCode == 200 && response.data['data'] != null) {
        final List<dynamic> attendanceList = response.data['data'];
        if (attendanceList.isNotEmpty) {
          final latestAttendance = attendanceList.first;
          final clockInDateTime = DateTime.parse(latestAttendance['clockInAt']).toLocal();
          checkInTime.value = DateFormat('hh:mm a').format(clockInDateTime);
          checkInLocation.value = latestAttendance['note'] ?? 'Location not recorded';
          canCheckOut.value = true;
          // persist last check date to indicate there's activity today
          _storage.write('lastCheckDate', DateFormat('yyyy-MM-dd').format(DateTime.now()));
        } else {
          checkInTime.value = 'N/A';
          checkInLocation.value = 'No active check-in today';
          canCheckOut.value = false;
        }
      } else {
        checkInTime.value = 'N/A';
        checkInLocation.value = 'No check-in today';
        canCheckOut.value = false;
      }
    } on DioException catch (e) {
      checkInTime.value = 'Error';
      checkInLocation.value = 'Failed to load data';
      print("Error fetching latest attendance: $e");
    } catch (e) {
      checkInTime.value = 'Error';
      checkInLocation.value = 'An unexpected error occurred';
      print("An unexpected error occurred: $e");
    }
}

  void checkOutNow() async {
    try {
      isCheckingOut(true);
      final response = await _apiService.post('/attendance/clock-out');

      if (response.statusCode == 200) {
        Get.back();
        Get.snackbar('Succeed', 'You have successfully checked out.');
  canCheckOut.value = false;
  // persist lastCheckDate so next day logic knows checkout happened today
  _storage.write('lastCheckDate', DateFormat('yyyy-MM-dd').format(DateTime.now()));
      } else {
    final errorMessage = response.data is Map
      ? (response.data['message'] ?? response.data['error'] ?? 'Failed to check out.')
      : (response.data?.toString() ?? 'Failed to check out.');
    final title = 'Failed (${response.statusCode})';
    Get.snackbar(title, errorMessage, snackPosition: SnackPosition.BOTTOM, backgroundColor: const Color(0xFFB00020).withOpacity(0.9), colorText: const Color(0xFFFFFFFF));
      }
    } catch (e) {
    final msg = e is DioException && e.response != null
      ? (e.response?.data?.toString() ?? 'Server error')
      : e.toString();
    Get.snackbar('Error', msg, snackPosition: SnackPosition.BOTTOM, backgroundColor: const Color(0xFFB00020).withOpacity(0.9), colorText: const Color(0xFFFFFFFF));
    } finally {
      isCheckingOut(false);
    }
  }
}