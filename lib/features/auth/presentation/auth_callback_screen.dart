import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:saber_cristao/app/theme.dart';
import 'package:saber_cristao/core/constants/app_spacing.dart';
import 'package:saber_cristao/features/auth/data/supabase_auth_repository.dart';
import 'package:saber_cristao/features/auth/presentation/auth_controller.dart';
import 'package:saber_cristao/features/auth/presentation/auth_state.dart';

class AuthCallbackScreen extends ConsumerStatefulWidget {
  const AuthCallbackScreen({super.key});

  @override
  ConsumerState<AuthCallbackScreen> createState() => _AuthCallbackScreenState();
}

class _AuthCallbackScreenState extends ConsumerState<AuthCallbackScreen> {
  bool _handledRedirect = false;
  Timer? _timeoutTimer;
  Timer? _pollTimer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkForSession();
    });
    _pollTimer = Timer.periodic(const Duration(milliseconds: 700), (_) {
      _checkForSession();
    });
    _timeoutTimer = Timer(const Duration(seconds: 12), () {
      _handleTimeout();
    });
  }

  @override
  void dispose() {
    _timeoutTimer?.cancel();
    _pollTimer?.cancel();
    super.dispose();
  }

  Future<void> _checkForSession() async {
    if (!mounted || _handledRedirect) return;
    final repo = ref.read(authRepositoryProvider);
    final user = await repo.currentUser();
    if (!mounted || _handledRedirect || user == null) return;

    await repo.ensureProfile(user);
    if (!mounted || _handledRedirect) return;
    _handledRedirect = true;
    _timeoutTimer?.cancel();
    _pollTimer?.cancel();
    context.go('/home');
  }

  Future<void> _handleTimeout() async {
    if (!mounted || _handledRedirect) return;

    final repo = ref.read(authRepositoryProvider);
    final user = await repo.currentUser();
    if (!mounted || _handledRedirect) return;

    if (user != null) {
      await repo.ensureProfile(user);
      if (!mounted || _handledRedirect) return;
      _handledRedirect = true;
      _pollTimer?.cancel();
      context.go('/home');
      return;
    }

    _handledRedirect = true;
    _pollTimer?.cancel();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'O login com Google demorou mais do que o esperado. Tente novamente ou use email e senha.',
        ),
      ),
    );
    context.go('/login');
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AuthState>(authControllerProvider, (_, next) {
      if (_handledRedirect) return;
      if (next.status == AuthStatus.authenticated &&
          !next.requiresPasswordReset) {
        _handledRedirect = true;
        _timeoutTimer?.cancel();
        _pollTimer?.cancel();
        context.go('/home');
      }
      if (next.status == AuthStatus.error) {
        _handledRedirect = true;
        _timeoutTimer?.cancel();
        _pollTimer?.cancel();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Não foi possível concluir o login com Google. Tente novamente ou use email e senha.',
            ),
          ),
        );
        context.go('/login');
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
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Entrando com Google...',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.textDark,
                    ),
                  ),
                  AppSpacing.v12,
                  const CircularProgressIndicator(
                    color: AppTheme.primaryBrown,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
