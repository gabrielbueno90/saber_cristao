import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
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
    final availability = await _googleSignInAvailability();
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
  Future<void> registerWithEmail({
    required String name,
    required String email,
    required String password,
  }) async {
    if (_client == null) return;
    await _client.auth.signUp(
      email: email,
      password: password,
      data: {'display_name': name},
    );
  }

  @override
  Future<void> sendPasswordReset(
    String email, {
    required String redirectTo,
  }) async {
    if (_client == null) return;
    await _client.auth.resetPasswordForEmail(
      email,
      redirectTo: redirectTo,
    );
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
    final availability = await _googleSignInAvailability();
    if (kDebugMode) {
      debugPrint(
        '[SupabaseAuthRepository] signInWithGoogle availability=${availability.label}',
      );
    }
    if (availability != GoogleSignInAvailability.enabled) {
      throw Exception('Google provider disabled');
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

  Future<GoogleSignInAvailability> _googleSignInAvailability() async {
    if (!AppConfig.enableGoogleSignIn) {
      return GoogleSignInAvailability.disabledByFlag;
    }

    if (_client == null || AppConfig.supabaseUrl.isEmpty || AppConfig.supabaseAnonKey.isEmpty) {
      return GoogleSignInAvailability.supabaseNotConfigured;
    }

    final uri = Uri.parse('${AppConfig.supabaseUrl}/auth/v1/settings');
    if (kDebugMode) {
      debugPrint('[SupabaseAuthRepository] GET /auth/v1/settings => $uri');
    }

    try {
      final response = await http.get(
        uri,
        headers: <String, String>{
          'apikey': AppConfig.supabaseAnonKey,
          'Authorization': 'Bearer ${AppConfig.supabaseAnonKey}',
        },
      );

      if (kDebugMode) {
        debugPrint(
          '[SupabaseAuthRepository] /auth/v1/settings status=${response.statusCode}',
        );
      }

      if (response.statusCode < 200 || response.statusCode >= 300) {
        return GoogleSignInAvailability.settingsRequestFailed;
      }

      final dynamic parsed = jsonDecode(response.body);
      if (parsed is! Map<String, dynamic>) {
        return GoogleSignInAvailability.settingsRequestFailed;
      }
      final dynamic external = parsed['external'];
      if (external is! Map<String, dynamic>) {
        return GoogleSignInAvailability.settingsRequestFailed;
      }
      final dynamic google = external['google'];
      final enabled = google == true;
      if (kDebugMode) {
        debugPrint(
          '[SupabaseAuthRepository] provider google enabled=$enabled',
        );
      }
      return enabled
          ? GoogleSignInAvailability.enabled
          : GoogleSignInAvailability.providerDisabled;
    } catch (error) {
      if (kDebugMode) {
        debugPrint(
          '[SupabaseAuthRepository] /auth/v1/settings failed: $error',
        );
      }
      return GoogleSignInAvailability.settingsRequestFailed;
    }
  }
}

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final client = ref.watch(supabaseClientProvider);
  if (client == null) return MockAuthRepository();
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
  Future<void> registerWithEmail({
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
  }

  @override
  Future<void> sendPasswordReset(
    String email, {
    required String redirectTo,
  }) async {}

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
