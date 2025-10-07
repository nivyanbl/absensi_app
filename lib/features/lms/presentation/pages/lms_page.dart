import 'package:employment_attendance/features/dashboard/presentation/widgets/custom_bottom_navbar.dart';
import 'package:employment_attendance/navigation/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LmsPage extends StatefulWidget {
  const LmsPage({super.key});

  @override
  State<LmsPage> createState() => _LmsPageState();
}

class _LmsPageState extends State<LmsPage> {
  int selectedTab = 0;

  final List<String> tabs = ['All', 'Ongoing', 'Completed'];

  final List<Map<String, dynamic>> courses = [
    {
      'title': 'Foundations of Web Design with HTML & CSS',
      'icon': Icons.menu_book_outlined,
      'progress': 0.65,
      'status': 'In Progress',
      'completed': false,
    },
    {
      'title': 'Introduction to Mobile UI/UX Design Principles',
      'icon': Icons.design_services,
      'progress': 0.35,
      'status': 'In Progress',
      'completed': false,
    },
    {
      'title': 'Cloud Computing Fundamentals with AWS',
      'icon': Icons.cloud_outlined,
      'progress': 0.05,
      'status': 'In Progress',
      'completed': false,
    },
    {
      'title': 'Advanced JavaScript Concepts & Modern Frameworks',
      'icon': Icons.school,
      'progress': 1.0,
      'status': 'Completed',
      'completed': true,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              const Center(
                child: Text(
                  'My Learning',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 28,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  tabs.length,
                  (index) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: ChoiceChip(
                      label: Text(
                        tabs[index],
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: selectedTab == index
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                      selected: selectedTab == index,
                      selectedColor: const Color(0xFF6EA07A),
                      backgroundColor: const Color(0xFFF3F3F3),
                      onSelected: (val) {
                        setState(() {
                          selectedTab = index;
                        });
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: ListView(
                  children: courses.where((course) {
                    if (selectedTab == 0) return true;
                    if (selectedTab == 1) return !course['completed'];
                    if (selectedTab == 2) return course['completed'];
                    return true;
                  }).map((course) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.black12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(course['icon'],
                                  size: 28, color: const Color(0xFF6EA07A)),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  course['title'],
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          if (!course['completed']) ...[
                            LinearProgressIndicator(
                              value: course['progress'],
                              minHeight: 6,
                              backgroundColor: Colors.grey[200],
                              valueColor:
                                  const AlwaysStoppedAnimation<Color>(Colors.green),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.red[200],
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Row(
                                    children: [
                                      Icon(Icons.hourglass_bottom,
                                          size: 16, color: Colors.red),
                                      SizedBox(width: 4),
                                      Text('In Progress',
                                          style: TextStyle(
                                              color: Colors.red,
                                              fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                ),
                                const Spacer(),
                                ElevatedButton.icon(
                                  onPressed: () {},
                                  icon: const Icon(Icons.arrow_forward,
                                      color: Colors.white, size: 18),
                                  label: const Text('Continue',
                                      style: TextStyle(color: Colors.white)),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF6EA07A),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 18, vertical: 8),
                                  ),
                                ),
                              ],
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                '${(course['progress'] * 100).toInt()}%',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey),
                              ),
                            ),
                          ] else ...[
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF6EA07A),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Row(
                                    children: [
                                      Icon(Icons.check_circle,
                                          size: 16, color: Colors.white),
                                      SizedBox(width: 4),
                                      Text('Completed',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                ),
                                const Spacer(),
                                ElevatedButton.icon(
                                  onPressed: () {},
                                  icon: const Icon(Icons.receipt_long,
                                      color: Colors.white, size: 18),
                                  label: const Text('View Certificate',
                                      style: TextStyle(color: Colors.white)),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.black,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 18, vertical: 8),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
       bottomNavigationBar: CustomBottomNav(
        currentIndex: 3, 
        // primary: primaryColor,
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
