import 'package:go_router/go_router.dart';
// no direct material imports required here
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../screens/splash_screen.dart';
import '../screens/landing_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/signup_screen.dart';
import '../screens/dashboard/dashboard_screen.dart';
import '../screens/transaction/add_transaction_screen.dart';
import '../screens/transaction/transactions_list_screen.dart';
import '../screens/profile/profile_screen.dart';
import '../screens/settings/settings_screen.dart';
import '../screens/analytics/analytics_screen.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(path: '/', builder: (context, state) => const SplashScreen()),
      GoRoute(
          path: '/landing', builder: (context, state) => const LandingScreen()),
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
      GoRoute(
          path: '/signup', builder: (context, state) => const SignupScreen()),
      GoRoute(
          path: '/dashboard',
          builder: (context, state) => const DashboardScreen()),
      GoRoute(
          path: '/transaction/add',
          builder: (context, state) => const AddTransactionScreen()),
      GoRoute(
          path: '/transactions',
          builder: (context, state) => const TransactionsListScreen()),
      GoRoute(
          path: '/profile', builder: (context, state) => const ProfileScreen()),
      GoRoute(
          path: '/settings', builder: (context, state) => const SettingsScreen()),
      GoRoute(
          path: '/analytics',
          builder: (context, state) => const AnalyticsScreen()),
    ],
  );
});
