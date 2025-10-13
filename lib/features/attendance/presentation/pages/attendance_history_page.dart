import 'package:employment_attendance/core/constants/app_colors.dart';
import 'package:employment_attendance/core/constants/app_strings.dart';
import 'package:employment_attendance/core/widgets/loading_widget.dart';
import 'package:employment_attendance/features/attendance/presentation/controllers/attendance_controller.dart';
import 'package:employment_attendance/features/attendance/presentation/widgets/attendance_card.dart';
import 'package:employment_attendance/features/attendance/presentation/widgets/leave_request_button.dart';
import 'package:employment_attendance/features/dashboard/presentation/widgets/custom_bottom_navbar.dart';
import 'package:employment_attendance/navigation/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AttendanceHistoryPage extends StatelessWidget {
  const AttendanceHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final AttendanceController controller = Get.put(AttendanceController());

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text(
          'Attendance History',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.grey[100],
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                    child: _buildDropdown(controller.months,
                        controller.selectedMonth, controller)),
                const SizedBox(width: 8),
                Expanded(
                    child: _buildDropdown(
                        controller.years, controller.selectedYear, controller)),
                const SizedBox(width: 8),
                Expanded(
                    child: _buildDropdown(controller.statuses,
                        controller.selectedStatus, controller)),
              ],
            ),
            const SizedBox(height: 24),
            const LeaveRequestButton(),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const LoadingWidget(message: AppStrings.loading);
                }

                if (controller.attendanceList.isEmpty) {
                  return const Center(
                    child: Text(
                      'There is no history of absence.',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  );
                }

                return ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: controller.attendanceList.length,
                  itemBuilder: (context, index) {
                    final attendanceData = controller.attendanceList[index];
                    return AttendanceCard(attendance: attendanceData);
                  },
                );
              }),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNav(
        currentIndex: 1,
        onTap: (index) {
          if (index == 0) Get.offAllNamed(AppRoutes.dashboard);
          if (index == 1) Get.offAllNamed(AppRoutes.attendanceHistory);
          if (index == 2) Get.offAllNamed(AppRoutes.checkIn);
          if (index == 3) Get.offAllNamed(AppRoutes.lms);
          if (index == 4) Get.offAllNamed(AppRoutes.slip);
        },
      ),
    );
  }

  Widget _buildDropdown(List<String> items, RxString selectedValue,
      AttendanceController controller) {
    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.primary, width: 1.5),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Obx(
        () => DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            isExpanded: true,
            value: selectedValue.value,
            icon: const Icon(Icons.keyboard_arrow_down,
                color: AppColors.primary, size: 20),
            style: const TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
            items: items.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(
                  value,
                  style: const TextStyle(color: Colors.black, fontSize: 12),
                  overflow: TextOverflow.ellipsis,
                ),
              );
            }).toList(),
            onChanged: (newValue) {
              if (newValue != null) {
                selectedValue.value = newValue;
                controller.fetchAttendanceHistory();
              }
            },
          ),
        ),
      ),
    );
  }
}
