import 'package:employment_attendance/navigation/app_routes.dart';
import 'package:employment_attendance/auth/data/repositories/auth_repository.dart';
import 'package:employment_attendance/settings/presentation/controllers/settings_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../widgets/settings_tile.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final SettingsController controller = Get.put(SettingsController());
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Settings',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Bagian General
            const Text('General',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey)),
            const SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  SettingsTile(
                    icon: Icons.lock_outlined,
                    title: 'Privacy',
                    onTap: () {
                      // Navigasinya
                    },
                  ),
                  const Divider(height: 1, indent: 72),
                  SettingsTile(
                    icon: Icons.language_outlined,
                    title: 'Language',
                    onTap: () {},
                  ),
                  const Divider(height: 1, indent: 72),
                  SettingsTile(
                    icon: Icons.dark_mode,
                    title: 'Dark Mode',
                    onTap: () {
                      controller.toggleDarkMode(!controller.isDarkModeOn.value);
                    },
                    trailing: Switch(
                      value: controller.isDarkModeOn.value,
                      onChanged: (value) {
                        controller.toggleDarkMode(value);
                      },
                      activeColor: const Color.fromARGB(255, 108, 220, 108),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Bagian Support & About
            const Text('Support & About',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey)),
            const SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  SettingsTile(
                    icon: Icons.flag_outlined,
                    title: 'Report a bug',
                    onTap: () {},
                  ),
                  const Divider(height: 1, indent: 72),
                  SettingsTile(
                    icon: Icons.help_outline_outlined,
                    title: 'Help',
                    onTap: () {},
                  ),
                  const Divider(height: 1, indent: 72),
                  SettingsTile(
                    icon: Icons.info_outline,
                    title: 'About ',
                    onTap: () {},
                  ),
                  const Divider(height: 1, indent: 72),
                  SettingsTile(
                    icon: Icons.verified_user_outlined,
                    title: 'Privacy Policy ',
                    onTap: () {},
                  ),
                  const Divider(height: 1, indent: 72),
                  SettingsTile(
                    icon: Icons.star_border,
                    title: 'Rate App ',
                    onTap: () {},
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            const Text('Account',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey)),
            const SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  SettingsTile(
                    icon: Icons.person_add_alt_1_outlined,
                    title: 'Add Account',
                    onTap: () {},
                  ),
                  const Divider(height: 1, indent: 72),
                  SettingsTile(
                    icon: Icons.exit_to_app,
                    title: 'Log Out',
                    onTap: () async {
                      final authRepo = AuthRepository();
                      await authRepo.logout();
                      Get.offAllNamed(AppRoutes.LOGIN);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
