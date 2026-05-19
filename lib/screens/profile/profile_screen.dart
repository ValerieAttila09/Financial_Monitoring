import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../config/theme.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mode = ref.watch(themeNotifierProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('Nama: -'),
          const SizedBox(height: 8),
          const Text('Nama usaha: -'),
          const SizedBox(height: 8),
          const Text('Email: -'),
          const SizedBox(height: 16),
          Row(children: [
            const Text('Dark mode'),
            const Spacer(),
            Switch(
                value: mode == ThemeMode.dark,
                onChanged: (v) => ref
                    .read(themeNotifierProvider.notifier)
                    .state = v ? ThemeMode.dark : ThemeMode.light)
          ])
        ]),
      ),
    );
  }
}
