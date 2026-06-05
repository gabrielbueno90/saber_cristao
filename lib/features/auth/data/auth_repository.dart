import 'package:saber_cristao/features/auth/domain/auth_user.dart';
import 'package:saber_cristao/features/auth/domain/google_sign_in_availability.dart';

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
  Future<void> registerWithEmail({
    required String name,
    required String email,
    required String password,
  });
  Future<void> sendPasswordReset(
    String email, {
    required String redirectTo,
  });
  Future<void> updatePassword(String password);
  Future<void> signOut();
  Future<void> signInWithGoogle();
  Future<void> ensureProfile(AuthUser user);
}
