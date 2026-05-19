import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:math';
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
  final txList = ref.read(transactionsListProvider);

  // For now assume daily['income'] and daily['expense'] exist (backend should provide),
  final incomeToday = (daily['income'] ?? 0).toDouble();
  final expenseToday = (daily['expense'] ?? 0).toDouble();
  final profit = incomeToday - expenseToday;
  final percent = incomeToday == 0 ? 0.0 : (profit / incomeToday) * 100.0;

  // Build simple weekly series by looking at monthly data if available (fallback random)
  List<double> wInc = List.filled(7, 0.0);
  List<double> wExp = List.filled(7, 0.0);
  if (monthly['weekly'] != null && monthly['weekly'] is List) {
    final list = monthly['weekly'] as List<dynamic>;
    for (int i = 0; i < min(7, list.length); i++) {
      final item = list[i] as Map<String, dynamic>;
      wInc[i] = (item['income'] ?? 0).toDouble();
      wExp[i] = (item['expense'] ?? 0).toDouble();
    }
  }

  final recent = txList.take(5).map((t) => t.toMap()).toList();

  return DashboardSummary(
      totalIncomeToday: incomeToday,
      totalExpenseToday: expenseToday,
      profitToday: profit,
      percentProfit: percent,
      weeklyIncome: wInc,
      weeklyExpense: wExp,
      recentTransactions: recent);
});
