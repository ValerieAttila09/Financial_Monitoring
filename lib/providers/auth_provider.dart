import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io' show Platform;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../services/api_service.dart';
import '../models/user.dart';

final _storage = const FlutterSecureStorage();

final apiServiceProvider = Provider<ApiService>((ref) {
  // choose baseUrl depending on platform
  String baseUrl = 'http://localhost:4000';
  if (kIsWeb) {
    baseUrl = 'http://localhost:4000';
  } else {
    try {
      if (Platform.isAndroid) {
        // Android emulator
        baseUrl = 'http://10.0.2.2:4000';
      } else {
        baseUrl = 'http://localhost:4000';
      }
    } catch (_) {
      baseUrl = 'http://localhost:4000';
    }
  }
  return ApiService(baseUrl);
});

final authProvider = StateNotifierProvider<AuthNotifier, User?>(
  (ref) => AuthNotifier(ref),
);

class AuthNotifier extends StateNotifier<User?> {
  final Ref ref;
  AuthNotifier(this.ref) : super(null) {
    _loadUser();
  }

  Future<void> _loadUser() async {
    final token = await _storage.read(key: 'jwt');
    if (token != null) {
      // in real app call /auth/profile
      // here we keep null-check placeholder
    }
  }

  Future<void> login(String email, String password) async {
    final api = ref.read(apiServiceProvider);
    final resp = await api
        .post('/api/auth/login', {'email': email, 'password': password});
    final data = resp.data;
    await _storage.write(key: 'jwt', value: data['token']);
    state = User.fromMap(data['user']);
  }

  Future<void> register(String fullname, String businessName, String email,
      String password) async {
    final api = ref.read(apiServiceProvider);
    final resp = await api.post('/api/auth/register', {
      'fullname': fullname,
      'businessName': businessName,
      'email': email,
      'password': password
    });
    final data = resp.data;
    await _storage.write(key: 'jwt', value: data['token']);
    state = User.fromMap(data['user']);
  }

  Future<void> logout() async {
    await _storage.delete(key: 'jwt');
    state = null;
  }
}
