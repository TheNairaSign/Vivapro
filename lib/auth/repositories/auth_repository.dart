import 'package:firebase_auth/firebase_auth.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vivapro/auth/data/auth_user.dart';
import 'package:vivapro/core/failures/auth_failure.dart';


/// Abstract interface for authentication operations.
abstract class AuthRepository {
  Stream<AuthUser?> get authStateChanges;

  Future<Either<AuthFailure, AuthUser>> signInWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<Either<AuthFailure, AuthUser>> signUpWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<Either<AuthFailure, Unit>> signOut();

  AuthUser? getCurrentUser();
}

/// Firebase implementation of the AuthRepository.
class FirebaseAuthRepository implements AuthRepository {
  final FirebaseAuth _firebaseAuth;

  FirebaseAuthRepository(this._firebaseAuth);

  @override
  Stream<AuthUser?> get authStateChanges {
    return _firebaseAuth.authStateChanges().map((user) {
      if (user == null) {
        return null;
      } else {
        return AuthUser.fromFirebaseUser(user);
      }
    });
  }

  @override
  Future<Either<AuthFailure, AuthUser>> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (userCredential.user != null) {
        return right(AuthUser.fromFirebaseUser(userCredential.user!));
      } else {
        return left(AuthFailure.userNotFound());
      }
    } on FirebaseAuthException catch (e) {
      return left(_handleFirebaseAuthException(e));
    } catch (e) {
      return left(AuthFailure.unknownError(e.toString()));
    }
  }

  @override
  Future<Either<AuthFailure, AuthUser>> signUpWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (userCredential.user != null) {
        return right(AuthUser.fromFirebaseUser(userCredential.user!));
      } else {
        return left(AuthFailure.userNotFound());
      }
    } on FirebaseAuthException catch (e) {
      return left(_handleFirebaseAuthException(e));
    } catch (e) {
      return left(AuthFailure.unknownError(e.toString()));
    }
  }

  @override
  Future<Either<AuthFailure, Unit>> signOut() async {
    try {
      await _firebaseAuth.signOut();
      return right(unit);
    } on FirebaseAuthException catch (e) {
      return left(_handleFirebaseAuthException(e));
    } catch (e) {
      return left(AuthFailure.unknownError(e.toString()));
    }
  }

  @override
  AuthUser? getCurrentUser() {
    final user = _firebaseAuth.currentUser;
    return user != null ? AuthUser.fromFirebaseUser(user) : null;
  }

  AuthFailure _handleFirebaseAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-email':
      case 'user-disabled':
      case 'user-not-found':
        return AuthFailure.userNotFound();
      case 'wrong-password':
        return AuthFailure.wrongPassword();
      case 'email-already-in-use':
        return AuthFailure.emailAlreadyInUse();
      case 'operation-not-allowed':
        return AuthFailure.operationNotAllowed();
      case 'weak-password':
        return AuthFailure.weakPassword();
      case 'too-many-requests':
        return AuthFailure.tooManyRequests();
      case 'network-request-failed':
        return AuthFailure.serverError(); // Or a specific network failure
      default:
        return AuthFailure.unknownError(e.message ?? 'An unknown error occurred.');
    }
  }
}

final firebaseAuthRepository = Provider<FirebaseAuthRepository>((ref) => FirebaseAuthRepository(FirebaseAuth.instance));