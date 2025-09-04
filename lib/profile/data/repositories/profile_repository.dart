import 'package:employment_attendance/profile/domain/models/user_model.dart';

class ProfileRepository {
  Future<UserModel> getProfileData() async {
    await Future.delayed(const Duration(milliseconds: 500));
    print("Mengambil data dummy dari ProfileRepository...");
    return UserModel(
      name: 'John Doe',
      email: 'johndoe@example.com',
      position: 'UI/UX Designer',
      phone: '+1 (555) 405-1234',
    );
  }

  Future <void> saveProfileData (UserModel user ) async {
    await Future.delayed(const Duration(seconds: 1));
    print("Menyimpan data dari user: ${user.name} ke sumber data" );
  }
}
