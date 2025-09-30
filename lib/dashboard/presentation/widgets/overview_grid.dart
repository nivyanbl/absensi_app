import 'package:employment_attendance/dashboard/presentation/controllers/dashboard_controller.dart';
import 'package:employment_attendance/dashboard/presentation/widgets/overview_card.dart';
import 'package:flutter/material.dart';
import 'package:employment_attendance/core/utils/dimensions.dart';
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
      final dims = Dimensions.of(context);
      // choose 2 columns on small screens, 3 on medium, 4 on wide
      final double w = dims.screenWidth;
      int crossAxisCount = 2;
      double aspect = 1.6;
      if (w > 1000) {
        crossAxisCount = 4;
        aspect = 1.4;
      } else if (w > 700) {
        crossAxisCount = 3;
        aspect = 1.5;
      }

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
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: aspect,
            ),
            itemBuilder: (context, index) {
              final data = overviewData[index];
              // map label to route shortcuts
              VoidCallback? onTap;
              final label = data["label"] as String;
              if (label == 'Check In') {
                onTap = () async {
                  await Get.toNamed('/check-in');
                  // refresh dashboard when returning
                  try {
                    await controller.refresh();
                  } catch (_) {}
                };
              } else if (label == 'Check Out') {
                onTap = () async {
                  await Get.toNamed('/check-out');
                  try {
                    await controller.refresh();
                  } catch (_) {}
                };
              } else if (label == 'Absence') {
                onTap = () async {
                  await Get.toNamed('/leave-history');
                };
              } else if (label == 'Total Attended') {
                onTap = () async {
                  await Get.toNamed('/attendance-history');
                };
              }

              return OverviewCard(
                icon: data["icon"] as IconData,
                label: data["label"] as String,
                value: data["value"] as String,
                primaryColor: primaryColor,
                onTap: onTap,
              );
            },
          ),
        ],
      );
    });
  }
}
