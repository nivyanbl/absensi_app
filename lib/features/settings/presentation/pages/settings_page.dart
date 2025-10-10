import 'package:employment_attendance/navigation/app_routes.dart';
import 'package:employment_attendance/features/auth/data/repositories/auth_repository.dart';
import 'package:employment_attendance/features/settings/presentation/controllers/settings_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:employment_attendance/core/widgets/generic_info_page.dart';
import '../widgets/settings_tile.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final SettingsController controller = Get.put(SettingsController());

    return PopScope(
      canPop: true,
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back,
                // color: Theme.of(context).iconTheme.color
                ),
            onPressed: () => Get.back(),
          ),
          title: const Text('Settings',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('General',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey)),
              const SizedBox(height: 10),
              _buildCard(context, children: [
                SettingsTile(
                    icon: Icons.lock_outlined,
                    title: 'Privacy',
                    onTap: () => Get.toNamed('/privacy')),
                const Divider(height: 1, indent: 72),
                SettingsTile(
                    icon: Icons.language_outlined,
                    title: 'Language',
                    onTap: () {}),
                const Divider(height: 1, indent: 72),
                Obx(() => SettingsTile(
                      icon: Icons.dark_mode,
                      title: 'Dark Mode',
                      onTap: () => controller
                          .toggleDarkMode(!controller.isDarkModeOn.value),
                      trailing: Switch(
                        value: controller.isDarkModeOn.value,
                        onChanged: (v) => controller.toggleDarkMode(v),
                        activeThumbColor:
                            const Color.fromARGB(255, 108, 220, 108),
                      ),
                    )),
              ]),
              const SizedBox(height: 24),
              const Text('Support & About',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey)),
              const SizedBox(height: 10),
              _buildCard(context, children: [
                SettingsTile(
                    icon: Icons.flag_outlined,
                    title: 'Report a bug',
                    onTap: () => Get.to(() => const GenericInfoPage(
                        title: 'Report a bug',
                        body: 'Use this page to report bugs.'))),
                const Divider(height: 1, indent: 72),
                SettingsTile(
                    icon: Icons.help_outline_outlined,
                    title: 'Help',
                    onTap: () => Get.to(() => const GenericInfoPage(
                        title: 'Help',
                        body: 'Help content or FAQ goes here.'))),
                const Divider(height: 1, indent: 72),
                SettingsTile(
                    icon: Icons.info_outline,
                    title: 'About ',
                    onTap: () => Get.to(() => const GenericInfoPage(
                        title: 'About', body: 'About this app and company.'))),
                const Divider(height: 1, indent: 72),
                SettingsTile(
                    icon: Icons.verified_user_outlined,
                    title: 'Privacy Policy ',
                    onTap: () => Get.toNamed('/privacy')),
                const Divider(height: 1, indent: 72),
                SettingsTile(
                    icon: Icons.star_border, title: 'Rate App ', onTap: () {}),
              ]),
              const SizedBox(height: 24),
              const Text('Account',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey)),
              const SizedBox(height: 10),
              _buildCard(context, children: [
                SettingsTile(
                    icon: Icons.person_add_alt_1_outlined,
                    title: 'Add Account',
                    onTap: () => Get.toNamed(AppRoutes.register)),
                const Divider(height: 1, indent: 72),
                SettingsTile(
                    icon: Icons.exit_to_app,
                    title: 'Log Out',
                    onTap: () async {
                      final authRepo = AuthRepository();
                      await authRepo.logout();
                      Get.offAllNamed(AppRoutes.login);
                    }),
              ]),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCard(BuildContext context, {required List<Widget> children}) {
    return Container(
        decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(16)),
        child: Column(children: children));
  }
}
