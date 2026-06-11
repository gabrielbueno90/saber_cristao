import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:saber_cristao/app/theme.dart';
import 'package:saber_cristao/core/constants/app_spacing.dart';
import 'package:saber_cristao/features/auth/presentation/auth_controller.dart';
import 'package:saber_cristao/features/auth/presentation/auth_state.dart';
import 'package:saber_cristao/shared/widgets/app_action_buttons.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
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
    final authState = ref.watch(authControllerProvider);
    final loading = authState.status == AuthStatus.loading;

    return Scaffold(
      appBar: AppBar(title: const Text('Criar conta')),
      body: Container(
        color: AppTheme.backgroundLight,
        child: Form(
          key: _formKey,
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
              TextFormField(
                controller: nameController,
                enabled: !loading,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: _validateName,
                decoration: const InputDecoration(labelText: 'Nome'),
              ),
              AppSpacing.v16,
              TextFormField(
                controller: emailController,
                enabled: !loading,
                keyboardType: TextInputType.emailAddress,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: _validateEmail,
                decoration: const InputDecoration(labelText: 'Email'),
              ),
              AppSpacing.v16,
              TextFormField(
                controller: passwordController,
                enabled: !loading,
                obscureText: true,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: _validatePassword,
                decoration: const InputDecoration(labelText: 'Senha'),
              ),
              AppSpacing.v16,
              TextFormField(
                controller: confirmController,
                enabled: !loading,
                obscureText: true,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: _validateConfirm,
                decoration: const InputDecoration(labelText: 'Confirmar senha'),
              ),
              AppSpacing.v24,
              AppPrimaryButton(
                label: 'Criar conta',
                isLoading: loading,
                onPressed: loading ? null : _submitRegister,
              ),
              AppSpacing.v12,
              AppSecondaryButton(
                label: 'Entrar com Google',
                isLoading: loading,
                onPressed: loading
                    ? null
                    : () => ref
                        .read(authControllerProvider.notifier)
                        .signInWithGoogle(),
              ),
              AppSpacing.v12,
              AppOutlineButton(
                label: 'Já tenho conta',
                onPressed: loading ? null : () => context.go('/login'),
              ),
              AppSpacing.v12,
              if (authState.status == AuthStatus.error)
                Text(
                  authState.errorMessage ?? 'Não foi possível criar sua conta.',
                  style: const TextStyle(color: AppTheme.error),
                ),
            ],
          ),
        ),
      ),
    );
  }

  String? _validateName(String? value) {
    if ((value ?? '').trim().isEmpty) {
      return 'Informe seu nome.';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    final trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty) {
      return 'Informe seu email.';
    }
    final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    if (!emailRegex.hasMatch(trimmed)) {
      return 'Informe um email válido.';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if ((value ?? '').trim().length < 6) {
      return 'A senha deve ter pelo menos 6 caracteres.';
    }
    return null;
  }

  String? _validateConfirm(String? value) {
    if ((value ?? '').trim() != passwordController.text.trim()) {
      return 'As senhas não conferem.';
    }
    return null;
  }

  Future<void> _submitRegister() async {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) return;

    final result = await ref.read(authControllerProvider.notifier).register(
      name: nameController.text.trim(),
      email: emailController.text.trim(),
      password: passwordController.text,
    );
    if (!mounted || result == null) return;

    final authState = ref.read(authControllerProvider);
    if (authState.status == AuthStatus.authenticated) {
      context.go('/home');
      return;
    }

    final message = result.requiresEmailConfirmation
        ? 'Conta criada com sucesso. Confirme seu e-mail antes de entrar.'
        : 'Conta criada com sucesso. Agora você já pode entrar.';

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
    context.go('/login');
  }
}
