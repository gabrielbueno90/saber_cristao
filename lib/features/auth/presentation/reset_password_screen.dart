import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:saber_cristao/app/theme.dart';
import 'package:saber_cristao/core/constants/app_spacing.dart';
import 'package:saber_cristao/features/auth/presentation/auth_controller.dart';
import 'package:saber_cristao/shared/widgets/app_action_buttons.dart';

class ResetPasswordScreen extends ConsumerStatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  ConsumerState<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends ConsumerState<ResetPasswordScreen> {
  final passwordController = TextEditingController();
  final confirmController = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    passwordController.dispose();
    confirmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Redefinir senha')),
      body: Container(
        color: AppTheme.backgroundLight,
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.md),
          children: [
            const Text(
              'Crie uma nova senha',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
            ),
            AppSpacing.v8,
            const Text(
              'Escolha uma senha nova para continuar usando o Saber Cristão.',
            ),
            AppSpacing.v24,
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Nova senha'),
            ),
            AppSpacing.v16,
            TextField(
              controller: confirmController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Confirmar senha'),
            ),
            AppSpacing.v24,
            AppPrimaryButton(
              label: 'Atualizar senha',
              isLoading: _loading,
              onPressed: () async {
                if (passwordController.text.trim().length < 6) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Use uma senha com pelo menos 6 caracteres.'),
                    ),
                  );
                  return;
                }
                if (passwordController.text != confirmController.text) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('As senhas nao conferem.')),
                  );
                  return;
                }
                setState(() => _loading = true);
                try {
                  await ref
                      .read(authControllerProvider.notifier)
                      .updatePassword(passwordController.text.trim());
                  await ref.read(authControllerProvider.notifier).signOut();
                  if (!context.mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Sua senha foi atualizada com sucesso. Faça login novamente.',
                      ),
                    ),
                  );
                  context.go('/login');
                } catch (_) {
                  if (!context.mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Nao foi possivel atualizar a senha agora. Tente novamente em instantes.',
                      ),
                    ),
                  );
                } finally {
                  if (mounted) setState(() => _loading = false);
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
    );
  }
}
