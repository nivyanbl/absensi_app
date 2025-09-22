import 'package:employment_attendance/dashboard/presentation/widgets/custom_bottom_navbar.dart';
import 'package:employment_attendance/leave/presentation/controller/leave_controller.dart';
import 'package:employment_attendance/navigation/app_routes.dart';
import 'package:employment_attendance/profile/presentation/controller/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:employment_attendance/leave/presentation/pages/leave_history_page.dart';
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';

class LeaveRequestPage extends StatefulWidget {
  const LeaveRequestPage({super.key});

  @override
  State<LeaveRequestPage> createState() => _LeaveRequestPageState();
}

class _LeaveRequestPageState extends State<LeaveRequestPage> {
  final LeaveController controller = Get.put(LeaveController());
  final ProfileController profileController = Get.put(ProfileController());
  String selectedType = 'SICK';
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now();
  TextEditingController reasonController = TextEditingController();
  String? uploadedFileName;
  bool isUploading = false;

  final List<String> leaveTypes = ['SICK', 'ANNUAL', 'OTHER'];

  Future<void> pickDate(BuildContext context, bool isStart) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: isStart ? startDate : endDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          startDate = picked;
        } else {
          endDate = picked;
        }
      });
    }
  }

  Future<void> pickAndUploadFile() async {
    setState(() {
      isUploading = true;
    });
    try {
      final result = await FilePicker.platform.pickFiles();
      if (result != null && result.files.single.path != null) {
        final fileName = result.files.single.name;
        setState(() {
          uploadedFileName = fileName;
        });
        Get.snackbar('Success', 'File uploaded successfully!',
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.white,
            colorText: Colors.black,
            icon: const Icon(Icons.check_circle, color: Color(0xFF6EA07A)));
      }
      setState(() {
        isUploading = false;
      });
    } catch (e) {
      setState(() {
        isUploading = false;
      });
      Get.snackbar('Error', 'Failed to upload file! $e',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.white,
          colorText: Colors.red,
          icon: const Icon(Icons.error, color: Colors.red));
    }
  }

  @override
  void initState() {
    super.initState();
    profileController.fetchUserProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                const Center(
                  child: Text(
                    'Leave Request',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Obx(() {
                  final profile = profileController.user.value;
                  return Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Employee name',
                                    style: TextStyle(color: Colors.grey)),
                                Text(profile?.fullName ?? 'N/A',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold)),
                                const SizedBox(height: 8),
                                const Text('Job position',
                                    style: TextStyle(color: Colors.grey)),
                                const Text('UI / UX Designer',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                              ],
                            ),
                            const Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text('Employee ID',
                                    style: TextStyle(color: Colors.grey)),
                                Text('24738246',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                SizedBox(height: 8),
                                Text('Status',
                                    style: TextStyle(color: Colors.grey)),
                                Text('Full time',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: Colors.black12),
                                ),
                                child: Obx(() => Column(
                                      children: [
                                        Text(
                                            '${controller.availableLeave.value} Day',
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18)),
                                        const Text('Available leave',
                                            style:
                                                TextStyle(color: Colors.grey)),
                                      ],
                                    )),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: Colors.black12),
                                ),
                                child: Obx(() => Column(
                                  children: [
                                    Text('${controller.usedLeave.value} Day',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18)),
                                    const Text('Used leave',
                                        style: TextStyle(color: Colors.grey)),
                                  ],
                                )),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF6EA07A),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text('Leave Request',
                            style: TextStyle(color: Colors.white)),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          Get.to(() => const LeaveHistoryPage());
                        },
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Color(0xFF6EA07A)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text('History',
                            style: TextStyle(color: Color(0xFF6EA07A))),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.black12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Types of leave',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        initialValue: selectedType,
                        items: leaveTypes.map((type) {
                          return DropdownMenuItem(
                            value: type,
                            child: Text(type),
                          );
                        }).toList(),
                        onChanged: (val) {
                          setState(() {
                            selectedType = val!;
                          });
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text('Duration',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: () => pickDate(context, true),
                              child: InputDecorator(
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 8),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(Icons.calendar_today,
                                        size: 18, color: Colors.grey),
                                    const SizedBox(width: 8),
                                    Text(
                                        '${startDate.day}/${startDate.month}/${startDate.year}'),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Text('to'),
                          const SizedBox(width: 8),
                          Expanded(
                            child: InkWell(
                              onTap: () => pickDate(context, false),
                              child: InputDecorator(
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 8),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(Icons.calendar_today,
                                        size: 18, color: Colors.grey),
                                    const SizedBox(width: 8),
                                    Text(
                                        '${endDate.day}/${endDate.month}/${endDate.year}'),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      const Text('Reason (optional)',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      TextField(
                        controller: reasonController,
                        maxLines: 2,
                        decoration: InputDecoration(
                          hintText: 'Write description here..',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                        ),
                      ),
                      const SizedBox(height: 16),
                      InkWell(
                        onTap: isUploading ? null : pickAndUploadFile,
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 24),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black12),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            children: [
                              Icon(
                                uploadedFileName != null
                                    ? Icons.check_circle
                                    : Icons.upload_file,
                                size: 32,
                                color: uploadedFileName != null
                                    ? const Color(0xFF6EA07A)
                                    : Colors.grey,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                uploadedFileName != null
                                    ? 'File uploaded: $uploadedFileName'
                                    : (isUploading
                                        ? 'Uploading...'
                                        : 'Upload supporting documents'),
                                style: TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: Obx(() => ElevatedButton(
                              onPressed: controller.isLoading.isTrue
                                  ? null
                                  : () {
                                      controller.createLeaveRequest(
                                        type: selectedType,
                                        startDate: startDate,
                                        endDate: endDate,
                                        reason: reasonController.text,
                                      );
                                    },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF6EA07A),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 14),
                              ),
                              child: controller.isLoading.isTrue
                                  ? const CircularProgressIndicator(
                                      color: Colors.white)
                                  : const Text('Submit request',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold)),
                            )),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNav(
        currentIndex: 1,
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
