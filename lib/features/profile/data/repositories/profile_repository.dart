import 'package:dio/dio.dart';
import 'package:employment_attendance/core/services/api_service.dart';
import 'package:employment_attendance/features/profile/domain/models/user_model.dart';
import 'package:flutter/material.dart';

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
      debugPrint('Error while retrieving profile: ${e.response?.data}');
      return null;
    } catch (e) {
      debugPrint('An unexpected error occurred: $e');
      return null;
    }
  }

  Future<bool> updateUserProfile(
      {String? fullName, String? email, String? phone}) async {
    try {
      final data = <String, dynamic>{};
      if (fullName != null) data['fullName'] = fullName;
      if (email != null) data['email'] = email;
      if (phone != null) data['phone'] = phone;

      final response = await _apiService.put('/auth/me', data: data);
      return response.statusCode == 200 || response.statusCode == 204;
    } catch (e) {
      debugPrint('Error updating profile: $e');
      return false;
    }
  }
}
