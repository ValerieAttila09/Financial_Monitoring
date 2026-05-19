import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/transactions_provider.dart';

class TransactionsListScreen extends ConsumerWidget {
  const TransactionsListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(transactionsListProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Riwayat Transaksi')),
      body: items.isEmpty
          ? const Center(child: Text('Tidak ada transaksi'))
          : ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, i) {
                final t = items[i];
                return Dismissible(
                  key: ValueKey(t.id),
                  background: Container(
                      color: Colors.red,
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: const Icon(Icons.delete, color: Colors.white)),
                  direction: DismissDirection.endToStart,
                  onDismissed: (_) async {
                    await ref
                        .read(transactionsListProvider.notifier)
                        .remove(t.id);
                  },
                  child: ListTile(
                      title: Text(
                          '${t.category} - Rp ${t.amount.toStringAsFixed(0)}'),
                      subtitle: Text(t.description)),
                );
              },
            ),
    );
  }
}
