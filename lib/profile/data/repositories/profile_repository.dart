import 'package:dio/dio.dart'; 
import 'package:employment_attendance/core/services/api_service.dart';
import 'package:employment_attendance/profile/domain/models/user_model.dart';

class ProfileRepository {
  final ApiService _apiService = ApiService();

  Future<UserModel?> getUserProfile() async {
    try {
      final response = await _apiService.get('/auth/me');

      if (response.statusCode == 200) {
        return UserModel.fromJson(response.data['data']);
      } else {
        return null;
      }
    } on DioException catch (e) {
      print('Error while retrieving profile: ${e.response?.data}');
      return null;
    } catch (e) {
      print('An unexpected error occurred: $e');
      return null;
    }
  }
}