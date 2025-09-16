import 'package:employment_attendance/dashboard/presentation/widgets/overview_card.dart';
import 'package:flutter/material.dart';

class OverviewGrid extends StatelessWidget {
  const OverviewGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = const Color(0xFF6EA07A);
    final overviewData = [
      {"icon": Icons.login, "label": "Check In", "value": "07:57 A.M"},
      {"icon": Icons.logout, "label": "Check Out", "value": "06:20 P.M"},
      {"icon": Icons.calendar_today, "label": "Absence", "value": "2 Day"},
      {
        "icon": Icons.check_circle,
        "label": "Total Attended",
        "value": "16 Day"
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
  }
}
