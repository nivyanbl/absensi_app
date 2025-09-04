import 'package:employment_attendance/profile/data/repositories/profile_repository.dart';
import 'package:employment_attendance/profile/domain/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class ProfileController extends GetxController {
  final ProfileRepository _profileRepository = ProfileRepository();

  var user = UserModel(name: '', email: '', position: '', phone: '').obs;
  var isLoading = true.obs;

  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;
  late TextEditingController positionController;

  var pickedImage = Rx<File?>(null);

  @override
  void onInit() {
    super.onInit();
    loadProfile();
  }

  void loadProfile() async {
    try {
      isLoading.value = true;
      var fetchedUser = await _profileRepository.getProfileData();
      user.value = fetchedUser;

      nameController = TextEditingController(text: user.value.name);
      emailController = TextEditingController(text: user.value.email);
      phoneController = TextEditingController(text: user.value.phone);
      positionController = TextEditingController(text: user.value.position);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();

    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      pickedImage.value = File(image.path);
    } else {
      Get.snackbar('Image Selection', 'No image selected');
    }
  }

  void saveProfile() async {
    final newName = nameController.text;
    final newEmail = emailController.text;
    final newPhone = phoneController.text;
    final newPosition = positionController.text;

    user.update((val) {
      val?.name = newName;
      val?.email = newEmail;
      val?.phone = newPhone;
      val?.position = newPosition;
    });
    await _profileRepository.saveProfileData(user.value);

    Get.snackbar("Sukses", "Profil berhasil diperbarui!");

    //Get.back();
  }
}
