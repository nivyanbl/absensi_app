import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';


class UserModel {
  String name;
  String email;
  String position;
  String phone;

  UserModel({required this.name, required this.email, required this.position, required this.phone});
}


class ProfileController extends GetxController {

  var user = UserModel(
    name: 'John Doe',
    email: 'johndoe@example.com',
    position: 'UI/UX Designer',
    phone: '+1 (555) 405-1234'
  ).obs;

  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;
  late TextEditingController positionController;

  var pickedImage = Rx<File?>(null);

  @override
  void onInit() {
    super.onInit();
    nameController = TextEditingController(text: user.value.name);
    emailController = TextEditingController(text: user.value.email);
    phoneController = TextEditingController(text: user.value.phone);
    positionController = TextEditingController(text: user.value.position);
    
  }

  Future<void> pickImage () async {
    final ImagePicker picker = ImagePicker();

    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      pickedImage.value = File (image.path);
    } else {
      Get.snackbar('Image Selection', 'No image selected');
    }
  }

  void saveProfile() {
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

    //Get.back();
  }
}