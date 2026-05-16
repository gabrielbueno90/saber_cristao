class AuthUser {
  const AuthUser({
    required this.id,
    required this.email,
    required this.displayName,
    required this.provider,
  });

  final String id;
  final String email;
  final String displayName;
  final String provider;
}
