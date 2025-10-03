import 'package:employment_attendance/navigation/app_routes.dart';
import 'package:employment_attendance/profile/presentation/controller/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class ProfilePage extends StatelessWidget {
  final ProfileController controller = Get.put(ProfileController());

  ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Profile',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
         actions: [
    IconButton(
      onPressed: () => Get.toNamed(AppRoutes.SETTINGS),
      icon: const Icon(Icons.settings, color: Colors.black),
    ),
    const SizedBox(width: 10),
  ],
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(heightFactor: 10, child: CircularProgressIndicator());
          }

          if (controller.user.value == null) {
            return const Center(child: Text('Gagal memuat data profil.'));
          }
          
          final user = controller.user.value!;

          return Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const CircleAvatar(
                    radius: 40,
                    backgroundImage: AssetImage('assets/image/profile.png'),
                  ),
                  const SizedBox(width: 16),
                  // Make name and role flexible to avoid overflow on small screens
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user.fullName,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'UI/UX Designer ',
                          style: TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                              fontWeight: FontWeight.bold),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Information',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 8),
              Column(
                children: [
                  _buildInfoItem(
                      Icons.person_outline, 'ID Employee', '1234567 '),
                  _buildInfoItem(
                    Icons.email_outlined,
                    'Email',
                    user.email,
                  ),
                  _buildInfoItem(Icons.phone_iphone, 'Phone Number',
                      '081234567890 '),
                  _buildInfoItem(Icons.calendar_today, 'Join Date',
                      '7 July 2025 '),
                ],
              ),
              const SizedBox(height: 15),
              ElevatedButton.icon(
                onPressed: () {
                  Get.toNamed(AppRoutes.EDIT_PROFILE);
                },
                icon: const Icon(
                  Icons.edit_outlined,
                  color: Colors.white,
                ),
                label: const Text(
                  'Edit profile',
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 48),
                  backgroundColor: const Color(0xFF6EA07A),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              )
            ],
          );
        }),
      ),
    );
  }

  Widget _buildInfoItem(
    IconData icon,
    String label,
    String value,
  ) {
    return ListTile(
      dense: true,
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon),
      title: Text(
        label,
        style: const TextStyle(
          color: Colors.grey,
          fontWeight: FontWeight.bold,
          fontSize: 15,
        ),
      ),
      subtitle: Text(value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15,
          )),
    );
  }
}