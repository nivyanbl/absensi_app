import 'package:employment_attendance/dashboard/presentation/controllers/dashboard_controller.dart';
import 'package:employment_attendance/dashboard/presentation/widgets/overview_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OverviewGrid extends StatelessWidget {
  const OverviewGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final DashboardController controller = Get.find<DashboardController>();
    const  Color primaryColor =  Color(0xFF6EA07A);

    return Obx(() {
      final overviewData = [
        {
          "icon": Icons.login,
          "label": "Check In",
          "value": controller.checkInTime.value
        },
        {
          "icon": Icons.logout,
          "label": "Check Out",
          "value": controller.checkOutTime.value
        },
        {
          "icon": Icons.calendar_today,
          "label": "Absence",
          "value": controller.totalAbsence.value
        },
        {
          "icon": Icons.check_circle,
          "label": "Total Attended",
          "value": controller.totalAttended.value
        },
      ];
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Overview",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: overviewData.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1.6,
            ),
            itemBuilder: (context, index) {
              final data = overviewData[index];
              return OverviewCard(
                icon: data["icon"] as IconData,
                label: data["label"] as String,
                value: data["value"] as String,
                primaryColor: primaryColor,
              );
            },
          ),
        ],
      );
    });
  }
}
