import 'package:employment_attendance/features/task/domain/models/attachment_model.dart';

enum TaskStatus { PLANNED, IN_PROGRESS, DONE }

class TaskEntry {
  final String? id;
  final String? taskPlanId;
  final String title;
  final String? description;
  final TaskStatus status;
  final int order;
  final DateTime? completedAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final List<Attachment> attachments;

  TaskEntry({
    this.id,
    this.taskPlanId,
    required this.title,
    this.description,
    this.status = TaskStatus.PLANNED,
    required this.order,
    this.completedAt,
    this.createdAt,
    this.updatedAt,
    this.attachments = const [],
  });

// helper untuk ngubah string dari API menjadi enum
  static TaskStatus _statusFromString(String statusStr) {
    switch (statusStr.toUpperCase()) {
      case 'IN_PROGRESS':
        return TaskStatus.IN_PROGRESS;
      case 'DONE':
        return TaskStatus.DONE;
      case 'PLANNED':
      default:
        return TaskStatus.PLANNED;
    }
  }

  String get statusString {
    return status.toString().split('.').last;
  }

  factory TaskEntry.fromJson(Map<String, dynamic> json) {
    return TaskEntry(
      id: json['id'],
      taskPlanId: json['taskPlanId'],
      title: json['title'],
      description: json['description'],
      status: _statusFromString(json['status']),
      order: json['order'],
      completedAt: json['completedAt'] != null
          ? DateTime.parse(json['completedAt'])
          : null,
      createdAt:
          json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt:
          json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      attachments: json['attachments'] != null
          ? (json['attachments'] as List)
              .map((item) => Attachment.fromJson(item))
              .toList()
          : [],
    );
  }
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      'title': title,
      'status': statusString,
      'order': order,
    };
    if (description != null && description!.isNotEmpty) {
      map['description'] = description;
    }
    if (attachments.isNotEmpty) {
      map['attachments'] = attachments.map((att) => att.toJson()).toList();
    }
    return map;
  }
}
