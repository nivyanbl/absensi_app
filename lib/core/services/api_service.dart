import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_storage/get_storage.dart';
import 'package:get/get.dart' as getx;
import 'package:employment_attendance/navigation/app_routes.dart';
import 'package:flutter/foundation.dart';

class ApiService {
  final Dio _dio;
  final box = GetStorage();
  bool _isRefreshing = false;

  ApiService()
      : _dio = Dio(BaseOptions(
          baseUrl: dotenv.env['API_BASE_URL'] ?? '',
          connectTimeout: const Duration(seconds: 30),
          receiveTimeout: const Duration(seconds: 30),
          sendTimeout: const Duration(seconds: 30),
        )) {
    // Validate base URL
    if (dotenv.env['API_BASE_URL'] == null) {
      if (kDebugMode) {
        print('WARNING: API_BASE_URL not found in .env file!');
      }
    }

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          final String? token = box.read('authToken');

          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }

          // Debug log (only in debug mode, no sensitive data)
          if (kDebugMode) {
            print(
                'API Request -> ${options.method} ${options.baseUrl}${options.path}');
            print('Data: ${options.data}');
          }

          return handler.next(options);
        },
        onResponse: (response, handler) {
          if (kDebugMode) {
            print(
                'API Response <- ${response.statusCode} ${response.requestOptions.method} ${response.requestOptions.path}');
          }
          return handler.next(response);
        },
        onError: (DioException e, handler) async {
          if (kDebugMode) {
            final req = e.requestOptions;
            print('API Error !! ${e.message}');
            print('When calling: ${req.method} ${req.baseUrl}${req.path}');
            print(
                'Error response: ${e.response?.statusCode} ${e.response?.data}');
          }

          // Handle 401 (Token expired) - Try to refresh
          if (e.response?.statusCode == 401 &&
              e.requestOptions.path != '/auth/refresh') {
            if (kDebugMode) {
              print("Access token expired, attempting refresh...");
            }

            try {
              // Try to refresh token
              await _refreshToken();

              // Retry original request with new token
              final opts = Options(
                method: e.requestOptions.method,
                headers: {
                  ...e.requestOptions.headers,
                  'Authorization': 'Bearer ${box.read('authToken')}',
                },
              );

              final response = await _dio.request(
                e.requestOptions.path,
                data: e.requestOptions.data,
                queryParameters: e.requestOptions.queryParameters,
                options: opts,
              );

              return handler.resolve(response);
            } catch (refreshError) {
              if (kDebugMode) {
                print("Token refresh error: $refreshError");
                print("Logging out user...");
              }

              // Check if error is due to missing refresh token (old user migration)
              final errorMsg = refreshError.toString();
              final isMissingRefreshToken =
                  errorMsg.contains('No refresh token');

              // Refresh failed, clear auth data and redirect to login
              box.remove('authToken');
              box.remove('refreshToken');
              box.remove('authIssuedAt');
              box.remove('lastCheckDate');
              box.remove('user');

              // Show appropriate message
              if (isMissingRefreshToken) {
                // Old user - needs to login again for security upgrade
                getx.Get.snackbar(
                  'Security Update',
                  'Please login again to enable automatic session refresh (stay logged in for 30 days)',
                  snackPosition: getx.SnackPosition.TOP,
                  duration: const Duration(seconds: 5),
                );
              } else {
                // Normal session expiry (30 days inactive)
                getx.Get.snackbar(
                  'Session Expired',
                  'Your session has expired. Please login again.',
                  snackPosition: getx.SnackPosition.TOP,
                  duration: const Duration(seconds: 3),
                );
              }

              getx.Get.offAllNamed(AppRoutes.login);

              return handler.reject(e);
            }
          }

          return handler.next(e);
        },
      ),
    );
  }

  Future<Response> get(String path,
      {Map<String, dynamic>? queryParameters}) async {
    try {
      return await _dio.get(path, queryParameters: queryParameters);
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> post(String path, {dynamic data}) async {
    try {
      return await _dio.post(path, data: data);
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> put(String path, {dynamic data}) async {
    try {
      return await _dio.put(path, data: data);
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> delete(String path) async {
    try {
      return await _dio.delete(path);
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> deleteWithOptions(String path,
      {Map<String, dynamic>? queryParameters, dynamic data}) async {
    return _dio.delete(
      path,
      queryParameters: queryParameters,
      data: data,
      options: Options(validateStatus: (_) => true),
    );
  }

  /// Refresh access token using refresh token
  Future<void> _refreshToken() async {
    if (_isRefreshing) {
      // Already refreshing, wait for it
      await Future.delayed(const Duration(milliseconds: 100));
      return;
    }

    _isRefreshing = true;

    try {
      final refreshToken = box.read('refreshToken') as String?;

      if (refreshToken == null) {
        throw Exception('No refresh token available');
      }

      if (kDebugMode) {
        print('Refreshing access token...');
      }

      // Call refresh endpoint
      final response = await _dio.post(
        '/auth/refresh',
        data: {'refreshToken': refreshToken},
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        final data = response.data['data'];
        final tokens = data['tokens'];

        // Store new tokens
        await box.write('authToken', tokens['accessToken']);
        await box.write('refreshToken', tokens['refreshToken']);
        await box.write('authIssuedAt', DateTime.now().toIso8601String());

        // Store user data if present
        if (data['user'] != null) {
          await box.write('user', data['user']);
        }

        if (kDebugMode) {
          print('Token refreshed successfully');
        }
      } else {
        throw Exception('Token refresh failed');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Token refresh error: $e');
      }
      rethrow;
    } finally {
      _isRefreshing = false;
    }
  }
}
