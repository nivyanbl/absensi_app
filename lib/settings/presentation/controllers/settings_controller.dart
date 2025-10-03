import 'package:get/get.dart';

class SettingsController extends GetxController {
  // Reverted to non-persistent behavior: dark mode flag kept local only
  var isDarkModeOn = false.obs;

  void toggleDarkMode(bool value) {
    isDarkModeOn.value = value;
    // persistence intentionally removed to restore previous (non-functional) behavior
  }
}