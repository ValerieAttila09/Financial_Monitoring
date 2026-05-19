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

  String? _nameError;
  String? _businessError;
  String? _emailError;
  String? _passwordError;

  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign Up')),
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
                              child: const Icon(Icons.person_add_outlined),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Create your account',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge
                                        ?.copyWith(fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Start monitoring your transactions',
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
                          controller: _nameCtrl,
                          decoration: InputDecoration(
                            labelText: 'Full name',
                            errorText: _nameError,
                          ),
                        ),
                        TextFormField(
                          controller: _businessCtrl,
                          decoration: InputDecoration(
                            labelText: 'Business name',
                            errorText: _businessError,
                          ),
                        ),
                        TextFormField(
                          controller: _emailCtrl,
                          decoration: InputDecoration(
                            labelText: 'Email',
                            errorText: _emailError,
                          ),
                        ),
                        TextFormField(
                          controller: _pwCtrl,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            errorText: _passwordError,
                          ),
                          obscureText: true,
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
                                    if (!_formKey.currentState!.validate()) {
                                      return;
                                    }

                                    setState(() {
                                      _loading = true;
                                    });

                                    final messenger =
                                        ScaffoldMessenger.of(context);

                                    try {
                                      setState(() {
                                        _nameError = null;
                                        _businessError = null;
                                        _emailError = null;
                                        _passwordError = null;
                                      });

                                      await ref
                                          .read(authProvider.notifier)
                                          .register(
                                            _nameCtrl.text.trim(),
                                            _businessCtrl.text.trim(),
                                            _emailCtrl.text.trim(),
                                            _pwCtrl.text,
                                          );

                                      if (!mounted) return;
                                      ref.read(appRouterProvider).go('/dashboard');
                                    } catch (e) {
                                      final msg = e.toString();

                                      if (msg.contains('Validation failed')) {
                                        final parts = msg.split(':');
                                        if (parts.length > 1) {
                                          final detail =
                                              parts.sublist(1).join(':').trim();
                                          final items = detail
                                              .split(';')
                                              .map((s) => s.trim());

                                          for (final it in items) {
                                            final lower = it.toLowerCase();
                                            if (lower.contains('email')) {
                                              _emailError = it;
                                            } else if (lower.contains('password')) {
                                              _passwordError = it;
                                            } else if (lower.contains('name') ||
                                                lower.contains('fullname')) {
                                              _nameError = it;
                                            } else if (lower.contains('business')) {
                                              _businessError = it;
                                            }
                                          }
                                          setState(() {});
                                        } else {
                                          messenger.showSnackBar(
                                            SnackBar(
                                                content: Text(
                                                    'Register failed: $e')),
                                          );
                                        }
                                      } else {
                                        messenger.showSnackBar(
                                          SnackBar(
                                              content: Text('Register failed: $e')),
                                        );
                                      }
                                    } finally {
                                      setState(() {
                                        _loading = false;
                                      });
                                    }
                                  },
                                  child: const Text('Sign Up'),
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

  @override
  void dispose() {
    _nameCtrl.dispose();
    _businessCtrl.dispose();
    _emailCtrl.dispose();
    _pwCtrl.dispose();
    super.dispose();
  }
}

