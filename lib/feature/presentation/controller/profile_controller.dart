import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

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

  @override
  void onInit() {
    super.onInit();
    nameController = TextEditingController(text: user.value.name);
    emailController = TextEditingController(text: user.value.email);
    phoneController = TextEditingController(text: user.value.phone);
  }

  void saveProfile() {
    final newName = nameController.text;
    final newEmail = emailController.text;
    final newPhone = phoneController.text;

    user.update((val) {
      val?.name = newName;
      val?.email = newEmail;
      val?.phone = newPhone;
    });

    //Get.back();
  }
}