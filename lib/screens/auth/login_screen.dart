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
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Material(
                elevation: 8,
                borderRadius: BorderRadius.circular(18),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: 46,
                              height: 46,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                color: Theme.of(context)
                                    .colorScheme
                                    .primary
                                    .withOpacity(0.12),
                                border: Border.all(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .primary
                                      .withOpacity(0.25),
                                ),
                              ),
                              child: Icon(Icons.lock_outline,
                                  color: Theme.of(context).colorScheme.primary),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Welcome back',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge
                                        ?.copyWith(fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Login to access your dashboard',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSurface
                                              .withOpacity(0.7),
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _emailCtrl,
                          decoration: const InputDecoration(labelText: 'Email'),
                          validator: (v) => v != null && v.contains('@')
                              ? null
                              : 'Invalid email',
                        ),
                        TextFormField(
                          controller: _pwCtrl,
                          decoration: const InputDecoration(labelText: 'Password'),
                          obscureText: true,
                          validator: (v) => v != null && v.length >= 8
                              ? null
                              : 'Min 8 chars',
                        ),
                        const SizedBox(height: 16),
                        _loading
                            ? const SizedBox(
                                height: 44,
                                child: Center(
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                ),
                              )
                            : SizedBox(
                                height: 48,
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () async {
                                    if (!_formKey.currentState!.validate()) return;
                                    setState(() {
                                      _loading = true;
                                    });
                                    final messenger =
                                        ScaffoldMessenger.of(context);
                                    try {
                                      await ref
                                          .read(authProvider.notifier)
                                          .login(_emailCtrl.text.trim(),
                                              _pwCtrl.text);
                                      if (!mounted) return;
                                      ref.read(appRouterProvider).go('/dashboard');
                                    } catch (e) {
                                      messenger.showSnackBar(
                                        SnackBar(content: Text('Login failed: $e')),
                                      );
                                    } finally {
                                      setState(() {
                                        _loading = false;
                                      });
                                    }
                                  },
                                  child: const Text('Login'),
                                ),
                              ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

