import 'package:employment_attendance/core/constants/app_strings.dart';
import 'package:employment_attendance/core/widgets/custom.button.dart';
import 'package:employment_attendance/core/widgets/loading_widget.dart';
import 'package:employment_attendance/navigation/app_routes.dart';
import 'package:employment_attendance/features/profile/presentation/controller/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfilePage extends StatelessWidget {
  final ProfileController controller = Get.put(ProfileController());

  ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Get.back(),
          ),
          title: const Text(
            AppStrings.profile,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
          ),
          actions: [
            IconButton(
                onPressed: () => Get.toNamed(AppRoutes.settings),
                icon: const Icon(
                  Icons.settings,
                  // color: Theme.of(context).iconTheme.color
                )),
            const SizedBox(width: 10),
          ],
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Obx(() {
            if (controller.isLoading.value) {
              return const LoadingWidget(message: 'Loading profile...');
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
                          Text(
                            user.email,
                            style: TextStyle(
                                color: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.color ??
                                    Colors.grey,
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
                    _buildInfoItem(Icons.email_outlined, 'Email', user.email),
                    _buildInfoItem(Icons.phone_iphone, 'Phone Number',
                        user.phone ?? 'Not set'),
                    _buildInfoItem(
                        Icons.calendar_today, 'Join Date', '7 July 2025 '),
                  ],
                ),
                const SizedBox(height: 15),
                CustomButton(
                  width: double.infinity,
                  text: 'Edit Profile',
                  onPressed: () {
                    Get.toNamed(AppRoutes.editProfile);
                  },
                  icon: Icons.edit_outlined,
                )
              ],
            );
          }),
        ),
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String label, String value) {
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
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
    );
  }
}
