import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../widgets/attendance_card.dart';
import '../controllers/attendance_controller.dart';

class AttendanceHistoryPage extends StatelessWidget {
  const AttendanceHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final AttendanceController controller = Get.put(AttendanceController());

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text(
          'Attendance History',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.grey[100],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    _buildDropdown(controller.months, controller.selectedMonth),
                    const SizedBox(width: 32),
                    _buildDropdown(controller.years, controller.selectedYear),
                    const SizedBox(width: 32),
                    _buildDropdown(controller.statuses, controller.selectedStatus),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 24),

            Expanded(
              child: Obx(() => ListView.builder(
                    itemCount: controller.attendanceList.length,
                    itemBuilder: (context, index) {
                      final attendanceData = controller.attendanceList[index];
                      return AttendanceCard(attendance: attendanceData);
                    },
                  )),
            ),
          ],
        ),
      ),

      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: 3, 
        selectedItemColor: const Color(0xFF6EA07A),
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        onTap: (index) {
          if (index == 0) {
            Get.offAllNamed('/dashboard');
          } else if (index == 1) {
            Get.offAllNamed('/leave-request');
          } else if (index == 2) {
            Get.offAllNamed('/check-in');
          } else if (index == 3) {
            // Stay on this page (Attendance History)
          } else if (index == 4) {
            Get.offAllNamed('/slip-pay');
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.timer_off), label: 'Time Off'),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: 'Absence'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'History'),
          BottomNavigationBarItem(icon: Icon(Icons.receipt), label: 'Slip Pay'),
        ],
      ),
    );
  }

  Widget _buildDropdown(List<String> items, RxString selectedValue) {
    const Color primaryGreen = Color(0xFF6EA07A);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: primaryGreen, width: 1.5),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Obx(
        () => DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: selectedValue.value,
            icon: const Icon(Icons.keyboard_arrow_down, color: primaryGreen, size: 20),
            style: const TextStyle(
              color: primaryGreen,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
            items: items.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(
                  value,
                  style: const TextStyle(color: Colors.black),
                ),
              );
            }).toList(),
            onChanged: (newValue) {
              if (newValue != null) {
                selectedValue.value = newValue;
              }
            },
          ),
        ),
      ),
    );
  }
}
