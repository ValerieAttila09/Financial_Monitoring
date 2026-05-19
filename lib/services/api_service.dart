import 'package:dio/dio.dart';
import 'package:dio/dio.dart' as dio_pkg;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiService {
  final Dio dio;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  final String baseUrl;
  final bool _mixedContentRisk;

  ApiService(this.baseUrl)
      : _mixedContentRisk = kIsWeb &&
            Uri.base.scheme == 'https' &&
            baseUrl.startsWith('http://'),
        dio = Dio(BaseOptions(
            baseUrl: baseUrl, connectTimeout: const Duration(seconds: 30))) {
    dio.interceptors
        .add(InterceptorsWrapper(onRequest: (options, handler) async {
      final token = await _storage.read(key: 'jwt');
      if (token != null) {
        options.headers['Authorization'] = 'Bearer $token';
      }
      return handler.next(options);
    }));
  }

  Future<Response> post(String path, dynamic data,
      {Map<String, dynamic>? headers}) async {
    try {
      if (_mixedContentRisk) {
        // Browser will block mixed content (HTTPS page -> HTTP request). Provide helpful error immediately.
        throw Exception(
            'Blocked request: the app is served over HTTPS but the backend URL is HTTP ($baseUrl). The browser blocks mixed content. Run the backend over HTTPS or serve the app over HTTP.');
      }
      return await dio.post(path,
          data: data, options: Options(headers: headers));
    } catch (e) {
      if (e is dio_pkg.DioException) {
        if (e.type == dio_pkg.DioExceptionType.connectionTimeout) {
          throw Exception(
              'Connection timeout. Please check server and network.');
        }
        if (e.type == dio_pkg.DioExceptionType.receiveTimeout) {
          throw Exception('Receive timeout. Server may be slow.');
        }
        if (e.response != null) {
          final body = e.response?.data;
          // If backend returns structured error { message, errors: [...] }
          if (body is Map && body['message'] != null) {
            // If there is an `errors` array (from express-validator), include details
            if (body['errors'] != null && body['errors'] is List) {
              try {
                final List errList = body['errors'] as List;
                final details = errList.map((it) {
                  if (it is Map && it['msg'] != null) return it['msg'];
                  return it.toString();
                }).join('; ');
                throw Exception('${body['message']}: $details');
              } catch (_) {
                // fallback to message only
                throw Exception(body['message']);
              }
            }
            throw Exception(body['message']);
          }
          throw Exception('Server error: ${e.response?.statusCode}');
        }
      }
      throw Exception('Request failed: $e');
    }
  }

  Future<Response> get(String path,
      {Map<String, dynamic>? queryParameters,
      Map<String, dynamic>? headers}) async {
    try {
      if (_mixedContentRisk) {
        throw Exception(
            'Blocked request: the app is served over HTTPS but the backend URL is HTTP ($baseUrl). The browser blocks mixed content. Run the backend over HTTPS or serve the app over HTTP.');
      }
      return await dio.get(path,
          queryParameters: queryParameters, options: Options(headers: headers));
    } catch (e) {
      if (e is dio_pkg.DioException) {
        if (e.type == dio_pkg.DioExceptionType.connectionTimeout) {
          throw Exception(
              'Connection timeout. Please check server and network.');
        }
        if (e.response != null) {
          final body = e.response?.data;
          if (body is Map && body['message'] != null) {
            if (body['errors'] != null && body['errors'] is List) {
              try {
                final List errList = body['errors'] as List;
                final details = errList.map((it) {
                  if (it is Map && it['msg'] != null) return it['msg'];
                  return it.toString();
                }).join('; ');
                throw Exception('${body['message']}: $details');
              } catch (_) {
                throw Exception(body['message']);
              }
            }
            throw Exception(body['message']);
          }
          throw Exception('Server error: ${e.response?.statusCode}');
        }
      }
      throw Exception('Request failed: $e');
    }
  }
}
