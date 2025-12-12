import 'package:vivapro/auth/data/auth_user.dart';

abstract class SignInEvent {}

class SignInSubmitted extends SignInEvent {
  final String email;
  final String password;

  SignInSubmitted({required this.email, required this.password});
}
