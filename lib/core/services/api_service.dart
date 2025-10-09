import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_storage/get_storage.dart';
import 'package:get/get.dart' as getx;
import 'package:employment_attendance/navigation/app_routes.dart';
import 'package:flutter/foundation.dart';

class ApiService {
  final Dio _dio;
  final box = GetStorage();

  ApiService()
      : _dio = Dio(BaseOptions(
          baseUrl:
              dotenv.env['API_BASE_URL'] ?? 'https://api.workforces.ninja/api',
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
      InterceptorsWrapper(onRequest: (options, handler) {
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
      }, onResponse: (response, handler) {
        if (kDebugMode) {
          print(
              'API Response <- ${response.statusCode} ${response.requestOptions.method} ${response.requestOptions.path}');
        }
        return handler.next(response);
      }, onError: (DioException e, handler) {
        if (kDebugMode) {
          final req = e.requestOptions;
          print('API Error !! ${e.message}');
          print('When calling: ${req.method} ${req.baseUrl}${req.path}');
          print(
              'Error response: ${e.response?.statusCode} ${e.response?.data}');
        }

        // Handle 401 (Token expired)
        if (e.response?.statusCode == 401) {
          if (kDebugMode) {
            print("Token expired, logging out...");
          }

          // Clear auth data
          box.remove('authToken');
          box.remove('authIssuedAt');
          box.remove('refreshToken');

          // Redirect to login
          getx.Get.offAllNamed(AppRoutes.login);
        }

        return handler.next(e);
      }),
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
}
