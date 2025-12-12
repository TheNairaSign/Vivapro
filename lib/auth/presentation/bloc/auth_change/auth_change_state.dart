class AuthStateChangeState {}

class AuthStateChangeInitial extends AuthStateChangeState {}

class AuthStateChangeSuccess extends AuthStateChangeState {}

class AuthStateChangeFailure extends AuthStateChangeState {
  final String message;

  AuthStateChangeFailure(this.message);
}