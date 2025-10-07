import 'package:employment_attendance/features/profile/presentation/controller/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:employment_attendance/features/leave/domain/models/leave_model.dart';

class LeaveHistoryCard extends StatelessWidget {
  final LeaveModel leave;
  final ProfileController profileController = Get.find<ProfileController>();

  LeaveHistoryCard({
    super.key,
    required this.leave,
  });

  @override
  Widget build(BuildContext context) {
    String status = leave.status ?? 'UNKNOWN';
    String type = leave.type ?? 'UNKNOWN';
    String startDate = leave.startDate ?? 'N/A';
    String endDate = leave.endDate ?? 'N/A';

    Color statusColor = Colors.grey;
    Color statusBgColor = Colors.grey[200]!;
    IconData statusIcon = Icons.help_outline;

    switch (status) {
      case 'APPROVED':
        statusColor = const Color(0xFF6EA07A);
        statusBgColor = const Color(0xFFE9F5E9);
        statusIcon = Icons.check_circle;
        break;
      case 'PENDING':
        statusColor = Colors.orange;
        statusBgColor = Colors.orange[100]!;
        statusIcon = Icons.hourglass_bottom;
        break;
      case 'REJECTED':
        statusColor = Colors.red;
        statusBgColor = Colors.red[100]!;
        statusIcon = Icons.cancel;
        break;
      case 'CANCELLED':
        statusColor = Colors.grey;
        statusBgColor = Colors.grey[200]!;
        statusIcon = Icons.cancel;
        break;
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: statusBgColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      statusIcon,
                      size: 16,
                      color: statusColor,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      status,
                      style: TextStyle(
                        color: statusColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Text(type, style: const TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.person, size: 16, color: Colors.grey),
              const SizedBox(width: 4),
              Obx(() {
                final userName = profileController.user.value?.fullName;
                return Text(userName ?? "Loading...",
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.black));
              }),
              const SizedBox(width: 8),
              const Text('UI / UX Designer', style: TextStyle(color: Colors.grey)),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
              const SizedBox(width: 4),
              Text(
                startDate != 'N/A'
                    ? DateFormat('yyyy-MM-dd').format(DateTime.parse(startDate))
                    : 'N/A',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 8),
              Text(
                endDate != 'N/A'
                    ? DateFormat('yyyy-MM-dd').format(DateTime.parse(endDate))
                    : 'N/A',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
