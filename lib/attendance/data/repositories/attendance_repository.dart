import 'package:employment_attendance/core/services/api_service.dart';
import 'package:intl/intl.dart';
import 'package:employment_attendance/attendance/domain/models/attendance_model.dart';

class AttendanceRepository {
  final ApiService _apiService = ApiService();

  Future<List<AttendanceModel>> getAttendanceHistory({
    required String month,
    required String year,
    required String status, 
  }) async {
    try {

      final monthNames = [
        'January', 'February', 'March', 'April', 'May', 'June',
        'July', 'August', 'September', 'October', 'November', 'December'
      ];
      final monthNumber = monthNames.indexOf(month) + 1;
      final formattedMonth = '$year-${monthNumber.toString().padLeft(2, '0')}';
      
      final Map<String, dynamic> queryParameters = {
        'month': formattedMonth,
      };

      final response = await _apiService.get('/attendance', queryParameters: queryParameters);

      if (response.statusCode == 200) {
        final responseData = response.data;
        
        final List<dynamic> data;
        if (responseData is List) {
          data = responseData;
        } else if (responseData is Map && responseData.containsKey('data')) {
          data = responseData['data'] as List<dynamic>;
        } else {
          print('Unexpected response format: $responseData');
          return [];
        }


        return data.map((item) {
          final clockIn = DateTime.parse(item['clockInAt']);
          final clockOut = item['clockOutAt'] != null ? DateTime.parse(item['clockOutAt']) : null;
          final minutesWorked = item['minutesWorked'] ?? 0;

          return AttendanceModel(
            date: DateFormat('dd').format(clockIn),
            day: DateFormat('EEE').format(clockIn),
            checkIn: DateFormat('HH:mm').format(clockIn.toLocal()),
            checkOut: clockOut != null ? DateFormat('HH:mm').format(clockOut.toLocal()) : '--:--',
            totalHours: '${(minutesWorked / 60).floor().toString().padLeft(2, '0')}:${(minutesWorked % 60).toString().padLeft(2, '0')}',
            location: item['note'] ?? 'Office, Bandung, Indonesia',
          );
        }).toList(); 
      } else {
        return [];
      }
    } catch (e) {
      print("Error fetching attendance history: $e");
      return [];
    }
  }
}