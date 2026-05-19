import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/auth_provider.dart';
import '../../routes/app_router.dart';

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _businessCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _pwCtrl = TextEditingController();
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign Up')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(children: [
            TextFormField(
                controller: _nameCtrl,
                decoration: const InputDecoration(labelText: 'Full name')),
            TextFormField(
                controller: _businessCtrl,
                decoration: const InputDecoration(labelText: 'Business name')),
            TextFormField(
                controller: _emailCtrl,
                decoration: const InputDecoration(labelText: 'Email')),
            TextFormField(
                controller: _pwCtrl,
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true),
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
                        await ref.read(authProvider.notifier).register(
                            _nameCtrl.text.trim(),
                            _businessCtrl.text.trim(),
                            _emailCtrl.text.trim(),
                            _pwCtrl.text);
                        if (!mounted) return;
                        ref.read(appRouterProvider).go('/dashboard');
                      } catch (e) {
                        messenger.showSnackBar(
                            SnackBar(content: Text('Register failed: $e')));
                      } finally {
                        setState(() {
                          _loading = false;
                        });
                      }
                    },
                    child: const Text('Sign Up'),
                  ),
          ]),
        ),
      ),
    );
  }
}
