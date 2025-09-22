import 'package:employment_attendance/dashboard/presentation/widgets/custom_bottom_navbar.dart';
import 'package:employment_attendance/leave/presentation/controller/leave_controller.dart';
import 'package:employment_attendance/navigation/app_routes.dart';
import 'package:employment_attendance/profile/presentation/controller/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:employment_attendance/leave/presentation/pages/leave_request_page.dart';
import 'package:employment_attendance/leave/presentation/widgets/leave_history_card.dart';

class LeaveHistoryPage extends StatefulWidget {
  const LeaveHistoryPage({super.key});

  @override
  State<LeaveHistoryPage> createState() => _LeaveHistoryPageState();
}

class _LeaveHistoryPageState extends State<LeaveHistoryPage> {
  final LeaveController leaveController = Get.put(LeaveController());
  final LeaveController controller = Get.put(LeaveController());
  final ProfileController profileController = Get.put(ProfileController());
  bool showAdditionalDuration = false;
  DateTime additionalStartDate = DateTime.now();
  DateTime additionalEndDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    leaveController.fetchLeaveHistory();
    profileController.fetchUserProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                const Center(
                  child: Text(
                    'Leave History',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Obx(() {
                  final profile = profileController.user.value;
                  return Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Employee name',
                                    style: TextStyle(color: Colors.grey)),
                                Text(profile?.fullName ?? 'N/A',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold)),
                                const SizedBox(height: 8),
                                const Text('Job position',
                                    style: TextStyle(color: Colors.grey)),
                                const Text('UI/UX Designer',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                              ],
                            ),
                            const Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text('Employee ID',
                                    style: TextStyle(color: Colors.grey)),
                                Text('24738246',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                SizedBox(height: 8),
                                Text('Status',
                                    style: TextStyle(color: Colors.grey)),
                                Text('Full time',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: Colors.black12),
                                ),
                                child: Obx(() => Column(
                                      children: [
                                        Text(
                                            '${controller.availableLeave.value} Day',
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18)),
                                        const Text('Available leave',
                                            style:
                                                TextStyle(color: Colors.grey)),
                                      ],
                                    )),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: Colors.black12),
                                ),
                                child: Obx(() => Column(
                                      children: [
                                        Text(
                                            '${controller.usedLeave.value} Day',
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18)),
                                        const Text('Used leave',
                                            style:
                                                TextStyle(color: Colors.grey)),
                                      ],
                                    )),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          Get.to(() => const LeaveRequestPage());
                        },
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Color(0xFF6EA07A)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text('Leave Request',
                            style: TextStyle(color: Color(0xFF6EA07A))),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF6EA07A),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text('History',
                            style: TextStyle(color: Colors.white)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Obx(() {
                  if (leaveController.isLoading.isTrue) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (leaveController.leaveHistory.isEmpty) {
                    return const Center(child: Text('No leave history.'));
                  }
                  return Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.black12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: leaveController.leaveHistory.map((leave) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12.0),
                          child: LeaveHistoryCard(leave: leave),
                        );
                      }).toList(),
                    ),
                  );
                }),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNav(
        currentIndex: 1,
        onTap: (index) {
          if (index == 0) Get.offAllNamed(AppRoutes.DASHBOARD);
          if (index == 1) Get.offAllNamed(AppRoutes.ATTENDANCE_HISTORY);
          if (index == 2) Get.offAllNamed(AppRoutes.CHECK_IN);
          if (index == 3) Get.offAllNamed(AppRoutes.LMS);
          if (index == 4) Get.offAllNamed(AppRoutes.SLIP);
        },
      ),
    );
  }
}
