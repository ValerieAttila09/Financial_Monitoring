import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/user.dart';
import '../providers/auth_provider.dart';
import '../services/api_service.dart';

final profileServiceProvider = Provider<ProfileService>((ref) {
  final api = ref.read(apiServiceProvider);
  return ProfileService(api);
});

class ProfileService {
  final ApiService api;
  ProfileService(this.api);

  Future<User> fetchProfile() async {
    final resp = await api.get('/api/auth/profile');
    final userMap = resp.data['user'] as Map<String, dynamic>;
    return User.fromMap(userMap);
  }
}

/// Async profile from backend. This ensures ProfileScreen can render data
/// even if app launch doesn't yet populate authProvider.
final profileProvider = FutureProvider<User>((ref) async {
  // ensure token is loaded indirectly by requiring authProvider exists in graph
  ref.watch(authProvider);
  return ref.read(profileServiceProvider).fetchProfile();
});

