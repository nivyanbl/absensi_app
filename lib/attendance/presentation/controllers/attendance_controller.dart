import 'package:get/get.dart';
import 'package:employment_attendance/attendance/data/repositories/attendance_repository.dart';
import 'package:employment_attendance/attendance/domain/models/attendance_model.dart';

class AttendanceController extends GetxController {
  final AttendanceRepository _attendanceRepository = AttendanceRepository();

  final List<String> months = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];
  final List<String> years = ['2025', '2024', '2023'];
  final List<String> statuses = ['All Status', 'Present', 'Absent', 'Leave'];

  var selectedMonth = 'August'.obs;
  var selectedYear = '2025'.obs;
  var selectedStatus = 'All Status'.obs;

  var attendanceList = <AttendanceModel>[].obs;
  var isLoading = true.obs;
  
  @override
  void onInit() {
    super.onInit();
    fetchAttendanceHistory();
  }
  void fetchAttendanceHistory() async {
    try {
      isLoading.value = true;
      var fetchedData = await _attendanceRepository.getAttendanceHistory();
      attendanceList.assignAll(fetchedData);
    } finally {
      isLoading.value = false;
    }
  }
}