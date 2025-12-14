import 'package:vivapro/auth/data/auth_user.dart';
import 'package:vivapro/core/failures/auth_failure.dart';

abstract class GoogleSignInState {}

class GoogleSignInInitial extends GoogleSignInState {}

class GoogleSignInLoading extends GoogleSignInState {}

class GoogleSignInSuccess extends GoogleSignInState {
  final AuthUser user;

  GoogleSignInSuccess(this.user);
}

class GoogleSignInFailure extends GoogleSignInState {
  final AuthFailure failure;

  GoogleSignInFailure(this.failure);
}

class GoogleSignOutSuccess extends GoogleSignInState {}
