import 'package:flutter/material.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.green,
        elevation: 0,
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
                "https://i.pravatar.cc/150?img=3"), // contoh foto profil
          ),
          const SizedBox(width: 10),
        ],
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
                double valueFontSize = cardWidth * 0.22; // Responsive font size
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
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      child: Padding(
                        padding:
                            const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(data[0] as IconData, color: Colors.green, size: 24),
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
                            const SizedBox(height: 8),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Flexible(
                                  child: FittedBox(
                                    fit: BoxFit.scaleDown,
                                    alignment: Alignment.bottomLeft,
                                    child: Text(
                                      (data[2] as String).split(' ')[0],
                                      style: TextStyle(
                                        fontSize: valueFontSize,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                if ((data[2] as String).split(' ').length > 1) ...[
                                  const SizedBox(width: 3),
                                  Text(
                                    (data[2] as String).split(' ')[1],
                                    style: TextStyle(
                                      fontSize: labelFontSize,
                                      fontWeight: FontWeight.w400,
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
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                "https://images.unsplash.com/photo-1600880292089-90e6a4b9a2b9",
                height: 150,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "Business growing in Ohio",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
              icon: Icon(Icons.timer_off), label: "Time Off"),
          BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today), label: "Absence"),
          BottomNavigationBarItem(
              icon: Icon(Icons.history), label: "History"),
          BottomNavigationBarItem(icon: Icon(Icons.receipt), label: "Slip Pay"),
        ],
      ),
    );
  }
}