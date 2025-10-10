import 'package:employment_attendance/features/leave/presentation/controller/check_out_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CheckOutPage extends StatelessWidget {
  const CheckOutPage({super.key});

  @override
  Widget build(BuildContext context) {
    final CheckOutController controller = Get.put(CheckOutController());

    final primary = Theme.of(context).primaryColor;
    final onPrimary = Theme.of(context).colorScheme.onPrimary;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        leading: IconButton(
            icon: const Icon(Icons.arrow_back,
                // color: Theme.of(context).iconTheme.color
                ),
            onPressed: () => Get.back()),
        title: Text("Check Out",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).appBarTheme.foregroundColor)),
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
                backgroundImage: AssetImage('assets/image/profile.png')),
            const SizedBox(height: 12),
            Obx(() => Text(
                  controller.userName.value,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                  ),
                )),
            const SizedBox(height: 4),
            Obx(() => Text(controller.userPosition.value,
                style: TextStyle(
                    color: Theme.of(context).textTheme.bodyMedium?.color,
                    fontSize: 15))),
            const SizedBox(height: 18),
            Divider(color: Theme.of(context).dividerColor),
            const SizedBox(height: 12),
            Obx(
              () => _buildInfoRow('Check In: ', controller.checkInTime.value),
            ),
            const SizedBox(height: 6),
            Obx(
              () =>
                  _buildInfoRow('Location: ', controller.checkInLocation.value),
            ),
            const SizedBox(height: 6),
            const Divider(),
            const SizedBox(height: 28),
            Text("Check Time",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).textTheme.titleLarge?.color)),
            const SizedBox(height: 6),
            Obx(() => Text(controller.currentTime.value,
                style: TextStyle(
                    fontSize: 42,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).textTheme.bodyLarge?.color))),
            const SizedBox(height: 28),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: Obx(() => ElevatedButton(
                    onPressed: (controller.isCheckingOut.value ||
                            !controller.canCheckOut.value)
                        ? null
                        : controller.checkOutNow,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: controller.isCheckingOut.value
                        ? SizedBox(
                            height: 24,
                            width: 24,
                            child: CircularProgressIndicator(
                                color: onPrimary, strokeWidth: 3))
                        : Obx(() => Text(
                            controller.canCheckOut.value
                                ? 'Check Out Now'
                                : 'Already Checked Out',
                            style: TextStyle(
                                color: onPrimary,
                                fontSize: 18,
                                fontWeight: FontWeight.bold))),
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
