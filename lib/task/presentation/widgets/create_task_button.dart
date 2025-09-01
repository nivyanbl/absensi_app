import 'package:employment_attendance/task/presentation/pages/create_task_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class CreateTaskButton extends StatelessWidget {
  const CreateTaskButton({super.key});

  @override
  Widget build(BuildContext context) {
    
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: InkWell(
          onTap: () {
            Get.to(() => const CreateTaskPage());
          },
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CircleAvatar(
                backgroundColor: Color(0xFF6EA07A),
                radius: 24,
                child:  Icon(
                  Icons.add,
                  color: Colors.white,
                  size: 32,
                ),
              ),
               SizedBox(
                width: 16,
              ),
               Text(
                "CREATE TASK",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
