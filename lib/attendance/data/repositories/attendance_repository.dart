import 'package:employment_attendance/attendance/domain/models/attendance_model.dart';

class AttendanceRepository {
  Future<List<AttendanceModel>> getAttendanceHistory() async {
    await Future.delayed(const Duration(milliseconds: 500));
    
    print("Mengambil data dummy dari AttendanceRepository...");
    return [
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
    ];
  }
}