import 'dart:io';

import 'package:employment_attendance/task/domain/models/task_model.dart';
import 'package:employment_attendance/task/presentation/controllers/task_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TaskCard extends StatelessWidget {
  final Task task;
  const TaskCard({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    final TaskController controller = Get.find();
    final statusColor = task.status == 'Pending' ? Colors.orange : Colors.green;
    final statusBgColor =
        task.status == 'Pending' ? Colors.orange[100] : Colors.green[100];

    Widget imageWidget;
    if (task.image.startsWith('assets/')) {
      imageWidget = Image.asset(
        task.image,
        height: 60,
        width: 60,
        fit: BoxFit.cover,
      );
    } else {
      imageWidget = Image.file(
        File(task.image),
        height: 60,
        width: 60,
        fit: BoxFit.cover,
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
                    task.status == 'Pending'
                        ? Icons.check_circle_outline
                        : Icons.pending_actions_outlined,
                    color: Colors.green,
                  ),
                  title: Text(
                    task.status == 'Pending'
                        ? 'Mark as Completed'
                        : 'Mark as Pending',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  onTap: () {
                    controller.updateTaskStatus(task.id);
                     
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
              color: Colors.black.withOpacity(0.1),
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
                  color: Color(0xFF6EA07A),
                ),
                const SizedBox(
                  width: 8,
                ),
                Text(
                  task.date,
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusBgColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    task.status,
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
                  child: Image.asset(
                    task.image,
                    height: 60,
                    width: 60,
                    fit: BoxFit.cover,
                  ),
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
                      SizedBox(height: 4),
                      Text(
                        task.description,
                        style: const TextStyle(
                            color: Colors.grey, fontWeight: FontWeight.bold),
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
