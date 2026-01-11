import 'package:bloc/bloc.dart';
import 'package:vivapro/features/auth/presentation/bloc/signin/sign_in_event.dart';
import 'package:vivapro/features/auth/presentation/bloc/signin/sign_in_state.dart';
import 'package:vivapro/features/auth/repositories/firebase_auth_repository.dart';

class SignInBloc extends Bloc<SignInEvent, SignInState> {
  final FirebaseAuthRepository _authRepository;

  SignInBloc(this._authRepository) : super(SignInInitial()) {
    on<SignInSubmitted>(signInWithEmailAndPassword);
  }

  Future<void> signInWithEmailAndPassword(
    SignInSubmitted event,
    Emitter<SignInState> emit,
  ) async {
    emit(SignInLoading());

    try {
      final isEmailVerified = await _authRepository.isEmailVerified();

      if (!isEmailVerified) {
        emit(SignInFailure(message: 'Email is not verified'));
        return;
      }

      final result = await _authRepository.signInWithEmailAndPassword(
        email: event.email,
        password: event.password,
      );

      result.fold(
        (failure) => emit(SignInFailure(message: failure.toString())),
        (user) => emit(SignInSuccess(user: user)),
      );
    } catch (e) {
      emit(SignInFailure(message: e.toString()));
    }
  }
}
