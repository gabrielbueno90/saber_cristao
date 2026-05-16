import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:saber_cristao/app/theme.dart';
import 'package:saber_cristao/core/constants/app_spacing.dart';
import 'package:saber_cristao/features/auth/presentation/auth_controller.dart';
import 'package:saber_cristao/features/auth/presentation/auth_state.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);
    final loading = authState.status == AuthStatus.loading;

    ref.listen<AuthState>(authControllerProvider, (_, next) {
      if (next.status == AuthStatus.authenticated) {
        context.go('/home');
      }
    });

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [AppTheme.backgroundLight, AppTheme.parchment],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Saber Cristão',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.textDark,
                      ),
                    ),
                    AppSpacing.v8,
                    const Text(
                      'Aprenda a Bíblia jogando, avance por desafios e fortaleça sua fé.',
                      textAlign: TextAlign.center,
                    ),
                    AppSpacing.v24,
                    TextField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(labelText: 'Email'),
                    ),
                    AppSpacing.v12,
                    TextField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(labelText: 'Senha'),
                    ),
                    AppSpacing.v16,
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: loading
                            ? null
                            : () => ref
                                .read(authControllerProvider.notifier)
                                .signInWithEmail(
                                  emailController.text.trim(),
                                  passwordController.text.trim(),
                                ),
                        child: const Text('Entrar'),
                      ),
                    ),
                    AppSpacing.v12,
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: loading
                            ? null
                            : () => ref
                                .read(authControllerProvider.notifier)
                                .signInWithGoogle(),
                        child: const Text('Entrar com Google'),
                      ),
                    ),
                    AppSpacing.v12,
                    TextButton(
                      onPressed: () => context.push('/register'),
                      child: const Text('Criar conta'),
                    ),
                    AppSpacing.v8,
                    TextButton(
                      onPressed: () => context.push('/forgot-password'),
                      child: const Text('Esqueci minha senha'),
                    ),
                    AppSpacing.v12,
                    if (authState.status == AuthStatus.error)
                      Text(
                        authState.errorMessage ?? 'Erro de autenticacao',
                        style: const TextStyle(color: AppTheme.error),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
