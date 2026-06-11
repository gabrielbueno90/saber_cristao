import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:saber_cristao/core/constants/app_spacing.dart';
import 'package:saber_cristao/features/auth/presentation/auth_controller.dart';
import 'package:saber_cristao/shared/widgets/app_action_buttons.dart';

class ChangePasswordScreen extends ConsumerStatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  ConsumerState<ChangePasswordScreen> createState() =>
      _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends ConsumerState<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Alterar senha')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.md),
          children: [
            const Text(
              'Defina uma nova senha',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
            ),
            AppSpacing.v8,
            const Text(
              'Use uma senha nova para continuar acessando sua conta com segurança.',
            ),
            AppSpacing.v24,
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    enabled: !_loading,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: _validatePassword,
                    decoration: const InputDecoration(labelText: 'Nova senha'),
                  ),
                  AppSpacing.v16,
                  TextFormField(
                    controller: _confirmController,
                    obscureText: true,
                    enabled: !_loading,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: _validateConfirm,
                    decoration:
                        const InputDecoration(labelText: 'Confirmar senha'),
                  ),
                ],
              ),
            ),
            AppSpacing.v24,
            AppPrimaryButton(
              label: 'Atualizar senha',
              isLoading: _loading,
              onPressed: _loading ? null : _submit,
            ),
            AppSpacing.v12,
            AppOutlineButton(
              label: 'Voltar para Perfil',
              onPressed: _loading ? null : () => context.go('/profile'),
            ),
          ],
        ),
      ),
    );
  }

  String? _validatePassword(String? value) {
    final password = value?.trim() ?? '';
    if (password.length < 6) {
      return 'A senha deve ter pelo menos 6 caracteres.';
    }
    return null;
  }

  String? _validateConfirm(String? value) {
    final confirm = value?.trim() ?? '';
    if (confirm.length < 6) {
      return 'A senha deve ter pelo menos 6 caracteres.';
    }
    if (confirm != _passwordController.text.trim()) {
      return 'As senhas não conferem.';
    }
    return null;
  }

  Future<void> _submit() async {
    final valid = _formKey.currentState?.validate() ?? false;
    if (!valid) return;
    setState(() => _loading = true);
    try {
      await ref
          .read(authControllerProvider.notifier)
          .updatePassword(_passwordController.text.trim());
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Senha atualizada com sucesso.')),
      );
      context.go('/profile');
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Não foi possível atualizar a senha agora. Tente novamente.'),
        ),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }
}
