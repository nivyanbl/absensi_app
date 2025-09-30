import 'dart:async';
import 'package:employment_attendance/attendance/data/repositories/attendance_repository.dart';
import 'package:employment_attendance/leave/data/repositories/leave_repository.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:intl/intl.dart';

class DashboardController extends GetxController {
  final AttendanceRepository _attendanceRepository = AttendanceRepository();
  final LeaveRepository _leaveRepository = LeaveRepository();
  
  var location = 'Search location...'.obs;
  // Use empty string to indicate no data; OverviewCard will render a placeholder
  var checkInTime = ''.obs;
  var checkOutTime = ''.obs;
  var totalAttended = '0 Days'.obs;
  var totalAbsence = '0 Days'.obs;

  @override
  void onInit() {
    super.onInit();
    _loadDashboardData();
    // start a lightweight periodic refresh so overview stays up-to-date
    _startAutoRefresh();
  }

  Timer? _pollTimer;
  static const Duration _pollInterval = Duration(seconds: 60);

  void _startAutoRefresh() {
    _pollTimer?.cancel();
    _pollTimer = Timer.periodic(_pollInterval, (_) async {
      try {
        await _fetchAttendanceOverview();
        await _fetchLeaveOverview();
      } catch (_) {}
    });
  }

  /// Public helper to refresh dashboard data from other pages/controllers.
  /// Calls the same loading logic used during init.
  Future<void> refresh() async {
    await _loadDashboardData();
  }

  Future<void> _loadDashboardData() async {
    _getCurrentLocation();
    await _fetchAttendanceOverview();
    await _fetchLeaveOverview();
  }

  Future<void> _fetchAttendanceOverview() async {
    try {
      final now = DateTime.now();
      final monthName = DateFormat('MMMM').format(now);
      final year = now.year.toString();
      
      final attendanceHistory = await _attendanceRepository.getAttendanceHistory(
        month: monthName,
        year: year,
        status: 'Present',
      );
      
      final todayAttendance = attendanceHistory.firstWhereOrNull(
        (att) => att.date == DateFormat('dd').format(now),
      );

      if (todayAttendance != null) {
        checkInTime.value = todayAttendance.checkIn;
        checkOutTime.value = todayAttendance.checkOut;
      } else {
        checkInTime.value = '';
        checkOutTime.value = '';
      }
      
      totalAttended.value = '${attendanceHistory.length} Days';
      
    } catch (e) {
      print("Error fetching attendance overview: $e");
    }
  }

  Future<void> _fetchLeaveOverview() async {
    try {
      final leaveHistory = await _leaveRepository.listLeaves(
        month : DateFormat('MMMM').format(DateTime.now()),
        year : DateTime.now().year.toString(),
        status: "APPROVED"
      );
      totalAbsence.value = '${leaveHistory.length} Days';
    } catch (e) {
      print("Error fetching leave overview: $e");
    }
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
      
      String? city = place.subAdministrativeArea;
      String? country = place.country;

      if (city != null && city.isNotEmpty && country != null && country.isNotEmpty) {
        location.value = "$city, $country";
      } else {
        location.value = "Failed to get address";
      }
    } catch (e) {
      location.value = "Failed to get address";
    }
  }
  @override
  void onClose() {
    _pollTimer?.cancel();
    super.onClose();
  }
  
}