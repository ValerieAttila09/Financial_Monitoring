import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BottomNav extends StatefulWidget {
  final int initialIndex;
  const BottomNav({super.key, this.initialIndex = 0});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  late int _index;

  @override
  void initState() {
    super.initState();
    _index = widget.initialIndex;
  }

  void _onTap(int idx) {
    setState(() => _index = idx);
    switch (idx) {
      case 0:
        GoRouter.of(context).go('/dashboard');
        break;
      case 1:
        GoRouter.of(context).go('/transactions');
        break;
      case 2:
        GoRouter.of(context).go('/analytics');
        break;
      case 3:
        GoRouter.of(context).go('/profile');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: Colors.white.withAlpha(230),
      elevation: 0,
      shape: const CircularNotchedRectangle(),
      notchMargin: 8,
      child: Container(
        height: 72,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.white.withAlpha(230),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withAlpha(10),
                blurRadius: 12,
                offset: const Offset(0, -4))
          ],
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _NavItem(
                icon: Icons.dashboard,
                label: 'Dashboard',
                active: _index == 0,
                onTap: () => _onTap(0)),
            _NavItem(
                icon: Icons.list,
                label: 'Transactions',
                active: _index == 1,
                onTap: () => _onTap(1)),
            const SizedBox(width: 80), // spacing for centered FAB
            _NavItem(
                icon: Icons.pie_chart,
                label: 'Analytics',
                active: _index == 2,
                onTap: () => _onTap(2)),
            _NavItem(
                icon: Icons.person,
                label: 'Profile',
                active: _index == 3,
                onTap: () => _onTap(3)),
          ],
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool active;
  final VoidCallback onTap;
  const _NavItem(
      {required this.icon,
      required this.label,
      required this.active,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    final Color color =
        active ? Theme.of(context).colorScheme.primary : Colors.grey.shade600;
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              padding: EdgeInsets.all(active ? 8 : 4),
              decoration: BoxDecoration(
                  color: active
                      ? color.withAlpha((0.12 * 255).toInt())
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                  border: active ? Border.all(color: color, width: 1.2) : null,
                  boxShadow: active
                      ? [
                          BoxShadow(
                              color: color.withAlpha(30),
                              blurRadius: 6,
                              offset: const Offset(0, 3))
                        ]
                      : null),
              child: Icon(icon, color: color, size: active ? 26 : 22)),
          const SizedBox(height: 4),
          Text(label, style: TextStyle(fontSize: 11, color: color))
        ]),
      ),
    );
  }
}
