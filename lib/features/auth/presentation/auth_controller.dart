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
      state = AuthState(
        status: AuthStatus.unauthenticated,
        isUsingSupabase: repo.isUsingSupabase,
      );
    } else {
      await repo.ensureProfile(user);
      state = AuthState.authenticated(
        user,
        isUsingSupabase: repo.isUsingSupabase,
      );
    }

    _subscription = repo.authStateChanges().listen((event) async {
      if (event == null) {
        state = AuthState(
          status: AuthStatus.unauthenticated,
          isUsingSupabase: repo.isUsingSupabase,
        );
        return;
      }
      await repo.ensureProfile(event);
      state = AuthState.authenticated(
        event,
        isUsingSupabase: repo.isUsingSupabase,
      );
    });
  }

  Future<void> signInWithEmail(String email, String password) async {
    final repo = _ref.read(authRepositoryProvider);
    state = AuthState.loading(isUsingSupabase: repo.isUsingSupabase);
    try {
      await repo.signInWithEmail(email: email, password: password);
    } catch (e) {
      state = AuthState.error(
        'Nao foi possivel entrar. Verifique os dados.',
        isUsingSupabase: repo.isUsingSupabase,
      );
    }
  }

  Future<void> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final repo = _ref.read(authRepositoryProvider);
    state = AuthState.loading(isUsingSupabase: repo.isUsingSupabase);
    try {
      await repo.registerWithEmail(
            name: name,
            email: email,
            password: password,
          );
    } catch (_) {
      state = AuthState.error(
        'Nao foi possivel criar conta agora.',
        isUsingSupabase: repo.isUsingSupabase,
      );
    }
  }

  Future<void> sendPasswordReset(String email) async {
    final repo = _ref.read(authRepositoryProvider);
    try {
      await repo.sendPasswordReset(email);
    } catch (_) {
      state = AuthState.error(
        'Falha ao enviar recuperacao de senha.',
        isUsingSupabase: repo.isUsingSupabase,
      );
    }
  }

  Future<void> signInWithGoogle() async {
    final repo = _ref.read(authRepositoryProvider);
    try {
      await repo.signInWithGoogle();
    } catch (_) {
      state = AuthState.error(
        'Falha no login com Google.',
        isUsingSupabase: repo.isUsingSupabase,
      );
    }
  }

  Future<void> signOut() async {
    final repo = _ref.read(authRepositoryProvider);
    await repo.signOut();
    state = AuthState(
      status: AuthStatus.unauthenticated,
      isUsingSupabase: repo.isUsingSupabase,
    );
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
