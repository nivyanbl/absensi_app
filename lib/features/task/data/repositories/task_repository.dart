import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:employment_attendance/core/services/api_service.dart';
import 'package:employment_attendance/core/error/failures.dart';
import 'package:employment_attendance/features/task/domain/models/task_plan_model.dart';
import 'package:employment_attendance/features/task/domain/models/task_entry_model.dart';

class TaskRepository {
  final ApiService _apiService = Get.find<ApiService>();

  Future<TaskPlan> createTodayPlan({
    required String summary,
    required List<TaskEntry> tasks,
  }) async {
    try {
      final taskData = tasks.map((task) => task.toJson()).toList();
      final response = await _apiService.post(
        '/tasks/plans',
        data: {
          'summary': summary,
          'tasks': taskData,
        },
      );
      if (response.statusCode == 201) {
        return TaskPlan.fromJson(response.data['data']);
      } else {
        throw ServerFailure(
            'Failed to create plan. Status: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw ServerFailure(
          e.response?.data['message'] ?? e.message ?? 'An error occurred');
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  Future<TaskPlan> updateTodayPlan({
    required String planId,
    required String summary,
    required List<TaskEntry> tasks,
  }) async {
    try {
      final taskData = tasks.map((task) => task.toJson()).toList();

      final response = await _apiService.patch(
        '/tasks/plans/$planId',
        data: {
          'summary': summary,
          'tasks': taskData,
        },
      );

      if (response.statusCode == 200) {
        return TaskPlan.fromJson(response.data['data']);
      } else {
        throw ServerFailure(
            'Failed to update plan. Status: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw ServerFailure(
          e.response?.data['message'] ?? e.message ?? 'An error occurred');
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  //Get Today Plan (GET /api/tasks/plans/today)
  Future<TaskPlan?> getTodayPlan() async {
    try {
      final response = await _apiService.get('/tasks/plans/today');

      if (response.statusCode == 200) {
        return TaskPlan.fromJson(response.data['data']);
      } else {
        throw ServerFailure(
            "Failed to get today's plan. Status: ${response.statusCode}");
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        return null; 
      }
      throw ServerFailure(
          e.response?.data['message'] ?? e.message ?? 'An error occurred');
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  // List History (GET /api/tasks/history)
  Future<List<TaskPlan>> getHistory({
    String? from,
    String? to,
    int page = 1,
    int pageSize = 10,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'page': page,
        'pageSize': pageSize,
      };
      if (from != null) queryParams['from'] = from;
      if (to != null) queryParams['to'] = to;

      final response = await _apiService.get(
        '/tasks/history',
        queryParameters: queryParams,
      );

      if (response.statusCode == 200) {
        List<TaskPlan> plans = (response.data['data'] as List)
            .map((planJson) => TaskPlan.fromJson(planJson))
            .toList();
        return plans;
      } else {
        throw ServerFailure(
            'Failed to fetch history. Status: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw ServerFailure(
          e.response?.data['message'] ?? e.message ?? 'An error occurred');
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  // Task Entry (PATCH /api/tasks/entries/:entryId)
  Future<TaskEntry> updateTaskEntry(String entryId, TaskEntry task) async {
    try {
      final response = await _apiService.patch(
        '/tasks/entries/$entryId',
        data: task.toJson(),
      );

      if (response.statusCode == 200) {
        return TaskEntry.fromJson(response.data['data']);
      } else {
        throw ServerFailure(
            'Failed to update task. Status: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw ServerFailure(
          e.response?.data['message'] ?? e.message ?? 'An error occurred');
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }
}
