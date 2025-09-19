import 'dart:async';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class DashboardController extends GetxController {
  var location = 'Mencari lokasi...'.obs;

  @override
  void onInit() {
    super.onInit();
    _getCurrentLocation(); 
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      location.value = 'Location services are down';
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        location.value = 'Location permission denied';
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      location.value = 'Location permit permanently rejected';
      return;
    }

    try {
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
      Placemark place = placemarks[0];
      
      location.value = "${place.locality}, ${place.country}";
    } catch (e) {
      location.value = "Failed to get address";
    }
  }
  
}