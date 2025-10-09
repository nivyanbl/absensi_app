import 'package:dio/dio.dart';
import 'package:employment_attendance/core/services/api_service.dart';
import 'package:employment_attendance/features/leave/domain/models/leave_model.dart';
import 'package:flutter/material.dart';

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
      debugPrint('Error creating leave: ${e.response?.data}');
      return null;
    }
  }

  Future<LeaveModel?> cancelLeave({
    required String leaveId,
  }) async {
    try {
      final response = await _apiService.post(
        '/leaves/$leaveId/cancel',
      );
      if (response.statusCode == 200) {
        return LeaveModel.fromJson(response.data['data']);
      }
      return null;
    } on DioException catch (e) {
      debugPrint('Error cancelling leave: ${e.response?.data}');
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
      // If no date range or month/year provided, default to current month
      // because the backend expects a month parameter and returns 422 when missing.
      final now = DateTime.now();
      if (from == null && to == null && month == null && year == null) {
        month = '${now.year}-${now.month.toString().padLeft(2, '0')}';
      }

      // Normalize month parameter: backend expects 'YYYY-MM'. Accept callers
      // passing a month name (e.g. 'September') + year and convert it.
      String? monthParam;
      if (month != null) {
        final mNonNull = month;
        // If month already looks like 'YYYY-MM' or contains a dash, pass it through
        final looksFormatted = RegExp(r"^\d{4}-\d{2}").hasMatch(mNonNull);
        if (looksFormatted) {
          monthParam = mNonNull;
        } else if (RegExp(r'[A-Za-z]').hasMatch(mNonNull) && year != null) {
          // Convert month name to month number
          final monthNames = [
            'January',
            'February',
            'March',
            'April',
            'May',
            'June',
            'July',
            'August',
            'September',
            'October',
            'November',
            'December'
          ];
          final idx = monthNames
              .indexWhere((m) => m.toLowerCase() == mNonNull.toLowerCase());
          if (idx >= 0) {
            final mNum = (idx + 1).toString().padLeft(2, '0');
            monthParam = '$year-$mNum';
          } else {
            // fallback: try to parse numeric month
            final asNum = int.tryParse(month);
            if (asNum != null) {
              monthParam = '$year-${asNum.toString().padLeft(2, '0')}';
            } else {
              monthParam = month; // pass through and let server validate
            }
          }
        } else if (year != null && int.tryParse(month) != null) {
          // numeric month like '9' -> convert
          final asNum = int.parse(month);
          monthParam = '$year-${asNum.toString().padLeft(2, '0')}';
        } else {
          monthParam = month;
        }
      }

      final Map<String, dynamic> queryParameters = {
        if (from != null) 'from': from,
        if (to != null) 'to': to,
        if (monthParam != null) 'month': monthParam,
        if (year != null) 'year': year,
        if (type != null) 'type': type,
        if (status != null) 'status': status,
        if (page != null) 'page': page,
        if (pageSize != null) 'pageSize': pageSize,
      };

      final response =
          await _apiService.get('/leaves', queryParameters: queryParameters);
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'];
        return data.map((json) => LeaveModel.fromJson(json)).toList();
      }
      return [];
    } on DioException catch (e) {
      debugPrint('Error fetching leaves: ${e.response?.data}');
      return [];
    }
  }
}
