import 'package:firebase_auth/firebase_auth.dart';

class AuthUser {
  final String id;
  final String? email;
  final String? displayName;
  final String? photoUrl;

  const AuthUser({
    required this.id,
    this.email,
    this.displayName,
    this.photoUrl,
  });

  factory AuthUser.fromFirebaseUser(User user) {
    return AuthUser(
      id: user.uid,
      email: user.email,
      displayName: user.displayName,
      photoUrl: user.photoURL,
    );
  }
}
