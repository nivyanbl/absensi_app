import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_storage/get_storage.dart';

class ApiService {
  final Dio _dio;
  final box = GetStorage();

  ApiService()
      : _dio = Dio(BaseOptions(baseUrl: dotenv.env['API_BASE_URL']!)) {
    
    // Add an interceptor that attaches the auth token and logs request/response
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          final String? token = box.read('authToken');

          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }

          // Debug log request summary
          try {
            print('API Request -> ${options.method} ${options.baseUrl}${options.path}');
            print('Headers: ${options.headers}');
            print('Data: ${options.data}');
          } catch (_) {}

          return handler.next(options);
        },
        onResponse: (response, handler) {
          try {
            print('API Response <- ${response.statusCode} ${response.requestOptions.method} ${response.requestOptions.path}');
            print('Response data: ${response.data}');
          } catch (_) {}
          return handler.next(response);
        },
        onError: (DioException e, handler) {
          try {
            final req = e.requestOptions;
            print('API Error !! ${e.message}');
            print('When calling: ${req.method} ${req.baseUrl}${req.path}');
            print('Request headers: ${req.headers}');
            print('Request data: ${req.data}');
            print('Error response: ${e.response?.statusCode} ${e.response?.data}');
          } catch (_) {}

          if (e.response?.statusCode == 401) {
            print("Token expired, logging out...");
          }
          return handler.next(e);
        }
      ),
    );
  }

  Future<Response> get(String path, {Map<String, dynamic>? queryParameters}) async {
    return _dio.get(path, queryParameters: queryParameters);
  }

  Future<Response> post(String path, {dynamic data}) async {
    return _dio.post(path, data: data);
  }
  
  Future<Response> put(String path, {dynamic data}) async {
    return _dio.put(path, data: data);
  }

  Future<Response> delete(String path) async {
    return _dio.delete(path);
  }

  /// Delete but do not throw on non-2xx — returns the Response so caller can inspect status/data.
  Future<Response> deleteWithOptions(String path, {Map<String, dynamic>? queryParameters, dynamic data}) async {
    return _dio.delete(
      path,
      queryParameters: queryParameters,
      data: data,
      options: Options(validateStatus: (_) => true),
    );
  }
}