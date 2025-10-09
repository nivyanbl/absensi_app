import 'package:employment_attendance/core/constants/app_colors.dart';
import 'package:employment_attendance/features/task/presentation/controllers/task_controller.dart';
import 'package:employment_attendance/features/task/presentation/widgets/create_task_button.dart';
import 'package:employment_attendance/features/task/presentation/widgets/task_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TaskPage extends StatelessWidget {
  const TaskPage({super.key});

  @override
  Widget build(BuildContext context) {
    final TaskController controller = Get.put(TaskController());
    return Scaffold(
      backgroundColor: AppColors.primary,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 80,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () => Get.back(),
        ),
        title: const Center(
            child: Text(
          "Task",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 24,
          ),
        )),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Icon(
              Icons.filter_alt_rounded,
              color: Colors.white,
            ),
          )
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
          child: Column(
            children: [
              const CreateTaskButton(),
              Expanded(
                child: Obx(() => ListView.builder(
                      itemCount: controller.tasks.length,
                      itemBuilder: (BuildContext context, int index) {
                        final task = controller.tasks[index];
                        return TaskCard(task: task);
                      },
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
