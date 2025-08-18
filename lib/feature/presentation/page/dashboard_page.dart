import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DashboardController extends GetxController {
  // Add any necessary variables and methods for your controller
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

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.green,
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Good Morning", style: TextStyle(fontSize: 14)),
            Text("John Doe",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.notifications)),
          const CircleAvatar(
            backgroundImage: NetworkImage(
                "https://i.pravatar.cc/150?img=3"),
          ),
          const SizedBox(width: 10),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(color: Colors.green),
              child: Row(
                children: [
                  const CircleAvatar(
                    backgroundImage: NetworkImage("https://i.pravatar.cc/150?img=3"),
                    radius: 30,
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    "John Doe",
                    style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Profile'),
              onTap: () => Navigator.pop(context),
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
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Thursday, 23 July 2025",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                "Bandung, Indonesia",
                style: TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(height: 20),
            const Text("Overview",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            // Responsive Overview Grid
            LayoutBuilder(
              builder: (context, constraints) {
                double gridWidth = constraints.maxWidth;
                double cardWidth = (gridWidth - 15) / 2; // 15 = mainAxisSpacing
                double valueFontSize = cardWidth * 0.18; // lebih kecil
                double labelFontSize = cardWidth * 0.09;

                final overviewData = [
                  [Icons.login, "Check In", "07:57 A.M"],
                  [Icons.logout, "Check Out", "06:20 P.M"],
                  [Icons.calendar_today, "Absence", "2 Day"],
                  [Icons.check_circle, "Total Attended", "16 Day"],
                ];

                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: overviewData.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 15,
                    crossAxisSpacing: 15,
                    childAspectRatio: 1.7,
                  ),
                  itemBuilder: (context, index) {
                    final data = overviewData[index];
                    return Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: Container(
                        constraints: const BoxConstraints(minHeight: 90),
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(data[0] as IconData, color: Colors.black, size: 22),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    data[1] as String,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: labelFontSize,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Expanded(
                                  child: Text(
                                    (data[2] as String).split(' ')[0],
                                    style: TextStyle(
                                      fontSize: valueFontSize,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                if ((data[2] as String).split(' ').length > 1) ...[
                                  const SizedBox(width: 3),
                                  Text(
                                    (data[2] as String).split(' ')[1],
                                    style: TextStyle(
                                      fontSize: labelFontSize,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
            const SizedBox(height: 20),
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
                    "image": "https://images.unsplash.com/photo-1506748686214-e9df14d4d9d0",
                    "title": "New Project Launch"
                  },
                  {
                    "image": "https://images.unsplash.com/photo-1515378791036-0648a3ef77b2",
                    "title": "New Office Opening Soon"
                  },
                  {
                    "image": "https://images.unsplash.com/photo-1461749280684-dccba630e2f6",
                    "title": "Team Building Event"
                  },
                  {
                    "image": "https://images.unsplash.com/photo-1506744038136-46273834b3fb",
                    "title": "Annual Company Gathering"
                  },
                ];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Stack(
                      children: [
                        Image.network(
                          newsList[index]["image"]!,
                          height: 150,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                        Positioned(
                          left: 16,
                          bottom: 16,
                          child: Container(
                            color: Colors.black54,
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            child: Text(
                              newsList[index]["title"]!,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
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
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.timer_off), label: "Time Off"),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: "Absence"),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: "History"),
          BottomNavigationBarItem(icon: Icon(Icons.receipt), label: "Slip Pay"),
        ],
      ),
    );
  }
}