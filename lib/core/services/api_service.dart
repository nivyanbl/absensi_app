import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_storage/get_storage.dart';

class ApiService {
  final Dio _dio;
  final box = GetStorage();

  ApiService()
      : _dio = Dio(BaseOptions(baseUrl: dotenv.env['API_BASE_URL']!)) {
    
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          final String? token = box.read('authToken');

          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          
          return handler.next(options); 
        },
        onError: (DioException e, handler) {
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
}