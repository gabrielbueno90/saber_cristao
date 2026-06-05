import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:saber_cristao/app/theme.dart';
import 'package:saber_cristao/core/constants/app_spacing.dart';
import 'package:saber_cristao/features/auth/presentation/auth_controller.dart';
import 'package:saber_cristao/shared/widgets/app_action_buttons.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final emailController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Recuperar senha')),
      body: Container(
        color: AppTheme.backgroundLight,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
            const Text(
              'Recupere sua senha',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
            ),
            AppSpacing.v8,
            const Text(
              'Informe seu email para receber o link de recuperação.',
            ),
            AppSpacing.v24,
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            AppSpacing.v24,
            AppPrimaryButton(
              label: 'Enviar link',
              onPressed: () async {
                await ref
                    .read(authControllerProvider.notifier)
                    .sendPasswordReset(
                      emailController.text.trim(),
                      redirectTo: 'com.sabercristao.app://reset-password/',
                    );
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Enviamos um link de recuperação para o seu email.',
                      ),
                    ),
                  );
                }
              },
            ),
            AppSpacing.v16,
            AppOutlineButton(
              label: 'Voltar para Login',
              onPressed: () => context.go('/login'),
            ),
            ],
          ),
        ),
      ),
    );
  }
}
