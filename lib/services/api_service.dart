import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiService {
  final Dio dio;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  ApiService(String baseUrl)
      : dio = Dio(BaseOptions(
            baseUrl: baseUrl, connectTimeout: const Duration(seconds: 10))) {
    dio.interceptors
        .add(InterceptorsWrapper(onRequest: (options, handler) async {
      final token = await _storage.read(key: 'jwt');
      if (token != null) options.headers['Authorization'] = 'Bearer $token';
      return handler.next(options);
    }));
  }

  Future<Response> post(String path, dynamic data,
      {Map<String, dynamic>? headers}) async {
    return dio.post(path, data: data, options: Options(headers: headers));
  }

  Future<Response> get(String path,
      {Map<String, dynamic>? queryParameters,
      Map<String, dynamic>? headers}) async {
    return dio.get(path,
        queryParameters: queryParameters, options: Options(headers: headers));
  }
}
