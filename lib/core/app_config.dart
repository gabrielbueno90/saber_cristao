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

  static void logDiagnostics() {
    if (!kDebugMode) return;
    debugPrint(
      '[AppConfig] ENABLE_GOOGLE_SIGN_IN=$enableGoogleSignIn '
      'SHOW_DEV_BADGES=$showDevBadges '
      'SUPABASE_URL_PRESENT=${supabaseUrl.isNotEmpty} '
      'SUPABASE_ANON_KEY_PRESENT=${supabaseAnonKey.isNotEmpty}',
    );
  }
}
