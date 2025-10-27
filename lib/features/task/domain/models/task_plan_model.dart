import 'package:employment_attendance/features/task/domain/models/task_entry_model.dart';

class TaskPlan {
  final String id;
  final String userId;
  final DateTime workDate;
  final String? summary;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<TaskEntry> tasks;

  TaskPlan({
    required this.id,
    required this.userId,
    required this.workDate,
    this.summary,
    required this.createdAt,
    required this.updatedAt,
    required this.tasks,
  });

  factory TaskPlan.fromJson(Map<String, dynamic> json) {
    var taskList = (json['tasks'] as List)
        .map((taskJson) => TaskEntry.fromJson(taskJson))
        .toList();

    return TaskPlan(
      id: json['id'],
      userId: json['userId'],
      workDate: DateTime.parse(json['workDate']),
      summary: json['summary'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      tasks: taskList,
    );
  }
}