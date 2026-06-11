import 'package:saber_cristao/features/auth/domain/auth_user.dart';

enum AuthStatus { loading, authenticated, unauthenticated, error }

class AuthState {
  const AuthState({
    required this.status,
    this.isUsingSupabase = false,
    this.user,
    this.errorMessage,
    this.requiresPasswordReset = false,
  });

  const AuthState.loading({
    bool isUsingSupabase = false,
    bool requiresPasswordReset = false,
  }) : this(
         status: AuthStatus.loading,
         isUsingSupabase: isUsingSupabase,
         requiresPasswordReset: requiresPasswordReset,
       );
  const AuthState.unauthenticated()
      : this(status: AuthStatus.unauthenticated);
  const AuthState.authenticated(
    AuthUser user, {
    bool isUsingSupabase = false,
    bool requiresPasswordReset = false,
  })
      : this(
          status: AuthStatus.authenticated,
          user: user,
          isUsingSupabase: isUsingSupabase,
          requiresPasswordReset: requiresPasswordReset,
        );
  const AuthState.error(
    String message, {
    bool isUsingSupabase = false,
    bool requiresPasswordReset = false,
  })
      : this(
          status: AuthStatus.error,
          errorMessage: message,
          isUsingSupabase: isUsingSupabase,
          requiresPasswordReset: requiresPasswordReset,
        );

  final AuthStatus status;
  final bool isUsingSupabase;
  final AuthUser? user;
  final String? errorMessage;
  final bool requiresPasswordReset;
}
