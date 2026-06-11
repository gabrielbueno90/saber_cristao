import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saber_cristao/core/app_config.dart';
import 'package:saber_cristao/core/supabase/supabase_client_provider.dart';
import 'package:saber_cristao/features/auth/data/auth_repository.dart';
import 'package:saber_cristao/features/auth/domain/auth_user.dart' as domain;
import 'package:saber_cristao/features/auth/domain/google_sign_in_availability.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseAuthRepository implements AuthRepository {
  SupabaseAuthRepository(this._client);

  final SupabaseClient? _client;

  @override
  bool get isUsingSupabase => true;

  @override
  bool get canUseGoogleSignIn => AppConfig.enableGoogleSignIn && _client != null;

  @override
  Future<GoogleSignInAvailability> diagnoseGoogleSignIn() async {
    final availability = _localGoogleSignInAvailability();
    if (kDebugMode) {
      debugPrint(
        '[SupabaseAuthRepository] canUseGoogleSignIn=$canUseGoogleSignIn '
        'availability=${availability.label}',
      );
    }
    return availability;
  }

  @override
  Stream<domain.AuthUser?> authStateChanges() {
    if (_client == null) return Stream.value(null);
    return _client.auth.onAuthStateChange.map((event) {
      final user = event.session?.user;
      if (user == null) return null;
      return _mapUser(user);
    });
  }

  @override
  Future<domain.AuthUser?> currentUser() async {
    final user = _client?.auth.currentUser;
    return user == null ? null : _mapUser(user);
  }

  @override
  Future<RegisterResult> registerWithEmail({
    required String name,
    required String email,
    required String password,
  }) async {
    if (_client == null) {
      return const RegisterResult(requiresEmailConfirmation: false);
    }
    final response = await _client.auth.signUp(
      email: email,
      password: password,
      data: {'display_name': name},
    );
    final user = response.user;
    return RegisterResult(
      requiresEmailConfirmation: response.session == null && user != null,
      user: user == null ? null : _mapUser(user),
    );
  }

  @override
  Future<bool> sendPasswordReset(
    String email, {
    required String redirectTo,
  }) async {
    if (_client == null) {
      if (kDebugMode) {
        debugPrint(
          '[SupabaseAuthRepository] sendPasswordReset failed: supabaseNotConfigured',
        );
      }
      return false;
    }

    if (kDebugMode) {
      debugPrint(
        '[SupabaseAuthRepository] sendPasswordReset requested',
      );
    }

    try {
      await _client.auth.resetPasswordForEmail(
        email,
        redirectTo: redirectTo,
      );
      if (kDebugMode) {
        debugPrint('[SupabaseAuthRepository] sendPasswordReset result=success');
      }
      return true;
    } catch (error) {
      if (kDebugMode) {
        debugPrint('[SupabaseAuthRepository] sendPasswordReset result=error error=$error');
      }
      rethrow;
    }
  }

  @override
  Future<void> updatePassword(String password) async {
    if (_client == null) return;
    await _client.auth.updateUser(
      UserAttributes(password: password),
    );
  }

  @override
  Future<void> signInWithEmail({
    required String email,
    required String password,
  }) async {
    if (_client == null) return;
    await _client.auth.signInWithPassword(email: email, password: password);
  }

  @override
  Future<void> signOut() async {
    if (_client == null) return;
    await _client.auth.signOut();
  }

  @override
  Future<void> signInWithGoogle() async {
    if (_client == null) {
      if (kDebugMode) {
        debugPrint('[SupabaseAuthRepository] signInWithGoogle failed: supabaseNotConfigured');
      }
      throw Exception('Supabase indisponivel.');
    }
    await _client.auth.signInWithOAuth(
      OAuthProvider.google,
      redirectTo: 'com.sabercristao.app://login-callback/',
    );
  }

  @override
  Future<void> ensureProfile(domain.AuthUser user) async {
    if (_client == null) return;
    await _client.from('profiles').upsert({
      'user_id': user.id,
      'display_name': user.displayName,
      'email': user.email,
      'auth_provider': user.provider,
      'updated_at': DateTime.now().toIso8601String(),
    }, onConflict: 'user_id');
  }

  domain.AuthUser _mapUser(User user) {
    final metadata = user.userMetadata ?? const {};
    final identities = user.identities;
    final provider = identities != null && identities.isNotEmpty
        ? identities.first.provider
        : 'email';

    return domain.AuthUser(
      id: user.id,
      email: user.email ?? '',
      displayName: (metadata['display_name'] as String?) ?? '',
      provider: provider,
    );
  }

  GoogleSignInAvailability _localGoogleSignInAvailability() {
    if (!AppConfig.enableGoogleSignIn) {
      return GoogleSignInAvailability.disabledByFlag;
    }

    if (_client == null || AppConfig.supabaseUrl.isEmpty || AppConfig.supabaseAnonKey.isEmpty) {
      return GoogleSignInAvailability.supabaseNotConfigured;
    }
    return GoogleSignInAvailability.enabled;
  }
}

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final client = ref.watch(supabaseClientProvider);
  if (client == null) {
    return AppConfig.enableMockAuth
        ? MockAuthRepository()
        : const DisabledAuthRepository();
  }
  return SupabaseAuthRepository(client);
});

