// lib/features/task/presentation/widgets/task_card.dart
// DIUBAH untuk model baru, dengan DESAIN LAMA dipertahankan

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:employment_attendance/core/constants/app_colors.dart';
import 'package:employment_attendance/features/task/presentation/controllers/task_controller.dart';
import 'package:employment_attendance/features/task/domain/models/task_entry_model.dart';
import 'package:intl/intl.dart';

class TaskCard extends StatelessWidget {
  final TaskEntry task;
  const TaskCard({super.key, required this.task});

  String _formatDate(DateTime date) {
    final formatter = DateFormat('EEEE, d MMM yyyy', 'en_US');
    return formatter.format(date).toLowerCase();
  }

  @override
  Widget build(BuildContext context) {
    final TaskController controller = Get.find();
    final bool isPending = task.status != TaskStatus.DONE;

    final statusColor = isPending ? Colors.orange : Colors.green;
    final statusBgColor = isPending ? Colors.orange[100] : Colors.green[100];
    final statusText = isPending ? "Pending" : "Completed";

    Widget imageWidget;
    final firstUrl = task.attachments.isNotEmpty ? task.attachments[0].url : '';
    final lower = firstUrl.toLowerCase();
    final isHttp = lower.startsWith('http');
    final looksLikeImage = lower.endsWith('.png') ||
        lower.endsWith('.jpg') ||
        lower.endsWith('.jpeg') ||
        lower.endsWith('.gif') ||
        lower.endsWith('.webp');

    if (isHttp && looksLikeImage) {
      imageWidget = Image.network(
        firstUrl,
        height: 60,
        width: 60,
        fit: BoxFit.cover,
        errorBuilder: (context, error, StackTrace? stackTrace) {
          debugPrint("Error loading image: $error");
          return Container(
            height: 60,
            width: 60,
            color: Colors.grey[200],
            child: const Icon(
              Icons.insert_drive_file,
              color: Colors.grey,
            ),
          );
        },
      );
    } else {
      imageWidget = Container(
        height: 60,
        width: 60,
        color: Colors.grey[200],
        child: const Icon(
          Icons.insert_drive_file,
          color: Colors.grey,
        ),
      );
    }

    return GestureDetector(
      onLongPress: () {
        Get.bottomSheet(
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Wrap(
              children: <Widget>[
                ListTile(
                  leading: Icon(
                    isPending
                        ? Icons.check_circle_outline
                        : Icons.pending_actions_outlined,
                    color: Colors.green,
                  ),
                  title: Text(
                    isPending ? 'Mark as Completed' : 'Mark as Pending',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  onTap: () {
                    if (isPending) {
                      controller.updateTaskStatus(task, TaskStatus.DONE);
                    } else {
                      controller.updateTaskStatus(task, TaskStatus.PLANNED);
                    }
                    Get.back();
                  },
                ),
              ],
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.calendar_month,
                  size: 16,
                  color: AppColors.primary,
                ),
                const SizedBox(
                  width: 8,
                ),
                Expanded(
                  child: Text(
                    task.createdAt != null
                        ? _formatDate(task.createdAt!)
                        : 'No Date',
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusBgColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    statusText,
                    style: TextStyle(
                      color: statusColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const Divider(
              indent: 1,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: imageWidget,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        task.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        task.description ?? '',
                        style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
