import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'routes/app_router.dart';
import 'config/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: UpsmApp()));
}

class UpsmApp extends ConsumerWidget {
  const UpsmApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    final theme = ref.watch(themeNotifierProvider);
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'UPSM - Monitoring Keuangan UMKM',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: theme,
      routerConfig: router,
    );
  }
}
