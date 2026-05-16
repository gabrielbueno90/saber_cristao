import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:saber_cristao/app/theme.dart';
import 'package:saber_cristao/core/constants/app_spacing.dart';
import 'package:saber_cristao/features/auth/presentation/auth_controller.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Criar conta')),
      body: Container(
        color: AppTheme.backgroundLight,
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.md),
          children: [
            const Text(
              'Criar conta',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
            ),
            AppSpacing.v8,
            const Text('Entre para salvar seu progresso e avançar nas fases.'),
            AppSpacing.v24,
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Nome'),
            ),
            AppSpacing.v16,
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            AppSpacing.v16,
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Senha'),
            ),
            AppSpacing.v16,
            TextField(
              controller: confirmController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Confirmar senha'),
            ),
            AppSpacing.v24,
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  if (passwordController.text != confirmController.text) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Senhas nao conferem')),
                    );
                    return;
                  }
                  await ref.read(authControllerProvider.notifier).register(
                        name: nameController.text.trim(),
                        email: emailController.text.trim(),
                        password: passwordController.text.trim(),
                      );
                  if (context.mounted) context.go('/home');
                },
                child: const Text('Criar conta'),
              ),
            ),
            AppSpacing.v12,
            OutlinedButton(
              onPressed: () => ref.read(authControllerProvider.notifier).signInWithGoogle(),
              child: const Text('Entrar com Google'),
            ),
            AppSpacing.v12,
            TextButton(
              onPressed: () => context.go('/login'),
              child: const Text('Já tenho conta'),
            ),
          ],
        ),
      ),
    );
  }
}
