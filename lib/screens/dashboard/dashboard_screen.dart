import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// analytics_provider not used directly here; dashboardProvider aggregates necessary data
import '../../providers/dashboard_provider.dart';
import '../../widgets/animated_chart.dart';
import '../../widgets/add_transaction_sheet.dart';
import '../../widgets/bottom_nav.dart';
import '../../widgets/center_pill_fab.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboard = ref.watch(dashboardProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: dashboard.when(
            data: (s) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          child: Padding(
                            padding: const EdgeInsets.all(14.0),
                            child: Column(children: [
                              const Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text('Total Pemasukan Hari Ini')),
                              const SizedBox(height: 8),
                              Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text('Rp ${s.totalIncomeToday}',
                                      style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold)))
                            ]),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          child: Padding(
                            padding: const EdgeInsets.all(14.0),
                            child: Column(children: [
                              const Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text('Total Pengeluaran Hari Ini')),
                              const SizedBox(height: 8),
                              Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text('Rp ${s.totalExpenseToday}',
                                      style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold)))
                            ]),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Laba Bersih Hari Ini'),
                                  const SizedBox(height: 8),
                                  Text('Rp ${s.profitToday}',
                                      style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold)),
                                  const SizedBox(height: 6),
                                  Text(
                                      'Keuntungan: ${s.percentProfit.toStringAsFixed(1)}%')
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          AnimatedChart(
                              income: s.weeklyIncome, expense: s.weeklyExpense),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                      child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Ringkasan Transaksi Terbaru'),
                            const SizedBox(height: 8),
                            Expanded(
                                child: ListView.separated(
                                    itemBuilder: (context, idx) {
                                      final t = s.recentTransactions[idx]
                                          as Map<String, dynamic>;
                                      return ListTile(
                                        title: Text(t['category'] ?? ''),
                                        subtitle: Text(t['description'] ?? ''),
                                        trailing:
                                            Text('Rp ${t['amount'] ?? 0}'),
                                      );
                                    },
                                    separatorBuilder: (_, __) =>
                                        const Divider(),
                                    itemCount: s.recentTransactions.length))
                          ]),
                    ),
                  ))
                ],
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, st) =>
                Center(child: Text('Could not load dashboard: $e'))),
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
