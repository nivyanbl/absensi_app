class LeaveModel {
  final String? id;
  final String? userId;
  final String? type;
  final String? startDate;
  final String? endDate;
  final int? totalDays;
  final String? reason;
  final String? status;
  final String? decidedAt;
  final String? createdAt;
  final String? updatedAt;

  LeaveModel({
    this.id,
    this.userId,
    this.type,
    this.startDate,
    this.endDate,
    this.totalDays,
    this.reason,
    this.status,
    this.decidedAt,
    this.createdAt,
    this.updatedAt,
  });


  factory LeaveModel.fromJson(Map<String, dynamic> json) {
    return LeaveModel(
      id: json['id'],
      userId: json['userId'],
      type: json['type'],
      startDate: json['startDate'],
      endDate: json['endDate'],
      totalDays: json['totalDays'],
      reason: json['reason'],
      status: json['status'],
      decidedAt: json['decidedAt'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }
}