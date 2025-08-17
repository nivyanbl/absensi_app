import 'package:employment_attendance/feature/presentation/page/profile_page.dart';
import 'package:flutter/material.dart';

class EditProfilePage extends StatelessWidget {
  const EditProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          "Edit Profile",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Profile Image",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      const CircleAvatar(
                        radius: 40,
                        backgroundColor: Color(0xFFBDBDBD),
                        child: Icon(Icons.person, size: 50, color: Colors.grey),
                      ),
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                        child: const Icon(Icons.image,
                            color: Colors.black, size: 12),
                      ),
                    ],
                  ),
                  const SizedBox(width: 30),
                  OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        padding:  const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),

                        ),
                      ),
                      child: const Text(
                        "Choose Your Photo",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.black, fontSize: 16),
                      )),
                ],
              ),
              const SizedBox(height: 32),
              //list of text fields
              _buildTextField(label: 'Name', hint: 'Enter your name'),
              const SizedBox(height: 24),
              _buildTextField(label: 'Email', hint: 'Enter your email'),
              const SizedBox(height: 24),
              _buildTextField(label: 'Phone Number', prefixText: '+1 '),
              const SizedBox(height: 48),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6EA07A),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: const Text(
                    'Save',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      {required String label, String? prefixText, String? hint}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
            children: const [
              TextSpan(
                  text: '*',
                  style: TextStyle(
                      color: Colors.red, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
        const SizedBox(height: 2),
        TextField(
          decoration: InputDecoration(
            hintText: hint,
            prefixText: prefixText,
            border: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
            ),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.black),
            ),
          ),
        )
      ],
    );
  }
}
