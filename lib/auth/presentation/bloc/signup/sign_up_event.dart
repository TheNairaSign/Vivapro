abstract class SignUpEvent {}

class SignUpSubmitted extends SignUpEvent {
  final String email;
  final String password;
  final String name;

  SignUpSubmitted({
    required this.email,
    required this.password,
    required this.name,
  });
}

class AuthStateChanged extends SignUpEvent {
  final dynamic user;

  AuthStateChanged(this.user);
}