class MockAuthRepository implements AuthRepository {
  final _controller = StreamController<domain.AuthUser?>.broadcast();
  domain.AuthUser? _user;

  @override
  bool get isUsingSupabase => false;

  @override
  bool get canUseGoogleSignIn => false;

  @override
  Future<GoogleSignInAvailability> diagnoseGoogleSignIn() async =>
      GoogleSignInAvailability.supabaseNotConfigured;

  @override
  Stream<domain.AuthUser?> authStateChanges() => _controller.stream;

  @override
  Future<domain.AuthUser?> currentUser() async => _user;

  @override
  Future<void> ensureProfile(domain.AuthUser user) async {}

  @override
  Future<RegisterResult> registerWithEmail({
    required String name,
    required String email,
    required String password,
  }) async {
    _user = domain.AuthUser(
      id: 'mock-user',
      email: email,
      displayName: name,
      provider: 'email',
    );
    _controller.add(_user);
    return RegisterResult(
      requiresEmailConfirmation: false,
      user: _user,
    );
  }

  @override
  Future<bool> sendPasswordReset(
    String email, {
    required String redirectTo,
  }) async => true;

  @override
  Future<void> updatePassword(String password) async {}

  @override
  Future<void> signInWithEmail({
    required String email,
    required String password,
  }) async {
    _user = domain.AuthUser(
      id: 'mock-user',
      email: email,
      displayName: 'Usuario',
      provider: 'email',
    );
    _controller.add(_user);
  }

  @override
  Future<void> signInWithGoogle() async {
    _user = const domain.AuthUser(
      id: 'mock-google',
      email: 'google@sabercristao.app',
      displayName: 'Usuario Google',
      provider: 'google',
    );
    _controller.add(_user);
  }

  @override
  Future<void> signOut() async {
    _user = null;
    _controller.add(null);
  }
}

class DisabledAuthRepository implements AuthRepository {
  const DisabledAuthRepository();

  @override
  bool get isUsingSupabase => false;

  @override
  bool get canUseGoogleSignIn => false;

  @override
  Future<GoogleSignInAvailability> diagnoseGoogleSignIn() async =>
      GoogleSignInAvailability.supabaseNotConfigured;

  @override
  Stream<domain.AuthUser?> authStateChanges() => Stream<domain.AuthUser?>.empty();

  @override
  Future<domain.AuthUser?> currentUser() async => null;

  @override
  Future<void> ensureProfile(domain.AuthUser user) async {}

  Never _fail() {
    throw Exception('Supabase indisponivel.');
  }

  @override
  Future<RegisterResult> registerWithEmail({
    required String name,
    required String email,
    required String password,
  }) async {
    _fail();
  }

  @override
  Future<bool> sendPasswordReset(
    String email, {
    required String redirectTo,
  }) async {
    _fail();
  }

  @override
  Future<void> updatePassword(String password) async {
    _fail();
  }

  @override
  Future<void> signInWithEmail({
    required String email,
    required String password,
  }) async {
    _fail();
  }

  @override
  Future<void> signOut() async {
    _fail();
  }

  @override
  Future<void> signInWithGoogle() async {
    _fail();
  }
}
