import 'package:camera/camera.dart';
import 'package:employment_attendance/leave/presentation/controller/check_in_controller.dart';
import 'package:employment_attendance/navigation/app_routes.dart'; 
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CheckInPage extends StatelessWidget {
  const CheckInPage({super.key});

  @override
  Widget build(BuildContext context) {
    final CheckInController controller = Get.put(CheckInController());

    final primary = Theme.of(context).primaryColor;
    final onPrimary = Theme.of(context).colorScheme.onPrimary;

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Theme.of(context).iconTheme.color),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Theme.of(context).iconTheme.color),
          onPressed: () => Get.toNamed(AppRoutes.DASHBOARD),
        ),
        title: Text('Absence', style: TextStyle(color: Theme.of(context).appBarTheme.foregroundColor, fontWeight: FontWeight.bold)),
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
              SizedBox.expand(
                child: FittedBox(
                  fit: BoxFit.cover,
                  child: SizedBox(
                    width: controller.cameraController!.value.previewSize!.height,
                    height: controller.cameraController!.value.previewSize!.width,
                    child: CameraPreview(controller.cameraController!),
                  ),
                ),
              ),

              // Top plain location text (no background)
              Positioned(
                top: MediaQuery.of(context).padding.top + kToolbarHeight - 8,
                left: 16,
                right: 16,
                child: Obx(() {
                  final location = controller.currentLocation.value;
                  return Text(
                    location.isNotEmpty ? location : 'Location not available',
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      shadows: [
                        Shadow(color: Colors.black45, blurRadius: 4, offset: Offset(0, 1)),
                      ],
                    ),
                  );
                }),
              ),

              // Floating circular shutter button (no background panel)
              Positioned(
                bottom: 36,
                left: 0,
                right: 0,
                child: Center(
                  child: Obx(() {
                    final enabled = controller.isLocationReady.value;
                    final checking = controller.isCheckingIn.value;

                    // if user already checked in today, show a disabled checked state
                    if (controller.hasCheckedInToday.value) {
                      return Container(
                        width: 140,
                        height: 56,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(28),
                          border: Border.all(color: Theme.of(context).dividerColor),
                        ),
                        child: Text(
                          'Checked In',
                          style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color, fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      );
                    }

                    return Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(40),
                        onTap: () {
                          if (enabled && !checking) {
                            controller.checkIn();
                          } else if (!enabled) {
                            Get.snackbar('Info', 'Waiting for location...', snackPosition: SnackPosition.BOTTOM);
                          }
                        },
                        child: Container(
                          width: 76,
                          height: 76,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: enabled ? primary : Colors.grey.shade400,
                            boxShadow: (enabled && !checking)
                                ? [
                                    BoxShadow(
                                      color: primary.withOpacity(0.28),
                                      blurRadius: 12,
                                      offset: const Offset(0, 6),
                                    )
                                  ]
                                : [],
                          ),
                          child: checking
                              ? SizedBox(
                                  width: 28,
                                  height: 28,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.5,
                                    valueColor: AlwaysStoppedAnimation<Color>(onPrimary),
                                  ),
                                )
                              : Icon(
                                  Icons.camera_alt,
                                  color: onPrimary,
                                  size: 32,
                                ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // helper removed — UI simplified to a plain top location text and a circular shutter button
}