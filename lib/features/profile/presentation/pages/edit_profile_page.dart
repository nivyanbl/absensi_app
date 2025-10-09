import 'dart:io';

import 'package:employment_attendance/core/constants/app_colors.dart';
import 'package:employment_attendance/core/constants/app_strings.dart';
import 'package:employment_attendance/core/widgets/custom.button.dart';
import 'package:image_picker/image_picker.dart';
import 'package:employment_attendance/features/profile/presentation/controller/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;

  final ProfileController controller = Get.find();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  File? _pickedImageFile;

  @override
  void initState() {
    super.initState();
    final user = controller.user.value;
    _nameController = TextEditingController(text: user?.fullName ?? '');
    _emailController = TextEditingController(text: user?.email ?? '');
    _phoneController = TextEditingController(text: user?.phone ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _pickImage() {
    ImagePicker()
        .pickImage(source: ImageSource.gallery, maxWidth: 800, imageQuality: 80)
        .then((xfile) async {
      if (xfile == null) return;
      setState(() {
        _pickedImageFile = File(xfile.path);
      });
      // Optionally upload to server if backend supports
      // final url = await controller.uploadProfileImage(xfile.path);
      // if (url != null) { /* update user avatar url */ }
    });
  }

  void _saveProfile() {
    if (_formKey.currentState!.validate()) {
      // Reverted: actual profile update disabled — show not implemented message
      Get.snackbar('Notice', 'Profile update is not enabled in this restore.',
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          AppStrings.editProfile,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Theme(
            data: Theme.of(context).copyWith(
                textSelectionTheme: const TextSelectionThemeData(
                  cursorColor: AppColors.primary,
                  selectionColor: AppColors.primary,
                  selectionHandleColor: AppColors.primary,
                ),
                inputDecorationTheme: const InputDecorationTheme(
                  focusedBorder: UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: AppColors.primary, width: 2)),
                )),
            child: Form(
              key: _formKey,
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
                      GestureDetector(
                        onTap: _pickImage,
                        child: Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            if (_pickedImageFile != null)
                              CircleAvatar(
                                  radius: 40,
                                  backgroundImage: FileImage(_pickedImageFile!))
                            else
                              const CircleAvatar(
                                radius: 40,
                                backgroundColor: Color(0xFFBDBDBD),
                                child: Icon(Icons.person,
                                    size: 50, color: Colors.grey),
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
                      ),
                      const SizedBox(width: 30),
                      OutlinedButton(
                          onPressed: _pickImage,
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 4),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text(
                            "Choose Your Photo",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontSize: 16),
                          )),
                    ],
                  ),
                  const SizedBox(height: 32),
                  _buildTextField(
                      label: AppStrings.name,
                      hint: 'Enter your name',
                      controller: _nameController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your name';
                        }
                        return null;
                      }),
                  const SizedBox(height: 24),
                  _buildTextField(
                      label: AppStrings.email,
                      hint: AppStrings.enterEmail,
                      controller: _emailController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        return null;
                      }),
                  const SizedBox(height: 24),
                  _buildTextField(
                    label: 'Phone Number',
                    hint: 'Enter your phone number',
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your phone number';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 48),
                  Obx(() => CustomButton(
                        text: AppStrings.save,
                        onPressed:
                            controller.isSaving.value ? null : _saveProfile,
                      )),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    String? hint,
    TextEditingController? controller,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
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
        const SizedBox(
          height: 8,
        ),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hint,
            border: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
            ),
          ),
          validator: validator,
        )
      ],
    );
  }
}
