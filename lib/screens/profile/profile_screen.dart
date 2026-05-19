import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:upsm_flutter/widgets/bottom_nav.dart';

import '../../config/theme.dart';
import '../../providers/profile_provider.dart';
import '../../widgets/glass_card.dart';
class ProfileScreen extends ConsumerWidget {

  const ProfileScreen({super.key});


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // (mode currently not used, but keeping to match existing theme usage)
    final mode = ref.watch(themeNotifierProvider);


    final profileAsync = ref.watch(profileProvider);

    return Scaffold(
      // bottomNavigationBar: const BottomNav(),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
onPressed: () => GoRouter.of(context).go('/dashboard'),
            ),
            expandedHeight: 150,
            flexibleSpace: FlexibleSpaceBar(
              title: const Text('Profile'),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Theme.of(context).colorScheme.primary.withOpacity(0.25),
                      Theme.of(context).colorScheme.secondary.withOpacity(0.18),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16.0),
            sliver: SliverList(
              delegate: SliverChildListDelegate(
                [
                  profileAsync.when(
                    loading: () => const SizedBox.shrink(),
                    error: (e, st) => const SizedBox.shrink(),
                    data: (u) {
                      return Row(
                        children: [
                          CircleAvatar(
                            radius: 34,
                            backgroundColor:
                                Theme.of(context).colorScheme.primary.withOpacity(0.15),
                            child: Icon(Icons.person,
                                color: Theme.of(context).colorScheme.primary),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  u.fullname,
                                  style: Theme.of(context).textTheme.titleLarge,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  u.businessName.isEmpty ? 'Nama usaha' : u.businessName,
                                  style: Theme.of(context).textTheme.bodyMedium,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  u.email,
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  // Glass-like card for data
                  GlassCard(
                    child: Padding(
                      padding: const EdgeInsets.all(14.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Account Info',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 12),
                          _InfoRow(
                            icon: Icons.badge,
                            label: 'Nama',
                            value: profileAsync.maybeWhen(
                              data: (u) => u.fullname,
                              orElse: () => '...',
                            ),
                          ),
                          _InfoRow(
                            icon: Icons.store,
                            label: 'Nama usaha',
                            value: profileAsync.maybeWhen(
                              data: (u) => u.businessName,
                              orElse: () => '...',
                            ),
                          ),
                          _InfoRow(
                            icon: Icons.email_outlined,
                            label: 'Email',
                            value: profileAsync.maybeWhen(
                              data: (u) => u.email,
                              orElse: () => '...',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 48,
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14)),
                        side: BorderSide(
                            color: Theme.of(context)
                                .colorScheme
                                .outline
                                .withOpacity(0.35)),
                      ),
                      onPressed: () => GoRouter.of(context).go('/settings'),
                      icon: const Icon(Icons.settings_outlined),
                      label: const Text('Settings'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(fontWeight: FontWeight.w600)),
                const SizedBox(height: 3),
                Text(value,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyMedium),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

