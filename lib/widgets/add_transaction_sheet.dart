import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';
import '../utils/currency_input_formatter.dart';
import '../providers/transactions_provider.dart';

class AddTransactionSheet extends ConsumerStatefulWidget {
  const AddTransactionSheet({super.key});

  @override
  ConsumerState<AddTransactionSheet> createState() =>
      _AddTransactionSheetState();
}

class _AddTransactionSheetState extends ConsumerState<AddTransactionSheet> {
  final _formKey = GlobalKey<FormState>();
  final _category = TextEditingController();
  final _amount = TextEditingController();
  final _desc = TextEditingController();
  String _type = 'income';
  bool _loading = false;

  // Helper: parse formatted currency like '1,234' to double
  double _parseCurrency(String input) {
    final digits = input.replaceAll(RegExp(r'[^0-9]'), '');
    if (digits.isEmpty) return 0.0;
    return double.parse(digits);
  }

  @override
  void dispose() {
    _category.dispose();
    _amount.dispose();
    _desc.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    final body = {
      'type': _type,
      'category': _category.text.trim(),
      'amount': _parseCurrency(_amount.text),
      'description': _desc.text.trim(),
      'paymentMethod': 'cash',
      'transactionDate': DateTime.now().toIso8601String(),
    };
    try {
      await ref.read(transactionsListProvider.notifier).add(body);
      if (!mounted) return;
      Navigator.of(context).pop();
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Create failed: $e')));
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: 0.35,
      maxChildSize: 0.95,
      builder: (context, sc) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          controller: sc,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                  child:
                      Container(height: 4, width: 40, color: Colors.grey[300])),
              const SizedBox(height: 12),
              const Text('Tambah Transaksi',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              Form(
                key: _formKey,
                child: Column(children: [
                  Row(children: [
                    Expanded(
                        child: RadioListTile<String>(
                            value: 'income',
                            groupValue: _type,
                            title: const Text('Pemasukan'),
                            onChanged: (v) => setState(() => _type = v!))),
                    Expanded(
                        child: RadioListTile<String>(
                            value: 'expense',
                            groupValue: _type,
                            title: const Text('Pengeluaran'),
                            onChanged: (v) => setState(() => _type = v!))),
                  ]),
                  TextFormField(
                      controller: _category,
                      decoration: const InputDecoration(labelText: 'Kategori'),
                      validator: (v) => (v == null || v.trim().isEmpty)
                          ? 'Masukkan kategori'
                          : null),
                  TextFormField(
                      controller: _amount,
                      decoration: const InputDecoration(
                          labelText: 'Jumlah', prefixText: 'Rp '),
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        CurrencyInputFormatter(locale: 'id_ID', symbol: '')
                      ],
                      validator: (v) => (_parseCurrency(v ?? '') <= 0)
                          ? 'Jumlah tidak valid'
                          : null),
                  TextFormField(
                      controller: _desc,
                      decoration:
                          const InputDecoration(labelText: 'Keterangan')),
                  const SizedBox(height: 16),
                  _loading
                      ? const CircularProgressIndicator()
                      : ElevatedButton(
                          onPressed: _submit, child: const Text('Simpan'))
                ]),
              )
            ],
          ),
        ),
      ),
    );
  }
}
