import 'package:saber_cristao/features/auth/domain/auth_user.dart';

abstract class AuthRepository {
  bool get isUsingSupabase;
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
  Future<void> sendPasswordReset(String email);
  Future<void> signOut();
  Future<void> signInWithGoogle();
  Future<void> ensureProfile(AuthUser user);
}
