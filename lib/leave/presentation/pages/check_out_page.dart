import 'package:employment_attendance/leave/presentation/controller/check_out_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CheckOutPage extends StatelessWidget {
  const CheckOutPage({super.key});

  @override
  Widget build(BuildContext context) {
    final CheckOutController controller = Get.put(CheckOutController());
    
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          "Check Out",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 12),
            const CircleAvatar(
              radius: 60,
              backgroundImage: AssetImage('assets/image/profile.png'),
            ),
            const SizedBox(height: 12),
            Obx(() => Text(
                  controller.userName.value,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                  ),
                )),
            const SizedBox(height: 4),
            Obx(() => Text(
                  controller.userPosition.value,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                  ),
                )),
            const SizedBox(height: 18),
            const Divider(),
            const SizedBox(height: 12),
            Obx(
              () => _buildInfoRow('Check In: ', controller.checkInTime.value),
            ),
            const SizedBox(height: 6),
            Obx(
              () => _buildInfoRow('Location: ', controller.checkInLocation.value),
            ),
            const SizedBox(height: 6),
            const Divider(),
            const SizedBox(height: 28),
            const Text(
              "Check Time",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Obx(() => Text(
                  controller.currentTime.value,
                  style: const TextStyle(
                    fontSize: 42,
                    fontWeight: FontWeight.bold,
                  ),
                )),
            const SizedBox(height: 28),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: Obx(() => ElevatedButton(
                    onPressed: controller.isCheckingOut.value ? null : controller.checkOutNow,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6EA07A),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: controller.isCheckingOut.value
                        ? const SizedBox(
                            height: 24,
                            width: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 3,
                            ),
                          )
                        : const Text(
                            "Check Out Now",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),                 
                          ),
                  )),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          label,
          style: const TextStyle(
              fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold),
        ),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.start,
            style: const TextStyle(
              fontSize: 20,
              color: Colors.black,
            ),
          ),
        ),
      ],
    );
  }
}