import 'package:employment_attendance/profile/data/repositories/profile_repository.dart';
import 'package:employment_attendance/profile/domain/models/user_model.dart';
import 'package:get/get.dart';


class ProfileController extends GetxController {
  final ProfileRepository _profileRepository = ProfileRepository();
  var user = Rx<UserModel?>(null);
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchUserProfile();
  }

  void fetchUserProfile() async {
    try {
      isLoading.value = true;
      user.value = await _profileRepository.getUserProfile();
    } catch (e) {
      print("Error di ProfileController: $e");
      user.value = null;
    } finally {
      isLoading.value = false;
    }
  }
}