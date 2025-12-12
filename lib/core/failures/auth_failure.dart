abstract class AuthFailure {
  const AuthFailure();
  factory AuthFailure.serverError() = ServerError;
  factory AuthFailure.invalidEmailOrPassword() = InvalidEmailOrPassword;
  factory AuthFailure.emailAlreadyInUse() = EmailAlreadyInUse;
  factory AuthFailure.userNotFound() = UserNotFound;
  factory AuthFailure.wrongPassword() = WrongPassword;
  factory AuthFailure.cancelledByUser() = CancelledByUser;
  factory AuthFailure.tooManyRequests() = TooManyRequests;
  factory AuthFailure.weakPassword() = WeakPassword;
  factory AuthFailure.operationNotAllowed() = OperationNotAllowed;
  factory AuthFailure.unknownError(String message) = UnknownError;

}

class ServerError extends AuthFailure {
  @override
  String toString() {
    return 'AuthFailure.ServerError';
  }
}

class InvalidEmailOrPassword extends AuthFailure {
  @override
  String toString() {
    return 'AuthFailure.InvalidEmailOrPassword';
  }
}

class EmailAlreadyInUse extends AuthFailure {
  @override
  String toString() {
    return 'AuthFailure.EmailAlreadyInUse';
  }
}

class UserNotFound extends AuthFailure {
  @override
  String toString() {
    return 'AuthFailure.UserNotFound';
  }
}

class WrongPassword extends AuthFailure {
  @override
  String toString() {
    return 'AuthFailure.WrongPassword';
  }
}

class CancelledByUser extends AuthFailure {
  @override
  String toString() {
    return 'AuthFailure.CancelledByUser';
  }
}

class TooManyRequests extends AuthFailure {
  @override
  String toString() {
    return 'AuthFailure.TooManyRequests';
  }
}

class WeakPassword extends AuthFailure {
  @override
  String toString() {
    return 'AuthFailure.WeakPassword';
  }
}

class OperationNotAllowed extends AuthFailure {
  @override
  String toString() {
    return 'AuthFailure.OperationNotAllowed';
  }
}

class UnknownError extends AuthFailure {
  final String message;
  const UnknownError(this.message);
}
