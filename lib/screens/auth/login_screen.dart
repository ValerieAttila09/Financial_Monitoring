import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/auth_provider.dart';
import '../../routes/app_router.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _pwCtrl = TextEditingController();
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(children: [
            TextFormField(
                controller: _emailCtrl,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (v) =>
                    v != null && v.contains('@') ? null : 'Invalid email'),
            TextFormField(
                controller: _pwCtrl,
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (v) =>
                    v != null && v.length >= 8 ? null : 'Min 8 chars'),
            const SizedBox(height: 16),
            _loading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: () async {
                      if (!_formKey.currentState!.validate()) return;
                      setState(() {
                        _loading = true;
                      });
                      final messenger = ScaffoldMessenger.of(context);
                      try {
                        await ref
                            .read(authProvider.notifier)
                            .login(_emailCtrl.text.trim(), _pwCtrl.text);
                        // on success go to dashboard
                        if (!mounted) return;
                        // navigate using the app router provider to avoid context after async gaps
                        ref.read(appRouterProvider).go('/dashboard');
                      } catch (e) {
                        messenger.showSnackBar(
                            SnackBar(content: Text('Login failed: $e')));
                      } finally {
                        setState(() {
                          _loading = false;
                        });
                      }
                    },
                    child: const Text('Login'),
                  ),
          ]),
        ),
      ),
    );
  }
}
