import 'package:employment_attendance/attendance/data/repositories/attendance_repository.dart';
import 'package:employment_attendance/attendance/domain/models/attendance_model.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AttendanceController extends GetxController {
  final AttendanceRepository _repository = AttendanceRepository();

  var attendanceList = <AttendanceModel>[].obs;
  var isLoading = true.obs;

  final List<String> months = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];
  final List<String> years = ['2025', '2024', '2023'];
  final List<String> statuses = ['All Status', 'Present', 'Late', 'Absent'];

  var selectedMonth = 'September'.obs;
  var selectedYear = '2025'.obs;
  var selectedStatus = 'All Status'.obs;

  @override
  void onInit() {
    super.onInit();
    final now = DateTime.now();
    selectedMonth.value = DateFormat('MMMM').format(now);
    selectedYear.value = now.year.toString();

    fetchAttendanceHistory();
  }

  void fetchAttendanceHistory() async {
    try {
      isLoading.value = true;
      var result = await _repository.getAttendanceHistory(
        month: selectedMonth.value,
        year: selectedYear.value,
        status: selectedStatus.value,
      );
      attendanceList.assignAll(result);
    } finally {
      isLoading.value = false;
    }
  }
}