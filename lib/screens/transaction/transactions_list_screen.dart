import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/transactions_provider.dart';
import '../../widgets/add_transaction_sheet.dart';

String _formatCurrency(double value) {
  final s = value.toStringAsFixed(0);
  final chars = s.split('').reversed.toList();
  final parts = <String>[];
  for (var i = 0; i < chars.length; i += 3) {
    parts.add(chars.skip(i).take(3).toList().reversed.join());
  }
  return 'Rp ${parts.reversed.join(',')}';
}

String _formatDate(DateTime d) {
  // simple: dd MMM
  final months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'Mei',
    'Jun',
    'Jul',
    'Agu',
    'Sep',
    'Okt',
    'Nov',
    'Des'
  ];
  return '${d.day} ${months[d.month - 1]} ${d.year}';
}

class TransactionsListScreen extends ConsumerWidget {
  const TransactionsListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(transactionsListProvider);
    Future<void> refresh() async {
      await ref.read(transactionsListProvider.notifier).fetch();
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Riwayat Transaksi')),
      body: RefreshIndicator(
        onRefresh: refresh,
        child: items.isEmpty
            ? ListView(
                children: [
                  SizedBox(height: 48),
                  Center(
                      child: Text('Belum ada transaksi',
                          style: Theme.of(context).textTheme.titleMedium)),
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: ElevatedButton.icon(
                        onPressed: () {
                          showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                              builder: (_) => const AddTransactionSheet());
                        },
                        icon: const Icon(Icons.add),
                        label: const Text('Tambah Transaksi')),
                  )
                ],
              )
            : ListView.separated(
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                itemCount: items.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (context, i) {
                  final t = items[i];
                  final isIncome = t.type == 'income';
                  return Dismissible(
                    key: ValueKey(t.id),
                    background: Container(
                        decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(12)),
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: const Icon(Icons.delete, color: Colors.white)),
                    direction: DismissDirection.endToStart,
                    onDismissed: (_) async {
                      await ref
                          .read(transactionsListProvider.notifier)
                          .remove(t.id);
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      elevation: 1,
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        leading: CircleAvatar(
                          radius: 22,
                          backgroundColor: isIncome
                              ? Colors.green.shade50
                              : Colors.red.shade50,
                          child: Icon(
                              isIncome
                                  ? Icons.arrow_downward
                                  : Icons.arrow_upward,
                              color: isIncome ? Colors.green : Colors.red),
                        ),
                        title: Text(t.category,
                            style:
                                const TextStyle(fontWeight: FontWeight.w600)),
                        subtitle: Text(t.description),
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(_formatCurrency(t.amount),
                                style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    color: isIncome
                                        ? Colors.green[700]
                                        : Colors.red[700])),
                            const SizedBox(height: 4),
                            Text(_formatDate(t.transactionDate),
                                style: const TextStyle(
                                    fontSize: 12, color: Colors.grey))
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
