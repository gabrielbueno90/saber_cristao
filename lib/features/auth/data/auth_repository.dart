import 'package:saber_cristao/features/auth/domain/auth_user.dart';
import 'package:saber_cristao/features/auth/domain/google_sign_in_availability.dart';

class RegisterResult {
  const RegisterResult({
    required this.requiresEmailConfirmation,
    this.user,
  });

  final bool requiresEmailConfirmation;
  final AuthUser? user;
}

abstract class AuthRepository {
  bool get isUsingSupabase;
  bool get canUseGoogleSignIn;
  Future<GoogleSignInAvailability> diagnoseGoogleSignIn();
  Stream<AuthUser?> authStateChanges();
  Future<AuthUser?> currentUser();
  Future<void> signInWithEmail({
    required String email,
    required String password,
  });
  Future<RegisterResult> registerWithEmail({
    required String name,
    required String email,
    required String password,
  });
  Future<bool> sendPasswordReset(
    String email, {
    required String redirectTo,
  });
  Future<void> updatePassword(String password);
  Future<void> signOut();
  Future<void> signInWithGoogle();
  Future<void> ensureProfile(AuthUser user);
}
