import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../services/api_service.dart';
import '../models/user.dart';

final _storage = const FlutterSecureStorage();

final apiServiceProvider =
    Provider<ApiService>((ref) => ApiService('http://10.0.2.2:4000'));

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
