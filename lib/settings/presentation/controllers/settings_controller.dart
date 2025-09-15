import 'package:get/get.dart';

class SettingsController extends GetxController {
  var isDarkModeOn = false.obs;

  void toggleDarkMode(bool value) {
    isDarkModeOn.value = value;
  }
}