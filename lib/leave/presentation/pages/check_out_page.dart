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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 20,
            ),
            const CircleAvatar(
              radius: 60,
              backgroundImage: AssetImage('assets/image/profile.png'),
            ),
            const SizedBox(
              height: 16,
            ),
            Obx(() => Text(
                  controller.userName.value,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                )),
            const SizedBox(
              height: 4,
            ),
            Obx(() => Text(
                  controller.userPosition.value,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                  ),
                )),
            const SizedBox(
              height: 24,
            ),
            const Divider(),
            const SizedBox(
              height: 16,
            ),
            Obx(
              () => _buildInfoRow('Check In: ', controller.checkInTime.value),
            ),
            const SizedBox(
              height: 8,
            ),
            Obx(
              () => _buildInfoRow('Location: ', controller.checkInLocation.value),
            ),
            const SizedBox(
              height: 8,
            ),
            const Divider(),
            const SizedBox(height: 64,),
            const Text(
              "Check Time",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 8,
            ),
            Obx(() => Text(
                  controller.currentTime.value,
                  style: const TextStyle(
                    fontSize: 42,
                    fontWeight: FontWeight.bold,
                  ),
                )),
            const SizedBox(height: 64,),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                  onPressed: controller.checkOutNow,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6EA07A),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "Check Out Now",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  )),
            ),
            const SizedBox(height: 20,),
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
            fontSize: 20,
            color: Colors.black,
            fontWeight: FontWeight.bold
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}
