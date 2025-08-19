import 'dart:async';
import 'package:camera/camera.dart';
import 'package:employment_attendance/navigation/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class CheckInController extends GetxController {

  RxBool isLoading = true.obs;
  RxString currentTime = ''.obs;
  RxString currentDate = ''.obs;
  RxString currentLocation = 'Search Loation...'.obs;

  CameraController? cameraController;
  late List<CameraDescription> cameras;

  Timer? timer;

  @override
  void onInit() {
    super.onInit();
    _initialize();
  }

  @override
  void onClose() {
    cameraController?.dispose();
    timer?.cancel();
    super.onClose();
  }

  Future<void> _initialize() async {
    isLoading(true);
    await _initializeCamera();
    await _getCurrentLocation();
    _startTimer();
    isLoading(false);
  }

  Future<void> _initializeCamera() async {
    try {
      cameras = await availableCameras();
       if (cameras.isEmpty) {
        Get.snackbar('Camera Error', 'No camera Found.');
        return;
      }

      final frontCamera = cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.front,
        orElse: () => cameras.first,
      );
      
      cameraController = CameraController(
        frontCamera,
        ResolutionPreset.high,
        enableAudio: false,
      );

      await cameraController!.initialize();
    } catch (e) {
      cameraController = null; 
      Get.snackbar(
        'Camera Error',
        'Failed to initialize camera. Ensure permission has been granted..',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> _getCurrentLocation() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          currentLocation('Location permission denied');
          return;
        }
      }
      // //demo
      // currentLocation('Inside office area');

      
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      
      currentLocation('Lat: ${position.latitude}, Long: ${position.longitude}');
    
    } catch (e) {
      currentLocation('Failed to get location');
      Get.snackbar('Location Error', 'Failed to get location: $e');
    }
  }

  void _startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      currentTime.value = DateFormat('hh:mm a').format(DateTime.now());
      currentDate.value = DateFormat('dd MMMM yyyy').format(DateTime.now());
    });
  }

  void checkIn() {
    final Map<String, String> arguments = {
      'time': currentTime.value,
      'location': currentLocation.value,
    };
    cameraController?.dispose();
    timer?.cancel();
    cameraController = null;

       Get.offNamed(AppRoutes.CHECK_IN_SUCCESS, arguments: arguments);
  }
}