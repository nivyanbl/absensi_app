import 'package:dio/dio.dart';
import 'package:employment_attendance/core/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:get/get.dart';

class AuthRepository {
  final ApiService _apiService = Get.find<ApiService>();
  final _storage = GetStorage();

  Future<String?> login(String email, String password) async {
    try {
      final response = await _apiService.post(
        '/auth/login',
        data: {'email': email, 'password': password},
      );

      if (response.statusCode == 200 && response.data != null) {
        final accessToken = response.data['data']['tokens']['accessToken'];

        await _storage.write('authToken', accessToken);
        await _storage.write('authIssuedAt', DateTime.now().toIso8601String());

        debugPrint('Login successful. AccessToken saved (Cookie auto-saved).');
        return accessToken;
      }
      return null;
    } on DioException catch (e) {
      debugPrint('Error when logging in: ${e.response?.data['message']}');
      return null;
    } catch (e) {
      debugPrint('An unexpected error occurred: $e');
      return null;
    }
  }

  Future<String?> register(
      String fullName, String email, String password) async {
    try {
      final response = await _apiService.post(
        '/auth/register',
        data: {
          'fullName': fullName,
          'email': email,
          'password': password,
        },
      );

      if (response.statusCode == 201 && response.data != null) {
        final accessToken = response.data['data']['tokens']['accessToken'];

        await _storage.write('authToken', accessToken);
        await _storage.write('authIssuedAt', DateTime.now().toIso8601String());

        debugPrint(
            'Registration successful. AccessToken saved (Cookie auto-saved).');
        return accessToken;
      }
      return null;
    } on DioException catch (e) {
      debugPrint('Error while registrasi: ${e.response?.data['message']}');
      return null;
    } catch (e) {
      debugPrint('An unexpected error occurred: $e');
      return null;
    }
  }

  Future<void> logout() async {
    await _apiService.logout();
  }
}
