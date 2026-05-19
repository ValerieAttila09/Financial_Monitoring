import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final themeNotifierProvider =
    StateProvider<ThemeMode>((ref) => ThemeMode.light);

final Color primary = const Color(0xFF4F46E5);
final Color secondary = const Color(0xFF06B6D4);

final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  colorScheme: ColorScheme.fromSeed(seedColor: primary),
  useMaterial3: true,
);

final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  colorScheme:
      ColorScheme.fromSeed(seedColor: primary, brightness: Brightness.dark),
  useMaterial3: true,
);
