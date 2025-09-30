import 'package:dio/dio.dart';
import 'package:employment_attendance/core/services/api_service.dart';
import 'package:employment_attendance/leave/domain/models/leave_model.dart';

class LeaveRepository {
  final ApiService _apiService = ApiService();

  Future<LeaveModel?> createLeave({
    required String type,
    required String startDate,
    required String endDate,
    String? reason,
  }) async {
    try {
      final response = await _apiService.post(
        '/leaves',
        data: {
          'type': type,
          'startDate': startDate,
          'endDate': endDate,
          'reason': reason,
        },
      );

      if (response.statusCode == 201) {
        return LeaveModel.fromJson(response.data['data']);
      }
      return null;
    } on DioException catch (e) {
      print('Error creating leave: ${e.response?.data}');
      return null;
    }
  }

  Future<LeaveModel?> cancelLeave({
    required String leaveId,
  }) async {
    try {
      final response = await _apiService.post('/leaves/$leaveId/cancel',
      );
      if (response.statusCode == 200 ) {
        return LeaveModel.fromJson(response.data['data']);
      }
      return null;
    } on DioException catch (e) {
      print('Error cancelling leave: ${e.response?.data}');
      return null;
    }
  }

  Future<List<LeaveModel>> listLeaves({
    String? from,
    String? to,
    String? month,
    String? year,
    String? type,
    String? status,
    int? page,
    int? pageSize,
  }) async {
    try {
      final Map<String, dynamic> queryParameters = {
        if (from != null) 'from':from,
        if (to != null) 'to':to,
        if (month != null) 'month' :month,
        if (year != null) 'year':year,
        if (type != null) 'type':type,
        if (status != null) 'status':status,
        if (page != null) 'page':page,
        if (pageSize != null) 'pageSize':pageSize,

      };

      final response = await _apiService.get('/leaves',queryParameters: queryParameters);
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data ['data'];
        return data.map((json)=> LeaveModel.fromJson(json)).toList(); 
      }
      return [];
    } on DioException catch (e) {
      print('Error fetching leaves: ${e.response?.data}');
      return [];
    }
  }
}
