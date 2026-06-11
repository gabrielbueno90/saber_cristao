import 'dart:io';
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saber_cristao/core/supabase/supabase_client_provider.dart';
import 'package:saber_cristao/features/auth/data/auth_repository.dart';
import 'package:saber_cristao/features/auth/data/supabase_auth_repository.dart';
import 'package:saber_cristao/features/auth/presentation/auth_state.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

class AuthController extends StateNotifier<AuthState> {
  AuthController(this._ref) : super(const AuthState.loading()) {
    _bootstrap();
  }

  final Ref _ref;
  StreamSubscription? _subscription;
  StreamSubscription<supabase.AuthState>? _recoverySubscription;

  Future<void> _bootstrap() async {
    final repo = _ref.read(authRepositoryProvider);
    final client = _ref.read(supabaseClientProvider);
    if (kDebugMode) {
      debugPrint(
        '[AuthController] bootstrap isUsingSupabase=${repo.isUsingSupabase} '
        'canUseGoogleSignIn=${repo.canUseGoogleSignIn}',
      );
    }
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
        requiresPasswordReset: state.requiresPasswordReset,
      );
    });

    if (client != null) {
      _recoverySubscription = client.auth.onAuthStateChange.listen((event) async {
        if (event.event != supabase.AuthChangeEvent.passwordRecovery) return;
        final user = event.session?.user;
        if (user == null) return;
        final mappedUser = await repo.currentUser();
        if (mappedUser == null) return;
        state = AuthState.authenticated(
          mappedUser,
          isUsingSupabase: repo.isUsingSupabase,
          requiresPasswordReset: true,
        );
      });
    }
  }

  Future<void> signInWithEmail(String email, String password) async {
    final repo = _ref.read(authRepositoryProvider);
    final normalizedEmail = email.trim();
    final normalizedPassword = password;

    if (normalizedEmail.isEmpty) {
      state = AuthState.error(
        'Informe seu email.',
        isUsingSupabase: repo.isUsingSupabase,
        requiresPasswordReset: state.requiresPasswordReset,
      );
      return;
    }
    if (!_isValidEmail(normalizedEmail)) {
      state = AuthState.error(
        'Informe um email válido.',
        isUsingSupabase: repo.isUsingSupabase,
        requiresPasswordReset: state.requiresPasswordReset,
      );
      return;
    }
    if (normalizedPassword.isEmpty) {
      state = AuthState.error(
        'Informe sua senha.',
        isUsingSupabase: repo.isUsingSupabase,
        requiresPasswordReset: state.requiresPasswordReset,
      );
      return;
    }

    state = AuthState.loading(
      isUsingSupabase: repo.isUsingSupabase,
      requiresPasswordReset: state.requiresPasswordReset,
    );
    try {
      await repo.signInWithEmail(
        email: normalizedEmail,
        password: normalizedPassword,
      );
      final user = await repo.currentUser();
      if (user == null) {
        state = AuthState.error(
          'Email ou senha inválidos.',
          isUsingSupabase: repo.isUsingSupabase,
          requiresPasswordReset: state.requiresPasswordReset,
        );
        return;
      }
      await repo.ensureProfile(user);
      state = AuthState.authenticated(
        user,
        isUsingSupabase: repo.isUsingSupabase,
        requiresPasswordReset: false,
      );
    } on SocketException {
      state = AuthState.error(
        'Não foi possível conectar agora. Tente novamente.',
        isUsingSupabase: repo.isUsingSupabase,
        requiresPasswordReset: state.requiresPasswordReset,
      );
    } catch (error) {
      state = AuthState.error(
        _friendlyLoginError(error),
        isUsingSupabase: repo.isUsingSupabase,
        requiresPasswordReset: state.requiresPasswordReset,
      );
    }
  }

  Future<RegisterResult?> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final repo = _ref.read(authRepositoryProvider);
    final normalizedName = name.trim();
    final normalizedEmail = email.trim();

    if (normalizedName.isEmpty) {
      state = AuthState.error(
        'Informe seu nome.',
        isUsingSupabase: repo.isUsingSupabase,
      );
      return null;
    }
    if (!_isValidEmail(normalizedEmail)) {
      state = AuthState.error(
        'Informe um email válido.',
        isUsingSupabase: repo.isUsingSupabase,
      );
      return null;
    }
    if (password.trim().length < 6) {
      state = AuthState.error(
        'A senha deve ter pelo menos 6 caracteres.',
        isUsingSupabase: repo.isUsingSupabase,
      );
      return null;
    }

    state = AuthState.loading(isUsingSupabase: repo.isUsingSupabase);
    try {
      final result = await repo.registerWithEmail(
        name: normalizedName,
        email: normalizedEmail,
        password: password,
      );
      final currentUser = await repo.currentUser();
      if (currentUser != null) {
        await repo.ensureProfile(currentUser);
        state = AuthState.authenticated(
          currentUser,
          isUsingSupabase: repo.isUsingSupabase,
        );
      } else {
        state = AuthState(
          status: AuthStatus.unauthenticated,
          isUsingSupabase: repo.isUsingSupabase,
        );
      }
      return result;
    } catch (error) {
      state = AuthState.error(
        _friendlyRegisterError(error),
        isUsingSupabase: repo.isUsingSupabase,
      );
      return null;
    }
  }

  Future<bool> sendPasswordReset(String email, {required String redirectTo}) async {
    final repo = _ref.read(authRepositoryProvider);
    try {
      if (kDebugMode) {
        debugPrint(
          '[AuthController] sendPasswordReset requested '
          'isUsingSupabase=${repo.isUsingSupabase}',
        );
      }
      final sent = await repo.sendPasswordReset(email, redirectTo: redirectTo);
      if (kDebugMode) {
        debugPrint('[AuthController] sendPasswordReset result=$sent');
      }
      if (!sent) {
        state = AuthState.error(
          'Não foi possível enviar o link agora. Tente novamente em instantes.',
          isUsingSupabase: repo.isUsingSupabase,
          requiresPasswordReset: state.requiresPasswordReset,
        );
      }
      return sent;
    } catch (error) {
      if (kDebugMode) {
        debugPrint('[AuthController] sendPasswordReset result=error error=$error');
      }
      state = AuthState.error(
        'Não foi possível enviar o link agora. Tente novamente em instantes.',
        isUsingSupabase: repo.isUsingSupabase,
        requiresPasswordReset: state.requiresPasswordReset,
      );
      return false;
    }
  }

  Future<void> updatePassword(String password) async {
    final repo = _ref.read(authRepositoryProvider);
    try {
      await repo.updatePassword(password);
    } catch (_) {
      state = AuthState.error(
        'Nao foi possivel atualizar a senha agora.',
        isUsingSupabase: repo.isUsingSupabase,
        requiresPasswordReset: state.requiresPasswordReset,
      );
      rethrow;
    }
  }

  Future<void> signInWithGoogle() async {
    final repo = _ref.read(authRepositoryProvider);
    if (!repo.canUseGoogleSignIn) {
      state = AuthState.error(
        'Login com Google ainda nao esta disponivel. Use email e senha por enquanto.',
        isUsingSupabase: repo.isUsingSupabase,
        requiresPasswordReset: state.requiresPasswordReset,
      );
      return;
    }
    if (kDebugMode) {
      debugPrint('[AuthController] signInWithGoogle start');
    }
    try {
      await repo.signInWithGoogle();
    } catch (error) {
      state = AuthState.error(
        'Nao foi possivel concluir o login com Google. Tente novamente ou use email e senha.',
        isUsingSupabase: repo.isUsingSupabase,
        requiresPasswordReset: state.requiresPasswordReset,
      );
    }
  }

  bool _isValidEmail(String email) {
    final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    return emailRegex.hasMatch(email);
  }

  String _friendlyLoginError(Object error) {
    final message = error.toString().toLowerCase();
    if (message.contains('email not confirmed')) {
      return 'Seu e-mail ainda não foi confirmado. Confira sua caixa de entrada.';
    }
    if (message.contains('invalid login credentials')) {
      return 'Email ou senha inválidos.';
    }
    if (message.contains('supabase indisponivel') ||
        message.contains('not configured') ||
        message.contains('mock auth disabled')) {
      return 'Não foi possível conectar agora. Tente novamente.';
    }
    if (message.contains('failed host lookup') ||
        message.contains('socketexception') ||
        message.contains('connection refused') ||
        message.contains('timed out') ||
        message.contains('timeout')) {
      return 'Não foi possível conectar agora. Tente novamente.';
    }
    if (message.contains('authexception') || message.contains('exception')) {
      return 'Email ou senha inválidos.';
    }
    return 'Não foi possível entrar. Verifique os dados.';
  }

  String _friendlyRegisterError(Object error) {
    final message = error.toString().toLowerCase();
    if (message.contains('user already registered') ||
        message.contains('already registered') ||
        message.contains('already been registered')) {
      return 'Este e-mail já está vinculado a uma conta. Entre com Google e crie uma senha pelo perfil, ou use a recuperação de senha.';
    }
    if (message.contains('password')) {
      return 'A senha informada não atende aos requisitos mínimos.';
    }
    if (message.contains('email')) {
      return 'Revise o e-mail informado e tente novamente.';
    }
    return 'Não foi possível criar sua conta agora.';
  }

  void clearPasswordRecovery() {
    final currentUser = state.user;
    if (currentUser == null) {
      state = AuthState(
        status: AuthStatus.unauthenticated,
        isUsingSupabase: state.isUsingSupabase,
      );
      return;
    }
    state = AuthState.authenticated(
      currentUser,
      isUsingSupabase: state.isUsingSupabase,
      requiresPasswordReset: false,
    );
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
    _recoverySubscription?.cancel();
    super.dispose();
  }
}

final authControllerProvider =
    StateNotifierProvider<AuthController, AuthState>((ref) {
  return AuthController(ref);
});
