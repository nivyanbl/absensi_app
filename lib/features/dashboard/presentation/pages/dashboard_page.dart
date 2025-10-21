import 'package:employment_attendance/core/constants/app_strings.dart';
import 'package:employment_attendance/features/dashboard/presentation/controllers/dashboard_controller.dart';
import 'package:employment_attendance/features/dashboard/presentation/widgets/check_out_card.dart';
import 'package:employment_attendance/features/dashboard/presentation/widgets/company_new_list.dart';
import 'package:employment_attendance/features/dashboard/presentation/widgets/custom_bottom_navbar.dart';
import 'package:employment_attendance/features/dashboard/presentation/widgets/overview_grid.dart';
import 'package:employment_attendance/navigation/app_routes.dart';
import 'package:employment_attendance/features/profile/presentation/controller/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:async';
import 'package:intl/intl.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final DashboardController controller =
      Get.put(DashboardController(), permanent: true);
  final ProfileController profileController = Get.put(ProfileController());

  late Timer _timer;
  DateTime _currentTime = DateTime.now();

  @override
  void initState() {
    super.initState();
    _loadDashboardData();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          _currentTime = DateTime.now();
        });
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  Future<void> _loadDashboardData() async {
    await profileController.fetchUserProfile();
  }

  Future<void> _onRefresh() async {
    await Future.wait([
      profileController.fetchUserProfile(),
      controller.refresh(),
    ]);
  }

  String _getGreeting() {
    final hour = _currentTime.hour;
    if (hour < 12) return "Good Morning";
    if (hour < 17) return "Good Afternoon";
    return "Good Evening";
  }

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Theme.of(context).primaryColor;
    final String formattedDate =
        DateFormat('EEEE, dd MMMM yyyy').format(_currentTime);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 12.0),
              child: GestureDetector(
                onTap: () => Get.toNamed(AppRoutes.profile),
                child: const CircleAvatar(
                  radius: 22,
                  backgroundImage:
                      NetworkImage("https://i.pravatar.cc/150?img=3"),
                ),
              ),
            ),
            // Make the text column flexible so a long name won't overflow the appbar
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(_getGreeting(),
                      style:
                          const TextStyle(fontSize: 14, color: Colors.white)),
                  Obx(() {
                    final userName = profileController.user.value?.fullName;
                    return Text(
                      userName ?? AppStrings.loading,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () => Get.toNamed(AppRoutes.notification),
            icon: const Icon(Icons.notifications, color: Colors.white),
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        color: primaryColor,
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Make the date text flexible so it won't overflow when location label is long
                    Expanded(
                      child: Text(
                        formattedDate,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: primaryColor,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Obx(() => ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 140),
                            child: Text(
                              controller.location.value,
                              style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.onPrimary,
                                  fontSize: 13),
                              overflow: TextOverflow.ellipsis,
                            ),
                          )),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const OverviewGrid(),
                const SizedBox(height: 24),
                Obx(() {
                  final checkInTime = controller.checkInTime.value;
                  final checkOutTime = controller.checkOutTime.value;
                  final hasCheckedIn =
                      checkInTime.isNotEmpty && checkInTime != '--:--';
                  final hasCheckedOut =
                      checkOutTime.isNotEmpty && checkOutTime != '--:--';

                  if (hasCheckedIn && !hasCheckedOut) {
                    return const Column(
                      children: [
                        CheckOutCard(),
                        SizedBox(height: 24),
                      ],
                    );
                  }

                  return const SizedBox.shrink();
                }),
                const CompanyNewsList(),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNav(
        currentIndex: 0,
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
}
