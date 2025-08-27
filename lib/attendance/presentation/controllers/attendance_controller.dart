import 'package:get/get.dart';

class AttendanceModel {
  final String date;
  final String day;
  final String checkIn;
  final String checkOut;
  final String totalHours;
  final String location;

  AttendanceModel({
    required this.date,
    required this.day,
    required this.checkIn,
    required this.checkOut,
    required this.totalHours,
    required this.location,
  });
}

class AttendanceController extends GetxController {
  final List<String> months = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];
  final List<String> years = ['2025', '2024', '2023'];
  final List<String> statuses = ['All Status', 'Present', 'Absent', 'Leave'];

  var selectedMonth = 'August'.obs;
  var selectedYear = '2025'.obs;
  var selectedStatus = 'All Status'.obs;

  final attendanceList = <AttendanceModel>[
    AttendanceModel(
      date: '22',
      day: 'Wed',
      checkIn: '07:59',
      checkOut: '17:02',
      totalHours: '09:03',
      location: 'Office, Bandung, Indonesia',
    ),
    AttendanceModel(
      date: '21',
      day: 'Tue',
      checkIn: '08:01',
      checkOut: '17:05',
      totalHours: '09:04',
      location: 'Office, Bandung, Indonesia',
    ),
    AttendanceModel(
      date: '20',
      day: 'Mon',
      checkIn: '07:55',
      checkOut: '17:00',
      totalHours: '09:05',
      location: 'Office, Bandung, Indonesia',
    ),
  ].obs;
}