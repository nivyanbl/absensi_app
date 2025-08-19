import 'package:employment_attendance/feature/presentation/controller/profile_controller.dart';
import 'package:employment_attendance/navigation/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final ProfileController controller = Get.put(ProfileController());

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Profile',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Obx(() => Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const CircleAvatar(
                      radius: 40,
                      backgroundImage: AssetImage('assets/image/profile.png'),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          controller.user.value.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          controller.user.value.position,
                          style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
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
                
                // informasi
                Obx(() => Column(
                      children: [
                        _buildInfoItem(
                            Icons.person_outline, 'ID Employee', '1234567'),
                        _buildInfoItem(
                          Icons.email_outlined,
                          'Email',
                          controller.user.value.email,
                        ),
                        _buildInfoItem(Icons.phone_iphone, 'Phone Number',
                          controller.user.value.phone,),
                        _buildInfoItem(
                            Icons.calendar_today, 'Join Date', '7 July 2023'),
                      ],
                    )),
                
                const SizedBox(height: 15),
                // tombol edit profile
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
            )),
      ),
    );
  }

// Helper method to build information items
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
