import 'package:flutter/material.dart';
import '../widgets/settings_tile.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool isNotificationOn = true;

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF071C7A);

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
                    onTap: () {},
                    trailing: Switch(
                      value: isNotificationOn,
                      onChanged: (value) {
                        setState(() {
                          isNotificationOn = value;
                        });
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
                    onTap: () {},
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