import 'package:employment_attendance/features/profile/data/repositories/profile_repository.dart';
import 'package:employment_attendance/features/profile/domain/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileController extends GetxController {
  final ProfileRepository _profileRepository = ProfileRepository();
  var user = Rx<UserModel?>(null);
  var isLoading = true.obs;

  var isSaving = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchUserProfile();
  }

  Future<void> fetchUserProfile() async {
    try {
      isLoading.value = true;
      user.value = await _profileRepository.getUserProfile();
    } catch (e) {
      debugPrint("Error di ProfileController: $e");
      user.value = null;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> updateUserProfile(
      {String? fullName, String? email, String? phone}) async {
    try {
      isSaving.value = true;
      // Optimistic update: apply locally first so UI updates immediately
      final oldUser = user.value;
      if (oldUser != null) {
        user.value =
            oldUser.copyWith(fullName: fullName, email: email, phone: phone);
      }

      final success = await _profileRepository.updateUserProfile(
          fullName: fullName, email: email, phone: phone);
      if (success) {
        // refresh local copy from server
        await fetchUserProfile();
        return true;
      }

      // revert optimistic update on failure
      user.value = oldUser;
      return false;
    } catch (e) {
      debugPrint('Error in updateUserProfile: $e');
      return false;
    } finally {
      isSaving.value = false;
    }
  }

  /// Upload and return remote image URL. Placeholder - implement file upload when backend supports it.
  Future<String?> uploadProfileImage(String filePath) async {
    // Not implemented yet - return null to indicate no remote URL.
    return null;
  }
}
