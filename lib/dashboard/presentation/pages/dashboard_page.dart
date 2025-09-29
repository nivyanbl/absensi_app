import 'package:employment_attendance/dashboard/presentation/controllers/dashboard_controller.dart';
import 'package:employment_attendance/dashboard/presentation/widgets/check_out_card.dart';
import 'package:employment_attendance/dashboard/presentation/widgets/company_new_list.dart';
import 'package:employment_attendance/dashboard/presentation/widgets/custom_bottom_navbar.dart';
import 'package:employment_attendance/dashboard/presentation/widgets/overview_grid.dart';
import 'package:employment_attendance/navigation/app_routes.dart';
import 'package:employment_attendance/profile/presentation/controller/profile_controller.dart';
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
  final DashboardController controller = Get.put(DashboardController());
  final ProfileController profileController = Get.put(ProfileController());

  late Timer _timer;
  DateTime _currentTime = DateTime.now();

  @override
  void initState() {
    super.initState();
    profileController.fetchUserProfile();

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

  String _getGreeting() {
    final hour = _currentTime.hour;
    if (hour < 12) return "Good Morning";
    if (hour < 17) return "Good Afternoon";
    return "Good Evening";
  }

  @override
  Widget build(BuildContext context) {
    Color primaryColor = const Color(0xFF6EA07A);
    final String formattedDate = DateFormat('EEEE, dd MMMM yyyy').format(_currentTime);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
  backgroundColor: primaryColor,
  elevation: 0,
  automaticallyImplyLeading: false, 
  title: Row(
    children: [
       Padding(
        padding: const EdgeInsets.only(left: 8.0, right: 16.0),
        child: GestureDetector(
        onTap: () => Get.toNamed(AppRoutes.PROFILE), 
        child: const CircleAvatar(
          radius: 22,
          backgroundImage: NetworkImage("https://i.pravatar.cc/150?img=3"),
          ),
        ),
      ),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(_getGreeting(), style: const TextStyle(fontSize: 14, color: Colors.white)),
          Obx(() {
            final userName = profileController.user.value?.fullName;
            return Text(userName ?? "Loading...",
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white));
          }),
        ],
      ),
    ],
  ),
  actions: [
    IconButton(
      onPressed: () => Get.toNamed(AppRoutes.NOTIFICATION),
      icon: const Icon(Icons.notifications, color: Colors.white),
    ),
    const SizedBox(width: 10),
  ],
),

      
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        formattedDate,
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Obx(() => Text( 
                          controller.location.value, 
                          style: const TextStyle(color: Colors.white, fontSize: 13),
                        )),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              const OverviewGrid(),
              const SizedBox(height: 24),
              const CheckOutCard(),
              const SizedBox(height: 24),
              const CompanyNewsList(),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNav(
        currentIndex: 0,
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