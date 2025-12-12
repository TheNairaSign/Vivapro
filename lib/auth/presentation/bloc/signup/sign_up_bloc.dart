import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vivapro/auth/presentation/bloc/signup/sign_up_event.dart';
import 'package:vivapro/auth/presentation/bloc/signup/sign_up_state.dart';
import 'package:vivapro/auth/repositories/auth_repository.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  final FirebaseAuthRepository _authRepository;

  SignUpBloc(this._authRepository) : super(SignUpInitial()) {
    on<SignUpSubmitted>(signUpWithEmailAndPassword);
  }

  Future<void> signUpWithEmailAndPassword(SignUpSubmitted event, Emitter<SignUpState> emit) async {
    emit(SignUpLoading());
    
    try {
      final result = await _authRepository.signUpWithEmailAndPassword(email: event.email, password: event.password);

      result.fold(
        (failure) => emit(SignUpFailure(message: failure.toString())),
        (user) => emit(SignUpSuccess()),
      );

    } catch (e) {
      emit(SignUpFailure(message: e.toString()));
    }
  }
}