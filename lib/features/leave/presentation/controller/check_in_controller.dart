import 'dart:async';
import 'package:camera/camera.dart';
import 'package:employment_attendance/core/services/api_service.dart';
import 'package:employment_attendance/navigation/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:employment_attendance/features/dashboard/presentation/controllers/dashboard_controller.dart';

class CheckInController extends GetxController with WidgetsBindingObserver {
  final ApiService _apiService = ApiService();

  RxBool isLoading = true.obs;
  RxBool isCheckingIn = false.obs;
  RxString currentTime = ''.obs;
  RxString currentDate = ''.obs;
  RxString currentLocation = 'Searching Location...'.obs;
  RxBool isLocationReady = false.obs;
  // controls whether the bottom info panel is visible (expanded) or collapsed
  RxBool isPanelVisible = true.obs;
  // whether the user has already checked in today (used to disable UI)
  RxBool hasCheckedInToday = false.obs;
  final _storage = GetStorage();

  CameraController? cameraController;
  late List<CameraDescription> cameras;

  Timer? timer;
  Timer? _midnightTimer;

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
    _initialize();
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    try {
      cameraController?.dispose();
    } catch (_) {}
    timer?.cancel();
    _midnightTimer?.cancel();
    super.onClose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Stop camera when app goes to background or becomes inactive to avoid
    // receiving ImageReader callbacks after Flutter engine detaches.
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      try {
        cameraController?.dispose();
      } catch (_) {}
      cameraController = null;
    } else if (state == AppLifecycleState.resumed) {
      // Re-initialize camera when app resumes if needed.
      if (cameraController == null) {
        _initializeCamera();
      }
    }
  }

  Future<void> _initialize() async {
    isLoading(true);
    await _initializeCamera();
    await _getCurrentLocation();
    _maybeResetDailyFlags();
    // check if dashboard already has check-in info
    try {
      if (Get.isRegistered<DashboardController>()) {
        final dash = Get.find<DashboardController>();
        if (dash.checkInTime.value.trim().isNotEmpty) {
          hasCheckedInToday.value = true;
        }
      }
    } catch (_) {}
    _startTimer();
    isLoading(false);
  }

  void _maybeResetDailyFlags() {
    final todayKey = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final lastDate = _storage.read('lastCheckDate') as String?;
    if (lastDate == null || lastDate != todayKey) {
      // new day: clear local check-in flag so user can check in again
      hasCheckedInToday.value = false;
      _storage.write('lastCheckDate', todayKey);
    }
  }

  Future<void> _initializeCamera() async {
    try {
      cameras = await availableCameras();
      if (cameras.isEmpty) {
        Get.snackbar('Camera Error', 'Camera not found',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red.withValues(alpha: 0.9),
            colorText: Colors.white);
        return;
      }

      final frontCamera = cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.front,
        orElse: () => cameras.first,
      );

      // Use a lower resolution and explicit image format to reduce memory
      // and buffer pressure on some Android devices which can cause
      // "Unable to acquire a buffer item" runtime warnings.
      cameraController = CameraController(
        frontCamera,
        ResolutionPreset.medium,
        enableAudio: false,
        imageFormatGroup: ImageFormatGroup.yuv420,
      );

      await cameraController!.initialize();
    } catch (e) {
      cameraController = null;
      Get.snackbar('Camera Error',
          'Failed to initialize camera. Ensure permission has been granted.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.withValues(alpha: 0.9),
          colorText: Colors.white);
    }
  }

  Future<void> _getCurrentLocation() async {
    isLocationReady(false);
    currentLocation('Searching for location...');
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw const PermissionDeniedException(
              "Location permission denied by user.");
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw const PermissionDeniedException(
            "Location permission is permanently denied. Please enable it manually in settings.");
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.medium,
      ).timeout(const Duration(seconds: 15));

      await _updateLocationFromPosition(position);
    } on TimeoutException {
      currentLocation('Failed to get location');
      isLocationReady(false);
      Get.snackbar('Timeout',
          'Request Timed Out: GPS signal is weak. Try again in an open area.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.orange.withValues(alpha: 0.9),
          colorText: Colors.white);
    } on PermissionDeniedException catch (e) {
      currentLocation('Location permission denied');
      isLocationReady(false);
      Get.snackbar(
          'Permission denied',
          e.message ??
              "Permission denied. Please enable it in the app settings.",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.withValues(alpha: 0.9),
          colorText: Colors.white);
    } on LocationServiceDisabledException {
      currentLocation('Location service is off');
      isLocationReady(false);
      Get.snackbar(
          'GPS Off', 'GPS is not Active. Please enable location services.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.withValues(alpha: 0.9),
          colorText: Colors.white);
    } catch (e) {
      currentLocation('An error occurred');
      isLocationReady(false);
      Get.snackbar('Error', 'An unknown error occurred: $e',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.withValues(alpha: 0.9),
          colorText: Colors.white);
      debugPrint("Unknown error: $e");
    }
  }

  Future<void> _updateLocationFromPosition(Position position) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;
        String address =
            "${place.street}, ${place.subLocality}, ${place.locality}";
        currentLocation(address);
        isLocationReady(true);
      } else {
        currentLocation("Address not found.");
        isLocationReady(false);
      }
    } catch (e) {
      currentLocation("Lat: ${position.latitude}, Long: ${position.longitude}");
      isLocationReady(true);
    }
  }

  void _startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      currentTime.value = DateFormat('hh:mm a').format(DateTime.now());
      currentDate.value = DateFormat('dd MMMM yyyy').format(DateTime.now());
    });
    _scheduleMidnightReset();
  }

  void _scheduleMidnightReset() {
    _midnightTimer?.cancel();
    final now = DateTime.now();
    final tomorrow =
        DateTime(now.year, now.month, now.day).add(const Duration(days: 1));
    final untilMidnight = tomorrow.difference(now);
    _midnightTimer = Timer(untilMidnight, () {
      hasCheckedInToday.value = false;
      _storage.write(
          'lastCheckDate', DateFormat('yyyy-MM-dd').format(DateTime.now()));
      // reschedule for next midnight
      _scheduleMidnightReset();
    });
  }

  void checkIn() async {
    if (!isLocationReady.value) {
      Get.snackbar(
          'Info', 'Cannot check in. Please wait until your location is found.',
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    try {
      isCheckingIn(true);

      final response = await _apiService.post(
        '/attendance/clock-in',
        data: {'note': currentLocation.value, 'method': 'MOBILE'},
      );

      if (response.statusCode == 201) {
        final Map<String, String> arguments = {
          'time': currentTime.value,
          'location': currentLocation.value,
        };

        // brief success feedback
        try {
          HapticFeedback.lightImpact();
        } catch (_) {}

        Get.snackbar('Success', 'Check-in successful',
            snackPosition: SnackPosition.BOTTOM);

        try {
          await cameraController?.dispose();
        } catch (_) {}
        timer?.cancel();
        cameraController = null;

        // Optimistically update dashboard UI immediately if registered
        try {
          if (Get.isRegistered<DashboardController>()) {
            final dash = Get.find<DashboardController>();
            dash.checkInTime.value = currentTime.value;
            dash.location.value = currentLocation.value;
            hasCheckedInToday.value = true;
            // persist last check date so app knows user has checked in today
            _storage.write('lastCheckDate',
                DateFormat('yyyy-MM-dd').format(DateTime.now()));
          }
        } catch (_) {}

        Get.offNamed(AppRoutes.checkInSuccess, arguments: arguments);
        // attempt to refresh dashboard if present so overview reflects new check-in
        try {
          if (Get.isRegistered<DashboardController>()) {
            await Get.find<DashboardController>().refresh();
          }
        } catch (_) {}
      } else {
        Get.snackbar('Error',
            'Failed to clock in. Server returned status: ${response.statusCode}',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red.withValues(alpha: 0.9),
            colorText: Colors.white);
      }
    } catch (error) {
      if (error is DioException && error.response != null) {
        final status = error.response?.statusCode;
        final data = error.response?.data;

        // Treat 409 SESSION_OPEN as a non-fatal success: navigate to success page
        if (status == 409) {
          String? errorCode;
          try {
            if (data is Map && data['error'] is Map) {
              errorCode = data['error']['code'] as String?;
            }
          } catch (_) {
            errorCode = null;
          }

          if (errorCode == 'SESSION_OPEN' ||
              (data is String && data.contains('Session already open'))) {
            final Map<String, String> arguments = {
              'time': currentTime.value,
              'location': currentLocation.value,
            };

            try {
              HapticFeedback.lightImpact();
            } catch (_) {}

            Get.snackbar(
                'Info', 'Session already open. Showing current session.',
                snackPosition: SnackPosition.BOTTOM);

            try {
              await cameraController?.dispose();
            } catch (_) {}
            timer?.cancel();
            cameraController = null;

            // Optimistically update dashboard UI to show current session time/location
            try {
              if (Get.isRegistered<DashboardController>()) {
                final dash = Get.find<DashboardController>();
                dash.checkInTime.value = currentTime.value;
                dash.location.value = currentLocation.value;
                hasCheckedInToday.value = true;
              }
            } catch (_) {}

            Get.offNamed(AppRoutes.checkInSuccess, arguments: arguments);
            try {
              if (Get.isRegistered<DashboardController>()) {
                await Get.find<DashboardController>().refresh();
              }
            } catch (_) {}
            isCheckingIn(false);
            return;
          }
        }

        // Default error handling for other statuses
        String message = 'An error occurred during clock in.';
        if (data is Map && data['message'] != null) {
          message = data['message'].toString();
        } else if (data is String) {
          message = data;
        }
        Get.snackbar('Error ($status)', message,
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red.withValues(alpha: 0.9),
            colorText: Colors.white);
        debugPrint('Clock-in failed: status=$status data=$data');
      } else {
        Get.snackbar('Error', 'An error occurred during clock in.',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red.withValues(alpha: 0.9),
            colorText: Colors.white);
        debugPrint('Clock-in error: $error');
      }
    } finally {
      isCheckingIn(false);
    }
  }

  void togglePanel() {
    isPanelVisible.value = !isPanelVisible.value;
  }
}
