import 'package:vivapro/auth/data/auth_user.dart';

class AuthChangeEvent {}

class AuthStateChange extends AuthChangeEvent {
  final AuthUser? user;

  AuthStateChange(this.user);
}
