import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vivapro/auth/presentation/bloc/auth_change/auth_change_event.dart';
import 'package:vivapro/auth/presentation/bloc/auth_change/auth_change_state.dart';
import 'package:vivapro/auth/repositories/firebase_auth_repository.dart';

class AuthStateChangeBloc extends Bloc<AuthChangeEvent, AuthStateChangeState> {
  final FirebaseAuthRepository _authRepository;

  AuthStateChangeBloc(this._authRepository) : super(AuthStateChangeInitial()) {
    _authRepository.authStateChanges.listen((user) {
      add(AuthStateChange(user));
    });
    on<AuthStateChange>(_onAuthStateChange);
  }

  void _onAuthStateChange(
    AuthStateChange event,
    Emitter<AuthStateChangeState> emit,
  ) {
    if (event.user != null) {
      emit(AuthStateChangeSuccess());
    } else {
      emit(AuthStateChangeFailure('User not found'));
    }
  }
}