import 'package:dio/dio.dart';

class AnalyticsService {
  final Dio dio;
  AnalyticsService(this.dio);

  Future<Map<String, dynamic>> fetchDailyTotals() async {
    final resp = await dio.get('/api/analytics/daily');
    return resp.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> fetchMonthlyTotals() async {
    final resp = await dio.get('/api/analytics/monthly');
    return resp.data as Map<String, dynamic>;
  }
}
