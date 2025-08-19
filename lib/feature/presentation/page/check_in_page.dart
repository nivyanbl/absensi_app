import 'package:camera/camera.dart';
import 'package:employment_attendance/feature/presentation/controller/check_in_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class CheckInPage extends StatelessWidget {
  const CheckInPage({super.key});

  @override
  Widget build(BuildContext context) {
    final CheckInController controller = Get.put(CheckInController());

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        title: const Text('Absence', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: Obx(
        () {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          if (controller.cameraController == null ||
              !controller.cameraController!.value.isInitialized) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(24.0),
                child: Text(
                  'Failed to load camera.\nMake sure you have granted camera permission in the app settings.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.red),
                ),
              ),
            );
          }

          return Stack(
            alignment: Alignment.center,
            children: [
              Positioned.fill(
                child: AspectRatio(
                  aspectRatio: controller.cameraController!.value.aspectRatio,
                  child: CameraPreview(controller.cameraController!),
                ),
              ),

              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 150,
                        height: 5,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      const SizedBox(height: 24),
                      
                      _buildInfoRow(Icons.location_on, 'Location', controller.currentLocation.value,),
                      const SizedBox(height: 12),
                      _buildInfoRow(Icons.calendar_today, 'Date', controller.currentDate.value),
                      const SizedBox(height: 24),
                      
                      Text(
                        controller.currentTime.value,
                        style: const TextStyle(
                          fontSize: 38,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 24),

                      ElevatedButton(
                        onPressed: controller.checkIn,
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 50),
                          backgroundColor: const Color(0xFF6EA07A),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        child: const Text(
                          'Check In',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFF6EA07A), size:25),
        const SizedBox(width: 8),
        Text(
          '$label   :',
          style: const TextStyle(fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 16
              ,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}