import 'package:vivapro/features/auth/data/auth_user.dart';

class AuthStateChangeState {}

class AuthStateChangeInitial extends AuthStateChangeState {}

class AuthStateChangeSuccess extends AuthStateChangeState {
  final AuthUser user;

  AuthStateChangeSuccess(this.user);
}   

class AuthStateChangeFailure extends AuthStateChangeState {
  final String message;

  AuthStateChangeFailure(this.message);
}
