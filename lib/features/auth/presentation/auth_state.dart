import 'package:saber_cristao/features/auth/domain/auth_user.dart';

enum AuthStatus { loading, authenticated, unauthenticated, error }

class AuthState {
  const AuthState({
    required this.status,
    this.isUsingSupabase = false,
    this.user,
    this.errorMessage,
  });

  const AuthState.loading({bool isUsingSupabase = false})
      : this(status: AuthStatus.loading, isUsingSupabase: isUsingSupabase);
  const AuthState.unauthenticated()
      : this(status: AuthStatus.unauthenticated);
  const AuthState.authenticated(AuthUser user, {bool isUsingSupabase = false})
      : this(
          status: AuthStatus.authenticated,
          user: user,
          isUsingSupabase: isUsingSupabase,
        );
  const AuthState.error(String message, {bool isUsingSupabase = false})
      : this(
          status: AuthStatus.error,
          errorMessage: message,
          isUsingSupabase: isUsingSupabase,
        );

  final AuthStatus status;
  final bool isUsingSupabase;
  final AuthUser? user;
  final String? errorMessage;
}
