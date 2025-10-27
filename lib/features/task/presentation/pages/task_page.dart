import 'package:employment_attendance/core/constants/app_colors.dart';
import 'package:employment_attendance/core/widgets/empty_widget.dart';
import 'package:employment_attendance/core/widgets/error_widget.dart';
import 'package:employment_attendance/core/widgets/loading_widget.dart';
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
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: IconButton(
              icon: const Icon(
                Icons.refresh,
                color: Colors.white,
              ),
              onPressed: () => controller.loadTodayPlan(),
            ),
          ),
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
                child: Obx(() {
                  switch (controller.pageState.value) {
                    case PageState.loading:
                      return const LoadingWidget();
                    case PageState.error:
                      return ErrorDisplayWidget(
                        message: controller.errorMessage.value ??
                            'Something went wrong',
                        onRetry: () => controller.loadTodayPlan(),
                      );
                    case PageState.empty:
                      return const EmptyWidget(
                        message: 'No plan for today yet. Please create one.',
                      );
                    case PageState.success:
                      return _buildTaskPlanView(context, controller);
                  }
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTaskPlanView(BuildContext context, TaskController controller) {
    return Obx(() {
      final plan = controller.todayPlan.value;
      if (plan == null) {
        return const EmptyWidget(message: 'Plan tidak ditemukan.');
      }

      return RefreshIndicator(
        onRefresh: () => controller.loadTodayPlan(),
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            if (plan.summary != null && plan.summary!.isNotEmpty)
              Card(
                elevation: 2,
                margin: const EdgeInsets.only(bottom: 16),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Today's Focus:",
                        style: Theme.of(context)
                            .textTheme
                            .titleSmall
                            ?.copyWith(color: AppColors.primary),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        plan.summary!,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ],
                  ),
                ),
              ),

            Text(
              'Tasks (${plan.tasks.length})',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            if (plan.tasks.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 32.0),
                child: Center(child: Text('No tasks in this plan.')),
              ),

            ListView.builder(
              itemCount: plan.tasks.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                final task = plan.tasks[index];
                return TaskCard(task: task); 
              },
            ),
          ],
        ),
      );
    });
  }
}
