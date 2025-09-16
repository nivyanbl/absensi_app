import 'dart:async';
import 'package:employment_attendance/core/services/api_service.dart';
import 'package:employment_attendance/profile/presentation/controller/profile_controller.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class CheckOutController extends GetxController {
  final ApiService _apiService = ApiService();
  final ProfileController _profileController = Get.find<ProfileController>();

  var isCheckingOut = false.obs;
  Timer? _timer;

  var userName = 'Loading...'.obs;
  var userPosition = '...'.obs;
  var checkInTime = '--:--'.obs;
  var checkInLocation = '...'.obs;
  var currentTime = '--:--:--'.obs;

  @override
  void onInit() {
    super.onInit();
    _loadInitialData();
    _startTimer();
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      currentTime.value = DateFormat('HH:mm:ss').format(DateTime.now());
    });
  }

  Future<void> _loadInitialData() async {
    userName.value = _profileController.user.value?.fullName ?? 'Name Not Found';
    userPosition.value = "UI UX Designer"; 

    try {
      final response = await _apiService.get('/attendance/latest');
      if (response.statusCode == 200 && response.data['data'] != null) {
        final attendanceData = response.data['data'];
        final clockInDateTime = DateTime.parse(attendanceData['clockInAt']).toLocal();
        checkInTime.value = DateFormat('HH:mm a').format(clockInDateTime);
        checkInLocation.value = attendanceData['note'] ?? 'Location not recorded';
      } else {
        checkInTime.value = 'N/A';
        checkInLocation.value = 'No check-in today';
      }
    } catch (e) {
      checkInTime.value = 'Error';
      checkInLocation.value = 'Failed to load data';
      print("Error fetching latest attendance: $e");
    }
  }

  void checkOutNow() async {
    try {
      isCheckingOut(true);
      final response = await _apiService.post('/attendance/clock-out');

      if (response.statusCode == 200) {
        Get.back(); 
        Get.snackbar('Succeed', 'You have successfully checked out.');
      } else {
        final errorMessage = response.data['message'] ?? 'Failed to check out.';
        Get.snackbar('Failed', errorMessage);
      }
    } catch (e) {
      Get.snackbar('Error', 'there is an error: ${e.toString()}');
    } finally {
      isCheckingOut(false);
    }
  }
}