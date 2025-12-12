import 'package:bloc/bloc.dart';
import 'package:vivapro/auth/presentation/bloc/signin/sign_in_event.dart';
import 'package:vivapro/auth/presentation/bloc/signin/sign_in_state.dart';
import 'package:vivapro/auth/presentation/bloc/signup/sign_up_state.dart';
import 'package:vivapro/auth/repositories/auth_repository.dart';

class SignInBloc extends Bloc<SignInEvent, SignInState> {
  final AuthRepository _authRepository;

  SignInBloc(this._authRepository) : super(SignInInitial()) {
    on<SignInSubmitted>(signInWithEmailAndPassword);
    }

  Future<void> signInWithEmailAndPassword(SignInSubmitted event, Emitter<SignInState> emit) async {
      emit(SignInLoading());
      
      try {
        final result = await _authRepository.signInWithEmailAndPassword(email: event.email, password: event.password);

        result.fold(
          (failure) => emit(SignInFailure(message: failure.toString())),
          (user) => emit(SignInSuccess(user: user)),
        );
     } catch (e) {
        emit(SignInFailure(message: e.toString()));
      }       
      
  }
}
