import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/transactions_provider.dart';
import '../../routes/app_router.dart';

class AddTransactionScreen extends ConsumerStatefulWidget {
  const AddTransactionScreen({super.key});

  @override
  ConsumerState<AddTransactionScreen> createState() =>
      _AddTransactionScreenState();
}

class _AddTransactionScreenState extends ConsumerState<AddTransactionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amount = TextEditingController();
  final _desc = TextEditingController();
  String _type = 'income';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tambah Transaksi')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(children: [
            DropdownButtonFormField<String>(
                value: _type,
                items: const [
                  DropdownMenuItem(value: 'income', child: Text('Pemasukan')),
                  DropdownMenuItem(value: 'expense', child: Text('Pengeluaran'))
                ],
                onChanged: (v) => setState(() => _type = v ?? 'income')),
            TextFormField(
                controller: _amount,
                decoration: const InputDecoration(labelText: 'Nominal'),
                keyboardType: TextInputType.number),
            TextFormField(
                controller: _desc,
                decoration: const InputDecoration(labelText: 'Deskripsi')),
            const SizedBox(height: 12),
            ElevatedButton(
                onPressed: () async {
                  if (!_formKey.currentState!.validate()) return;
                  final body = {
                    'type': _type,
                    'category': 'Penjualan',
                    'amount': double.tryParse(_amount.text) ?? 0,
                    'description': _desc.text,
                    'paymentMethod': 'Cash',
                    'transactionDate': DateTime.now().toIso8601String()
                  };
                  final messenger = ScaffoldMessenger.of(context);
                  try {
                    await ref.read(transactionsListProvider.notifier).add(body);
                    if (!mounted) return;
                    messenger.showSnackBar(
                        const SnackBar(content: Text('Transaksi disimpan')));
                    ref.read(appRouterProvider).pop();
                  } catch (e) {
                    messenger
                        .showSnackBar(SnackBar(content: Text('Gagal: $e')));
                  }
                },
                child: const Text('Simpan'))
          ]),
        ),
      ),
    );
  }
}
