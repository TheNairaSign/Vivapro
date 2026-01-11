abstract class GoogleSignInEvent {}

class GoogleSignInRequested extends GoogleSignInEvent {}

class GoogleSignInSilentlyRequested extends GoogleSignInEvent {}

class GoogleSignOutRequested extends GoogleSignInEvent {}
