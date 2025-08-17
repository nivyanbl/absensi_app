import 'package:employment_attendance/feature/presentation/page/edit_profile_page.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Profile', style: TextStyle(fontWeight: FontWeight.bold,fontSize: 24),),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                 CircleAvatar(
                  radius: 40,
                  backgroundImage: AssetImage(''),
                ),
                 SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children:  [
                    Text('John Doe', style: TextStyle(
                     fontWeight: FontWeight.bold, fontSize: 20,
                    ),),
                     SizedBox(height: 8),
                    Text('UI/UX Designer',
                    style: TextStyle(color: Colors.grey ,fontSize: 14, fontWeight: FontWeight.bold),),
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
            // Info items
            _buildInfoItem(Icons.person_outline, 'ID Employee', '1234567'),
            _buildInfoItem(Icons.email_outlined, 'Email', 'johndoe@example.com'),
            _buildInfoItem(Icons.phone_iphone, 'Phone Number', '+1 (555) 405-1234'),
            _buildInfoItem(Icons.calendar_today, 'Join Date', '7 July 2023'),

          SizedBox(height: 15),

            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const EditProfilePage()));
              },
              icon: const Icon(Icons.edit_outlined, color: Colors.white,),
              label: const Text('Edit profile', style: TextStyle(color: Colors.white),),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
                backgroundColor: const Color(0xFF6EA07A),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String value,String title, ) {
    return ListTile(
      dense: true,
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon),
      title: Text(value, 
      style: const TextStyle(
      color: Colors.grey, 
      fontWeight: FontWeight.bold, 
      fontSize: 15,
      ),),
      subtitle: Text(title, 
      style: const TextStyle(
      fontWeight: FontWeight.bold, 
      fontSize: 15,
      )),
      
    );
  }
}
