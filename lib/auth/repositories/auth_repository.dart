import 'package:dartz/dartz.dart';
import 'package:vivapro/auth/data/auth_user.dart';
import 'package:vivapro/core/failures/auth_failure.dart';
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
