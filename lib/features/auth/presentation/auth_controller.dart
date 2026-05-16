import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saber_cristao/features/auth/data/supabase_auth_repository.dart';
import 'package:saber_cristao/features/auth/presentation/auth_state.dart';

class AuthController extends StateNotifier<AuthState> {
  AuthController(this._ref) : super(const AuthState.loading()) {
    _bootstrap();
  }

  final Ref _ref;
  StreamSubscription? _subscription;

  Future<void> _bootstrap() async {
    final repo = _ref.read(authRepositoryProvider);
    final user = await repo.currentUser();
    if (user == null) {
      state = const AuthState.unauthenticated();
    } else {
      await repo.ensureProfile(user);
      state = AuthState.authenticated(user);
    }

    _subscription = repo.authStateChanges().listen((event) async {
      if (event == null) {
        state = const AuthState.unauthenticated();
        return;
      }
      await repo.ensureProfile(event);
      state = AuthState.authenticated(event);
    });
  }

  Future<void> signInWithEmail(String email, String password) async {
    state = const AuthState.loading();
    try {
      await _ref
          .read(authRepositoryProvider)
          .signInWithEmail(email: email, password: password);
    } catch (e) {
      state = AuthState.error('Nao foi possivel entrar. Verifique os dados.');
    }
  }

  Future<void> register({
    required String name,
    required String email,
    required String password,
  }) async {
    state = const AuthState.loading();
    try {
      await _ref.read(authRepositoryProvider).registerWithEmail(
            name: name,
            email: email,
            password: password,
          );
    } catch (_) {
      state = AuthState.error('Nao foi possivel criar conta agora.');
    }
  }

  Future<void> sendPasswordReset(String email) async {
    try {
      await _ref.read(authRepositoryProvider).sendPasswordReset(email);
    } catch (_) {
      state = AuthState.error('Falha ao enviar recuperacao de senha.');
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      await _ref.read(authRepositoryProvider).signInWithGoogle();
    } catch (_) {
      state = AuthState.error('Falha no login com Google.');
    }
  }

  Future<void> signOut() async {
    await _ref.read(authRepositoryProvider).signOut();
    state = const AuthState.unauthenticated();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}

final authControllerProvider =
    StateNotifierProvider<AuthController, AuthState>((ref) {
  return AuthController(ref);
});
