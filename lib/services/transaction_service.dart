import 'api_service.dart';
import '../models/transaction.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final _notif = FlutterLocalNotificationsPlugin();

Future<void> _initNotifications() async {
  const android = AndroidInitializationSettings('@mipmap/ic_launcher');
  const settings = InitializationSettings(android: android);
  try {
    await _notif.initialize(settings);
  } catch (_) {}
}

class TransactionService {
  final ApiService api;
  TransactionService(this.api);

  /// cache key for transactions
  static const _cacheKey = 'cached_transactions_v1';

  /// Ensure notifications initialized
  void _ensureNotif() {
    _initNotifications();
  }

  Future<List<TransactionModel>> fetchTransactions(
      {Map<String, dynamic>? params}) async {
    try {
      final resp = await api.get('/api/transactions', queryParameters: params);
      final list = resp.data['data'] as List<dynamic>;
      final items = list
          .map((e) => TransactionModel.fromMap(e as Map<String, dynamic>))
          .toList();
      // cache the last result
      try {
        final prefs = await SharedPreferences.getInstance();
        prefs.setString(
            _cacheKey, jsonEncode(items.map((e) => e.toMap()).toList()));
      } catch (_) {}
      return items;
    } catch (e) {
      // fallback to cache
      try {
        final prefs = await SharedPreferences.getInstance();
        final raw = prefs.getString(_cacheKey);
        if (raw != null) {
          final list = jsonDecode(raw) as List<dynamic>;
          return list
              .map((e) => TransactionModel.fromMap(e as Map<String, dynamic>))
              .toList();
        }
      } catch (_) {}
      rethrow;
    }
  }

  Future<TransactionModel> createTransaction(Map<String, dynamic> body) async {
    final resp = await api.post('/api/transactions', body);
    final t = TransactionModel.fromMap(resp.data['data']);
    // update cache (prepend)
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_cacheKey);
      List<dynamic> existing = [];
      if (raw != null) existing = jsonDecode(raw) as List<dynamic>;
      existing.insert(0, t.toMap());
      prefs.setString(_cacheKey, jsonEncode(existing));
    } catch (_) {}
    // notify user
    try {
      _ensureNotif();
      _notif.show(
          0,
          'Transaksi baru',
          'Rp ${t.amount} - ${t.category}',
          const NotificationDetails(
              android: AndroidNotificationDetails('tx_channel', 'Transactions',
                  importance: Importance.defaultImportance)));
    } catch (_) {}
    return t;
  }

  Future<TransactionModel> updateTransaction(
      String id, Map<String, dynamic> body) async {
    final resp = await api.dio.put('/api/transactions/$id', data: body);
    return TransactionModel.fromMap(resp.data['data']);
  }

  Future<void> deleteTransaction(String id) async {
    await api.dio.delete('/api/transactions/$id');
  }
}
