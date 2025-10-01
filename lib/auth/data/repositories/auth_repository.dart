import 'package:dio/dio.dart';
import 'package:employment_attendance/core/services/api_service.dart'; 
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
        final accessToken = response.data['data']['tokens']['accessToken'];
        final refreshToken = response.data['data']['tokens']['refreshToken'] as String?;
        
        await _storage.write('authToken', accessToken);
        // persist issued timestamp so we can force re-login after a day
        await _storage.write('authIssuedAt', DateTime.now().toIso8601String());
        if (refreshToken != null && refreshToken.isNotEmpty) {
          await _storage.write('refreshToken', refreshToken);
        }
        print('Login successful. Token saved.');
        return accessToken;
      }
      return null;
    } on DioException catch (e) {
      print('Error when logging in: ${e.response?.data['message']}');
      return null;
    } catch (e) {
      print('An unexpected error occurred: $e');
      return null;
    }
  }

  Future<String?> register(String fullName, String email, String password) async {
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
        final accessToken = response.data['data']['tokens']['accessToken'];
        
        await _storage.write('authToken', accessToken);
        print('Registration successful. Token saved.');
        return accessToken;
      }
      return null;
    } on DioException catch (e) {
      print('Error while registrasi: ${e.response?.data['message']}');
      return null;
    } catch (e) {
      print('An unexpected error occurred: $e');
      return null;
    }
  }

  Future<void> logout() async {
  await _storage.remove('authToken');
  await _storage.remove('authIssuedAt');
  await _storage.remove('refreshToken');
  print('Token and auth metadata deleted, logout successful.');
  }
}