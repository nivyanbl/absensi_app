import 'package:dio/dio.dart';
import 'package:employment_attendance/core/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

class AuthRepository {
  final ApiService _apiService = ApiService();
  final _storage = GetStorage();

  Future<String?> login(String email, String password) async {
    try {
      final response = await _apiService.post(
        '/auth/login',
        data: {'email': email, 'password': password},
      );

      if (response.statusCode == 200) {
        final data = response.data['data'];
        final tokens = data['tokens'];
        final user = data['user'];

        // Store tokens
        await _storage.write('authToken', tokens['accessToken']);
        await _storage.write('refreshToken', tokens['refreshToken']);
        await _storage.write('authIssuedAt', DateTime.now().toIso8601String());

        // Store user data
        if (user != null) {
          await _storage.write('user', user);
        }

        debugPrint('Login successful. Tokens and user data saved.');
        return tokens['accessToken'];
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

      if (response.statusCode == 201) {
        final data = response.data['data'];
        final tokens = data['tokens'];
        final user = data['user'];

        // Store tokens
        await _storage.write('authToken', tokens['accessToken']);
        await _storage.write('refreshToken', tokens['refreshToken']);
        await _storage.write('authIssuedAt', DateTime.now().toIso8601String());

        // Store user data
        if (user != null) {
          await _storage.write('user', user);
        }

        debugPrint('Registration successful. Tokens and user data saved.');
        return tokens['accessToken'];
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
    // Call backend logout endpoint to revoke refresh token
    try {
      await _apiService.post('/auth/logout');
    } catch (e) {
      debugPrint('Logout API call failed: $e');
    }

    // Clear all local data
    await _storage.remove('authToken');
    await _storage.remove('authIssuedAt');
    await _storage.remove('refreshToken');
    await _storage.remove('lastCheckDate');
    await _storage.remove('user');

    debugPrint('All auth data cleared, logout successful.');
  }
}
