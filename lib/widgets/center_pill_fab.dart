import 'package:flutter/material.dart';

class CenterPillFab extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData icon;
  final String? label;
  const CenterPillFab(
      {super.key, required this.onPressed, this.icon = Icons.add, this.label});

  @override
  Widget build(BuildContext context) {
    final colors = [
      Theme.of(context).colorScheme.primary,
      Theme.of(context).colorScheme.secondary
    ];
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(30),
          child: Container(
            height: 56,
            constraints: const BoxConstraints(minWidth: 56),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: colors),
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withAlpha((0.18 * 255).toInt()),
                    blurRadius: 12,
                    offset: const Offset(0, 6)),
              ],
            ),
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              Icon(icon, color: Colors.white, size: 26),
              if (label != null) ...[
                const SizedBox(width: 8),
                Text(label!,
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w600)),
              ]
            ]),
          ),
        ),
      ),
    );
  }
}
