import 'dart:async';
import 'package:camera/camera.dart';
import 'package:employment_attendance/core/services/api_service.dart';
import 'package:employment_attendance/navigation/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

class CheckInController extends GetxController {
  final ApiService _apiService = ApiService();

  RxBool isLoading = true.obs;
  RxBool isCheckingIn = false.obs;
  RxString currentTime = ''.obs;
  RxString currentDate = ''.obs;
  RxString currentLocation = 'Searching Location...'.obs;
  RxBool isLocationReady = false.obs;

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
        Fluttertoast.showToast(msg: "Camera Error : Camera not found");
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
      Fluttertoast.showToast(
        msg: "Failed to initialize camera. Ensure permission has been granted.",
        backgroundColor: Colors.red,
        textColor: Colors.white,
        toastLength: Toast.LENGTH_LONG,
      );
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
          throw PermissionDeniedException("Location permission denied by user.");
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw PermissionDeniedException(
            "Location permission is permanently denied. Please enable it manually in settings.");
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.medium,
      ).timeout(const Duration(seconds: 15));
      
      await _updateLocationFromPosition(position);

    } on TimeoutException {
      currentLocation('Failed to get location');
      isLocationReady(false);
      Fluttertoast.showToast(
        msg: "Request Timed Out: GPS signal is weak. Try again in an open area.",
        backgroundColor: Colors.orange,
        textColor: Colors.white,
        toastLength: Toast.LENGTH_LONG,
      );
    } on PermissionDeniedException catch (e) {
      currentLocation('Location permission denied');
      isLocationReady(false);
      Fluttertoast.showToast(
        msg: e.message ?? "Permission denied. Please enable it in the app settings.",
        backgroundColor: Colors.red,
        textColor: Colors.white,
        toastLength: Toast.LENGTH_LONG,
      );
    } on LocationServiceDisabledException {
      currentLocation('Location service is off');
      isLocationReady(false);
      Fluttertoast.showToast(
        msg: "GPS is not Active. Please enable location services.",
        backgroundColor: Colors.red,
        textColor: Colors.white,
        toastLength: Toast.LENGTH_LONG,
      );
    } catch (e) {
      currentLocation('An error occurred');
      isLocationReady(false);
      Fluttertoast.showToast(
        msg: "An unknown error occurred: $e",
        toastLength: Toast.LENGTH_LONG,
      );
      print("Unknown error: $e");
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
        String address = "${place.street}, ${place.subLocality}, ${place.locality}";
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
  }

  void checkIn() async {
    if (!isLocationReady.value) {
      Fluttertoast.showToast(
        msg: "Cannot check in. Please wait until your location is found.",
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return;
    }

    try {
      isCheckingIn(true); 

      final response = await _apiService.post(
        '/attendance/clock-in',
        data: {
          'note': currentLocation.value,
          'method': 'MOBILE'
        },
      );

      if (response.statusCode == 201) {
        final Map<String, String> arguments = {
          'time': currentTime.value,
          'location': currentLocation.value,
        };
        
        cameraController?.dispose();
        timer?.cancel();
        cameraController = null;
        
        Get.offNamed(AppRoutes.CHECK_IN_SUCCESS, arguments: arguments);
      } else {
        Fluttertoast.showToast(msg: "Failed to clock in. Server returned status: ${response.statusCode}");
      }
    } catch (e) {
      print("Error during clock in: $e");
      Fluttertoast.showToast(msg: "An error occurred during clock in.");
    } finally {
      isCheckingIn(false);
    }
  }
}