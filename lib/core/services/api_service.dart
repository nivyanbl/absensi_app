import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_storage/get_storage.dart';
import 'package:get/get.dart' as getx;
import 'package:employment_attendance/navigation/app_routes.dart';
import 'package:flutter/foundation.dart';
import 'dart:io';

class _PendingRequest {
  final DioException error;
  final ErrorInterceptorHandler handler;
  _PendingRequest(this.error, this.handler);
}

class ApiService {
  final Dio _dio;
  final box = GetStorage();
  late PersistCookieJar _cookieJar;

  bool _isRefreshing = false;
  final List<_PendingRequest> _subscribers = [];

  ApiService._(this._dio);

  static Future<ApiService> create() async {
    final dio = Dio(BaseOptions(
      baseUrl: dotenv.env['API_BASE_URL'] ?? '',
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      sendTimeout: const Duration(seconds: 30),
    ));

    Directory appDocDir = await getApplicationDocumentsDirectory();
    String appDocPath = appDocDir.path;
    final cookieJar = PersistCookieJar(
      ignoreExpires: true,
      storage: FileStorage(appDocPath + "/.cookies/"),
    );

    final apiService = ApiService._(dio);
    apiService._cookieJar = cookieJar;

    dio.interceptors.add(CookieManager(cookieJar));

    dio.interceptors.add(
      QueuedInterceptorsWrapper(
        onRequest: (options, handler) {
          final String? token = apiService.box.read('authToken');
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          if (kDebugMode) {
            print(
                'API Request -> ${options.method} ${options.baseUrl}${options.path}');
          }
          return handler.next(options);
        },
        onResponse: (response, handler) {
          return handler.next(response);
        },
        onError: (DioException e, ErrorInterceptorHandler handler) async {
          if (kDebugMode) {
            apiService._logError(e);
          }

          if (e.response?.statusCode == 401) {
            if (e.requestOptions.path == '/auth/refresh') {
              debugPrint("API SERVICE: Refresh token failed. Logging out.");
              await apiService.logout();
              return handler.reject(e);
            }

            if (!apiService._isRefreshing) {
              apiService._isRefreshing = true;

              try {
                final newAccessToken = await apiService._refreshToken();

                if (newAccessToken != null) {
                  debugPrint("API SERVICE: Token refreshed successfully.");
                  e.requestOptions.headers['Authorization'] =
                      'Bearer $newAccessToken';
                  final response = await dio.fetch(e.requestOptions);
                  handler.resolve(response);

                  for (var req in apiService._subscribers) {
                    try {
                      req.error.requestOptions.headers['Authorization'] =
                          'Bearer $newAccessToken';
                      final response =
                          await dio.fetch(req.error.requestOptions);
                      req.handler.resolve(response);
                    } catch (e) {
                      req.handler.reject(e as DioException);
                    }
                  }
                } else {
                  debugPrint(
                      "API SERVICE: Refresh token failed (null). Logging out.");
                  await apiService.logout();
                  handler.reject(e);
                  apiService._subscribers
                      .forEach((req) => req.handler.reject(req.error));
                }
              } catch (err) {
                debugPrint(
                    "API SERVICE: Exception during token refresh. Logging out. $err");
                await apiService.logout();
                handler.reject(err as DioException);
                apiService._subscribers
                    .forEach((req) => req.handler.reject(req.error));
              } finally {
                apiService._isRefreshing = false;
                apiService._subscribers.clear();
              }
            } else {
              apiService._subscribers.add(_PendingRequest(e, handler));
            }
          } else {
            return handler.next(e);
          }
        },
      ),
    );

    return apiService;
  }

  Future<String?> _refreshToken() async {
    try {
      final refreshDio = Dio(BaseOptions(
        baseUrl: dotenv.env['API_BASE_URL'] ?? '',
      ));
      refreshDio.interceptors.add(CookieManager(_cookieJar));

      final response = await refreshDio.post('/auth/refresh');

      if (response.statusCode == 200 && response.data != null) {
        try {
          final newAccessToken = response.data['data']['tokens']['accessToken'];

          await box.write('authToken', newAccessToken);
          await box.write('authIssuedAt', DateTime.now().toIso8601String());

          return newAccessToken;
        } catch (e) {
          debugPrint('Failed to parse refresh token JSON: $e');
          return null;
        }
      } else {
        return null;
      }
    } catch (e) {
      debugPrint("API SERVICE: _refreshToken failed: $e");
      return null;
    }
  }

  Future<void> logout() async {
    try {
      await post('/auth/logout');
    } catch (e) {
      debugPrint("Server logout failed (ignoring): $e");
    }

    await _cookieJar.deleteAll();

    box.remove('authToken');
    box.remove('authIssuedAt');
    box.remove('refreshToken');

    getx.Get.offAllNamed(AppRoutes.login);
    debugPrint("Local tokens and cookies cleared. Logged out.");
  }

  void _logError(DioException e) {
    if (kDebugMode) {
      final req = e.requestOptions;
      print('API Error !! ${e.message}');
      print('When calling: ${req.method} ${req.baseUrl}${req.path}');
      print('Error response: ${e.response?.statusCode} ${e.response?.data}');
    }
  }

  Dio get client => _dio;

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
