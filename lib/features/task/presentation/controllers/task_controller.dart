import 'package:employment_attendance/core/error/failures.dart';
import 'package:employment_attendance/features/task/data/repositories/task_repository.dart';
import 'package:employment_attendance/features/task/domain/models/task_plan_model.dart';
import 'package:employment_attendance/features/task/domain/models/task_entry_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum PageState { loading, error, success, empty }

class TaskController extends GetxController {
  final TaskRepository _taskRepository = TaskRepository();

  var pageState = PageState.loading.obs;
  var errorMessage = Rxn<String>();
  var todayPlan = Rxn<TaskPlan>();

  @override
  void onInit() {
    super.onInit();
    loadTodayPlan();
  }

  Future<void> loadTodayPlan() async {
    pageState.value = PageState.loading;
    errorMessage.value = null;

    try {
      final plan = await _taskRepository.getTodayPlan();
      if (plan == null) {
        pageState.value = PageState.empty;
      } else {
        todayPlan.value = plan;
        pageState.value = PageState.success;
      }
    } on ServerFailure catch (e) {
      pageState.value = PageState.error;
      errorMessage.value = e.message;
    } catch (e) {
      pageState.value = PageState.error;
      errorMessage.value = 'An error occurred: ${e.toString()}';
    }
  }

  Future<void> createPlan(String summary, List<TaskEntry> tasks) async {
    try {
      final plan = await _taskRepository.createTodayPlan(
        summary: summary,
        tasks: tasks,
      );

      todayPlan.value = plan;
      pageState.value = PageState.success;
      Get.back();
      Get.snackbar(
        'Success',
        'Plan created successfully',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } on ServerFailure catch (e) {
      Get.snackbar(
        'Error',
        e.message,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'An error occurred: ${e.toString()}',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> updateTaskStatus(TaskEntry task, TaskStatus newStatus) async {
    if (task.id == null) {
      Get.snackbar(
        'Error',
        'Task ID not found',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    final updatedTask = TaskEntry(
      id: task.id,
      title: task.title,
      description: task.description,
      status: newStatus,
      order: task.order,
      attachments: task.attachments,
      createdAt: task.createdAt,
    );

    try {
      final updatedEntry =
          await _taskRepository.updateTaskEntry(task.id!, updatedTask);

      if (todayPlan.value != null) {
        final taskIndex =
            todayPlan.value!.tasks.indexWhere((t) => t.id == task.id);
        if (taskIndex != -1) {
          todayPlan.value!.tasks[taskIndex] = updatedEntry;
          todayPlan.refresh();
        }
      }
      Get.snackbar(
        'Success',
        'Task status updated',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } on ServerFailure catch (e) {
      Get.snackbar(
        'Error',
        e.message,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'An error occurred: ${e.toString()}',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}
