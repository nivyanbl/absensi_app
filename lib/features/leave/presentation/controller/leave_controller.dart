import 'package:dio/dio.dart';
import 'package:employment_attendance/features/leave/data/repositories/leave_repository.dart';
import 'package:employment_attendance/features/leave/domain/models/leave_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class LeaveController extends GetxController {
  final LeaveRepository _leaveRepository = LeaveRepository();
  var isLoading = false.obs;
  var leaveHistory = <LeaveModel>[].obs;

  var availableLeave = 12.obs;
  var usedLeave = 0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchLeaveHistory();
  }

  Future<void> fetchLeaveHistory({String? from, String? to}) async {
    try {
      isLoading.value = true;
      var results = await _leaveRepository.listLeaves(
        from: from,
        to: to,        
      );
      leaveHistory.assignAll(results);

      int totalUsedDays = 0;
      for (var leave in results.where((l) => l.status == 'APPROVED')) {
          if (leave.totalDays != null) {
              totalUsedDays += leave.totalDays!;
          }
      }
      usedLeave.value = totalUsedDays;
      print("Total leave days used: ${usedLeave.value}"); 

    } catch (e) {
      print('Error fetching leave history: $e');
       Get.snackbar('Error', 'Failed to fetch leave history. Please try again.');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> createLeaveRequest({
    required String type,
    required DateTime startDate,
    required DateTime endDate,
    String? reason,
  }) async {
    try {
      isLoading.value = true;
      final newLeave = await _leaveRepository.createLeave(
        type: type,
        startDate: DateFormat('yyyy-MM-dd').format(startDate),
        endDate: DateFormat('yyyy-MM-dd').format(endDate),
        reason: reason,
      );
      if (newLeave != null) {
        Get.snackbar('Success', 'Leave request created successfully');
        fetchLeaveHistory(); 
      } else {
        Get.snackbar('Error', 'Failed to create leave request');
        
      }
    } on DioException catch (e) {
      if (e.response?.data['error']['code'] == 'LEAVE_OVERLAP') {
        Get.snackbar(
          'Error',
          'Leave request overlaps with an existing leave. Please choose different dates.',
          backgroundColor: Colors.red[100],
          colorText: Colors.black,
        );
      } else {
        Get.snackbar('Error', 'An unexpected error occurred: ${e.response?.data['error']['message']}');
      }
    } finally {
      isLoading.value = false;
    }
  }
}