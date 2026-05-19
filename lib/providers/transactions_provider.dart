import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/transaction_service.dart';
import 'auth_provider.dart';
import '../models/transaction.dart';

final transactionServiceProvider = Provider<TransactionService>((ref) {
  final api = ref.read(apiServiceProvider);
  return TransactionService(api);
});

final transactionsListProvider =
    StateNotifierProvider<TransactionsNotifier, List<TransactionModel>>((ref) {
  return TransactionsNotifier(ref);
});

class TransactionsNotifier extends StateNotifier<List<TransactionModel>> {
  final Ref ref;
  TransactionsNotifier(this.ref) : super([]) {
    fetch();
  }

  Future<void> fetch([Map<String, dynamic>? params]) async {
    final svc = ref.read(transactionServiceProvider);
    final items = await svc.fetchTransactions(params: params);
    state = items;
  }

  Future<void> add(Map<String, dynamic> body) async {
    final svc = ref.read(transactionServiceProvider);
    final t = await svc.createTransaction(body);
    state = [t, ...state];
  }

  Future<void> remove(String id) async {
    final svc = ref.read(transactionServiceProvider);
    await svc.deleteTransaction(id);
    state = state.where((e) => e.id != id).toList();
  }
}
