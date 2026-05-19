import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient:
              LinearGradient(colors: [Color(0xFF4F46E5), Color(0xFF06B6D4)]),
        ),
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const FlutterLogo(size: 96),
                const SizedBox(height: 16),
                const Text('Monitoring Keuangan Harian UMKM',
                    style: TextStyle(color: Colors.white, fontSize: 18)),
                const SizedBox(height: 24),
                ElevatedButton(
                    onPressed: () => context.go('/login'),
                    child: const Text('Login')),
                const SizedBox(height: 8),
                OutlinedButton(
                    onPressed: () => context.go('/signup'),
                    child: const Text('Sign Up')),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
