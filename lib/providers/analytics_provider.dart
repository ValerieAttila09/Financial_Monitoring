import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/analytics_service.dart';
import 'auth_provider.dart';

final analyticsServiceProvider = Provider<AnalyticsService>((ref) {
  final api = ref.read(apiServiceProvider);
  return AnalyticsService(api.dio);
});

final dailyTotalsProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  final svc = ref.read(analyticsServiceProvider);
  return svc.fetchDailyTotals();
});

final monthlyTotalsProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  final svc = ref.read(analyticsServiceProvider);
  return svc.fetchMonthlyTotals();
});
