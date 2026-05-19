import 'api_service.dart';
import '../models/transaction.dart';

class TransactionService {
  final ApiService api;
  TransactionService(this.api);

  Future<List<TransactionModel>> fetchTransactions(
      {Map<String, dynamic>? params}) async {
    final resp = await api.get('/api/transactions', queryParameters: params);
    final list = resp.data['data'] as List<dynamic>;
    return list
        .map((e) => TransactionModel.fromMap(e as Map<String, dynamic>))
        .toList();
  }

  Future<TransactionModel> createTransaction(Map<String, dynamic> body) async {
    final resp = await api.post('/api/transactions', body);
    return TransactionModel.fromMap(resp.data['data']);
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
