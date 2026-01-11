import 'package:vivapro/features/auth/data/auth_user.dart';

abstract class SignInState {}

class SignInInitial extends SignInState {}

class SignInLoading extends SignInState {}

class SignInSuccess extends SignInState {
  final AuthUser user;

  SignInSuccess({required this.user});
}

class SignInFailure extends SignInState {
  final String message;

  SignInFailure({required this.message});
}
