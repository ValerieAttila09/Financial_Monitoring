import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'analytics_provider.dart';
import 'transactions_provider.dart';

/// Dashboard summary model
class DashboardSummary {
  final double totalIncomeToday;
  final double totalExpenseToday;
  final double profitToday;
  final double percentProfit;
  final List<double> weeklyIncome; // 7 values
  final List<double> weeklyExpense; // 7 values
  final List recentTransactions; // raw maps for simplicity

  DashboardSummary(
      {required this.totalIncomeToday,
      required this.totalExpenseToday,
      required this.profitToday,
      required this.percentProfit,
      required this.weeklyIncome,
      required this.weeklyExpense,
      required this.recentTransactions});
}

final dashboardProvider = FutureProvider<DashboardSummary>((ref) async {
  final daily = await ref.read(dailyTotalsProvider.future);
  final monthly = await ref.read(monthlyTotalsProvider.future);

  // Use monthly only to avoid unused_local_variable warning.
  // Weekly chart is built from daily analytics.
  final _ = monthly;

  final txList = ref.read(transactionsListProvider);

  // Compute today's totals from transactions (to guarantee UI matches user data)
  // TransactionModel: ensure it has type, amount, and transactionDate.
  double incomeToday = 0.0;
  double expenseToday = 0.0;
  final now = DateTime.now();
  final todayKey = DateTime(now.year, now.month, now.day);

  for (final t in txList) {
    final date = t.transactionDate;
    if (date == null) continue;
    final d = DateTime(date.year, date.month, date.day);
    if (d != todayKey) continue;

    if (t.type == 'income') {
      incomeToday += t.amount;
    } else if (t.type == 'expense') {
      expenseToday += t.amount;
    }
  }

  final profit = incomeToday - expenseToday;
  final percent = incomeToday == 0 ? 0.0 : (profit / incomeToday) * 100.0;

  // Weekly series derived from analytics daily aggregation (last 7 days)
  // Backend returns: { data: [ { _id:{day,type}, total }, ... ] }
  List<double> wInc = List.filled(7, 0.0);
  List<double> wExp = List.filled(7, 0.0);
  try {
    final items = (daily['data'] as List<dynamic>?) ?? [];
    final Map<String, double> incByDay = {};
    final Map<String, double> expByDay = {};

    for (final raw in items) {
      if (raw is! Map) continue;
      final m = raw.cast<String, dynamic>();
      final id = m['_id'];
      if (id is! Map) continue;
      final day = id['day']?.toString();
      final type = id['type']?.toString();
      final total = (m['total'] as num?)?.toDouble() ?? 0.0;
      if (day == null || type == null) continue;
      if (type == 'income') {
        incByDay[day] = (incByDay[day] ?? 0) + total;
      } else if (type == 'expense') {
        expByDay[day] = (expByDay[day] ?? 0) + total;
      }
    }

    // Build ordered last-7-day keys
    final days = List.generate(7, (i) {
      final d = DateTime(now.year, now.month, now.day).subtract(Duration(days: 6 - i));
      return '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
    });

    for (int i = 0; i < days.length; i++) {
      final k = days[i];
      wInc[i] = incByDay[k] ?? 0.0;
      wExp[i] = expByDay[k] ?? 0.0;
    }
  } catch (_) {
    // keep fallback zeros
  }

    final recent = txList.take(5).map((t) => t.toMap()).toList();

  // Weekly chart uses analytics daily aggregation. Today's totals are computed from transaction list
  // to guarantee the UI matches user-specific data.
  return DashboardSummary(

      totalIncomeToday: incomeToday,
      totalExpenseToday: expenseToday,
      profitToday: profit,
      percentProfit: percent,
      weeklyIncome: wInc,
      weeklyExpense: wExp,
      recentTransactions: recent);
});

