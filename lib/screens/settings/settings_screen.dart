import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../config/theme.dart';
// import '../../widgets/bottom_nav.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mode = ref.watch(themeNotifierProvider);

    return Scaffold(
      // bottomNavigationBar: const BottomNav(),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => GoRouter.of(context).go('/profile'),
        ),
        title: const Text('Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Preferensi',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),

          // Dark mode
          SwitchListTile(
            value: mode == ThemeMode.dark,
            onChanged: (v) => ref.read(themeNotifierProvider.notifier).state =
                v ? ThemeMode.dark : ThemeMode.light,
            title: const Text('Dark mode'),
            subtitle: const Text('Ubah tampilan terang/gelap'),
          ),

          const Divider(height: 32),

          // Notif preferences (dummy)
          SwitchListTile(
            value: true,
            onChanged: (_) {
              // function belakangan
            },
            title: const Text('Notifikasi transaksi'),
            subtitle: const Text('Aktifkan pengingat transaksi (dummy)'),
          ),

          const Divider(height: 32),

          // Appearance (dummy)
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Appearance'),
            subtitle: const Text('Mode warna / gaya (dummy)'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // function belakangan
            },
          ),

          const Divider(height: 32),

          // Data & Security (dummy)
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.lock_outline),
            title: const Text('Data & keamanan'),
            subtitle: const Text('Ganti password / verifikasi (dummy)'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // function belakangan
            },
          ),

          const SizedBox(height: 24),

          SizedBox(
            height: 48,
            child: FilledButton(
              onPressed: () {
                // function belakangan
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Settings tersimpan (dummy)')),
                );
              },
              child: const Text('Save / Update'),
            ),
          ),
        ],
      ),
    );
  }
}
