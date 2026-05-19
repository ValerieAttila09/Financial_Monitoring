import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:upsm_flutter/widgets/add_transaction_sheet.dart';
import 'package:upsm_flutter/widgets/bottom_nav.dart';
import 'package:upsm_flutter/widgets/center_pill_fab.dart';

import '../../widgets/animated_chart.dart';
import '../../providers/analytics_provider.dart';

class AnalyticsScreen extends ConsumerWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dailyAsync = ref.watch(dailyTotalsProvider);
    final monthlyAsync = ref.watch(monthlyTotalsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Analytics')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const Text(
              'Grafik 7 Hari Terakhir (Income vs Expense)',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            dailyAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, st) => Text('Gagal memuat data harian: $e'),
              data: (data) {
                final items = (data['data'] as List<dynamic>?) ?? [];
                final mapped = _extractSeries(items, keyLabel: (m) => m['day']);
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AnimatedChart(
                          income: mapped.income,
                          expense: mapped.expense,
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 12,
                          children: [
                            _Legend(label: 'Income', color: Colors.green),
                            _Legend(label: 'Expense', color: Colors.red),
                          ],
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 18),
            const Text(
              'Grafik 6 Bulan Terakhir (Income vs Expense)',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            monthlyAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, st) => Text('Gagal memuat data bulanan: $e'),
              data: (data) {
                final items = (data['data'] as List<dynamic>?) ?? [];
                final mapped =
                    _extractSeries(items, keyLabel: (m) => m['month']);
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AnimatedChart(
                          income: mapped.income,
                          expense: mapped.expense,
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 12,
                          children: [
                            _Legend(label: 'Income', color: Colors.green),
                            _Legend(label: 'Expense', color: Colors.red),
                          ],
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: CenterPillFab(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (_) => const AddTransactionSheet(),
          );
        },
        icon: Icons.add,
        label: null,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: const BottomNav(),
    );
  }
}

class _Legend extends StatelessWidget {
  final String label;
  final Color color;
  const _Legend({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(width: 10, height: 10, color: color),
        const SizedBox(width: 6),
        Text(label),
      ],
    );
  }
}

class _SeriesMapped {
  final List<double> income;
  final List<double> expense;
  const _SeriesMapped({required this.income, required this.expense});
}

_SeriesMapped _extractSeries(List<dynamic> items,
    {required dynamic Function(Map<String, dynamic>) keyLabel}) {
  // Backend returns: { data: [ { _id: { day|month, type }, total }, ... ] }
  // We normalize into fixed-length arrays so AnimatedChart always receives
  // predictable points (7 days / 6 months). If backend returns less/more,
  // we fill missing with 0.

  final Map<String, double> incomeByKey = {};
  final Map<String, double> expenseByKey = {};

  for (final raw in items) {
    if (raw is! Map) continue;
    final m = raw.cast<String, dynamic>();
    final id = m['_id'];

    String? key;
    String? type;
    double total = 0.0;

    if (id is Map) {
      key = (id['day'] ?? id['month'])?.toString();
      type = id['type']?.toString();
    } else {
      key = keyLabel(m);
      type = m['type']?.toString();
    }

    final t = m['total'];
    if (t is num) total = t.toDouble();

    if (key == null || type == null) continue;

    if (type == 'income') {
      incomeByKey[key] = (incomeByKey[key] ?? 0) + total;
    } else if (type == 'expense') {
      expenseByKey[key] = (expenseByKey[key] ?? 0) + total;
    }
  }

  final now = DateTime.now();

  // Determine whether this series is daily (YYYY-MM-DD) or monthly (YYYY-MM)
  // by checking the expected key format from the keyLabel.
  final isMonthly = keyLabel({'month': '2000-01'}) == '2000-01';

  if (!isMonthly) {
    // 7 days: YYYY-MM-DD
    final days = List.generate(7, (i) {
      final d = DateTime(now.year, now.month, now.day)
          .subtract(Duration(days: 6 - i));
      return '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
    });

    final income = days.map((k) => incomeByKey[k] ?? 0.0).toList();
    final expense = days.map((k) => expenseByKey[k] ?? 0.0).toList();
    return _SeriesMapped(income: income, expense: expense);
  } else {
    // 6 months: YYYY-MM (fallback to 7 points because AnimatedChart expects >=2)
    final months = List.generate(6, (i) {
      final m = DateTime(now.year, now.month, 1)
          .subtract(Duration(days: 30 * (5 - i)));
      // safer: compute by shifting months
      final shifted = DateTime(now.year, now.month - (5 - i), 1);
      return '${shifted.year.toString().padLeft(4, '0')}-${shifted.month.toString().padLeft(2, '0')}';
    });

    final income6 = months.map((k) => incomeByKey[k] ?? 0.0).toList();
    final expense6 = months.map((k) => expenseByKey[k] ?? 0.0).toList();

    // AnimatedChart is coded for arbitrary lengths, but default UI expects 6/7.
    // Keep exactly 6 here; if your painter needs >=2 points, 6 is fine.
    return _SeriesMapped(income: income6, expense: expense6);
  }
}
