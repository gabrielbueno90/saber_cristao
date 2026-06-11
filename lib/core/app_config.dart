import 'package:flutter/foundation.dart';

// Configuracao global do app
class AppConfig {
  static const String supabaseUrl =
      String.fromEnvironment('SUPABASE_URL', defaultValue: '');
  static const String supabaseAnonKey =
      String.fromEnvironment('SUPABASE_ANON_KEY', defaultValue: '');

  static const bool showDevBadges =
      bool.fromEnvironment('SHOW_DEV_BADGES', defaultValue: false);

  static const bool enableGoogleSignIn =
      bool.fromEnvironment('ENABLE_GOOGLE_SIGN_IN', defaultValue: false);

  static const bool enableMockAuth =
      bool.fromEnvironment('ENABLE_MOCK_AUTH', defaultValue: false);

  static bool get hasSupabaseConfig =>
      supabaseUrl.isNotEmpty && supabaseAnonKey.isNotEmpty;

  static bool get isExplicitMockMode => enableMockAuth;

  static void validateRuntimeConfiguration() {
    if (hasSupabaseConfig) {
      return;
    }

    if (isExplicitMockMode) {
      return;
    }

    throw StateError(
      'Supabase nao configurado para este build. Informe SUPABASE_URL e '
      'SUPABASE_ANON_KEY via --dart-define ou ative ENABLE_MOCK_AUTH=true '
      'explicitamente para modo mock.',
    );
  }

  static void logDiagnostics() {
    if (!kDebugMode) return;
    debugPrint(
      '[AppConfig] ENABLE_GOOGLE_SIGN_IN=$enableGoogleSignIn '
      'ENABLE_MOCK_AUTH=$enableMockAuth '
      'SHOW_DEV_BADGES=$showDevBadges '
      'SUPABASE_URL_PRESENT=${supabaseUrl.isNotEmpty} '
      'SUPABASE_ANON_KEY_PRESENT=${supabaseAnonKey.isNotEmpty}',
    );
  }
}
