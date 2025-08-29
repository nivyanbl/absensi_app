import 'package:employment_attendance/dashboard/presentation/widgets/custom_bottom_navbar.dart';
import 'package:employment_attendance/navigation/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:employment_attendance/auth/presentation/pages/login_page.dart';

class DashboardController extends GetxController {
  void openLMS() {
    Get.snackbar("LMS", "LMS option selected");
  }

  void openSettings() {
    Get.snackbar("Settings", "Settings option selected");
  }

  void logOut() {
    Get.snackbar("Log Out", "You have been logged out");
  }
}

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final DashboardController controller = Get.put(DashboardController());
    final Color primaryColor = const Color(0xFF6EA07A);

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Good Morning",
                style: TextStyle(fontSize: 14, color: Colors.white)),
            Text("John Doe",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white)),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              Get.toNamed(AppRoutes.NOTIFICATION);
            },
            icon: const Icon(Icons.notifications, color: Colors.white),
          ),
          const CircleAvatar(
            backgroundImage: NetworkImage("https://i.pravatar.cc/150?img=3"),
          ),
          const SizedBox(width: 10),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: primaryColor),
              child: Row(
                children: [
                  const CircleAvatar(
                    backgroundImage:
                        NetworkImage("https://i.pravatar.cc/150?img=3"),
                    radius: 30,
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    "John Doe",
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Profile'),
              onTap: () {
                Get.toNamed(AppRoutes.PROFILE);
              },
            ),
            ListTile(
              leading: const Icon(Icons.access_time),
              title: const Text('Leave & Permission'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.task),
              title: const Text('Tasks'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.report),
              title: const Text('Report'),
              onTap: () => Navigator.pop(context),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Log Out'),
              onTap: () {
                controller.logOut();
                Get.offAll(() => LoginPage());
              },
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Date & Location
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Thursday, 23 July 2025",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      "Bandung, Indonesia",
                      style: TextStyle(color: Colors.white, fontSize: 13),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Overview Section
              const Text("Overview",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              LayoutBuilder(
                builder: (context, constraints) {
                  double gridWidth = constraints.maxWidth;
                  double cardWidth = (gridWidth - 24) / 2;
                  double valueFontSize = cardWidth * 0.16;
                  double labelFontSize = cardWidth * 0.09;

                  final overviewData = [
                    [Icons.login, "Check In", "07:57 A.M"],
                    [Icons.logout, "Check Out", "06:20 P.M"],
                    [Icons.calendar_today, "Absence", "2 Day"],
                    [Icons.check_circle, "Total Attended", "16 Day"],
                  ];

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2),
                    child: GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: overviewData.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 12,
                        crossAxisSpacing: 12,
                        childAspectRatio: 1.7,
                      ),
                      itemBuilder: (context, index) {
                        final data = overviewData[index];
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          curve: Curves.easeInOut,
                          padding: const EdgeInsets.all(2.0),
                          child: Card(
                            elevation: 3,
                            shadowColor: Colors.black12,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 16),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(data[0] as IconData,
                                          color: Colors.black87, size: 22),
                                      const SizedBox(width: 6),
                                      Expanded(
                                        child: Text(
                                          data[1] as String,
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: labelFontSize,
                                            color: Colors.black87,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        (data[2] as String).split(' ')[0],
                                        style: TextStyle(
                                          fontSize: valueFontSize,
                                          fontWeight: FontWeight.w600,
                                          color: primaryColor,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      if ((data[2] as String)
                                              .split(' ')
                                              .length >
                                          1) ...[
                                        const SizedBox(width: 3),
                                        Text(
                                          (data[2] as String).split(' ')[1],
                                          style: TextStyle(
                                            fontSize: labelFontSize,
                                            fontWeight: FontWeight.w400,
                                            color: Colors.black54,
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),
              // Company News Section
              const Text("Company News",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 4,
                itemBuilder: (context, index) {
                  final newsList = [
                    {
                      "image":
                          "https://images.unsplash.com/photo-1506748686214-e9df14d4d9d0",
                      "title": "New Project Launch"
                    },
                    {
                      "image":
                          "https://images.unsplash.com/photo-1515378791036-0648a3ef77b2",
                      "title": "New Office Opening Soon"
                    },
                    {
                      "image":
                          "https://images.unsplash.com/photo-1461749280684-dccba630e2f6",
                      "title": "Team Building Event"
                    },
                    {
                      "image":
                          "https://images.unsplash.com/photo-1506744038136-46273834b3fb",
                      "title": "Annual Company Gathering"
                    },
                  ];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: Stack(
                        children: [
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 400),
                            curve: Curves.easeInOut,
                            child: Image.network(
                              newsList[index]["image"]!,
                              height: 150,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              loadingBuilder: (context, child, progress) {
                                if (progress == null) return child;
                                return Container(
                                  height: 150,
                                  color: Colors.grey[200],
                                  child: const Center(
                                    child: CircularProgressIndicator(
                                        strokeWidth: 2),
                                  ),
                                );
                              },
                            ),
                          ),
                          Positioned(
                            left: 0,
                            right: 0,
                            bottom: 0,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.45),
                                borderRadius: const BorderRadius.only(
                                  bottomLeft: Radius.circular(14),
                                  bottomRight: Radius.circular(14),
                                ),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 10),
                              child: Text(
                                newsList[index]["title"]!,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  letterSpacing: 0.2,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNav(
        currentIndex: 0, 
        // primary: primaryColor,
        onTap: (index) {
          if (index == 0) Get.offAllNamed(AppRoutes.DASHBOARD);
          if (index == 1) Get.offAllNamed(AppRoutes.LEAVE_REQUEST);
          if (index == 2) Get.offAllNamed(AppRoutes.CHECK_IN);
          if (index == 3) Get.offAllNamed(AppRoutes.ATTENDANCE_HISTORY);
          if (index == 4) Get.offAllNamed(AppRoutes.SLIP);
        },
      ),
    );
  }
}
