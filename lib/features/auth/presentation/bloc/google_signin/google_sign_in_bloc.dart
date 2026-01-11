import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vivapro/features/auth/presentation/bloc/google_signin/google_sign_in_event.dart';
import 'package:vivapro/features/auth/presentation/bloc/google_signin/google_sign_in_state.dart';
import 'package:vivapro/features/auth/repositories/google_sign_in_repository.dart';

class GoogleSignInBloc extends Bloc<GoogleSignInEvent, GoogleSignInState> {
  final GoogleSignInRepository _googleSignInRepository;

  GoogleSignInBloc(this._googleSignInRepository)
    : super(GoogleSignInInitial()) {
    on<GoogleSignInRequested>(_onGoogleSignInRequested);
    on<GoogleSignInSilentlyRequested>(_onGoogleSignInSilentlyRequested);
    on<GoogleSignOutRequested>(_onGoogleSignOutRequested);
  }

  Future<void> _onGoogleSignInRequested(
    GoogleSignInRequested event,
    Emitter<GoogleSignInState> emit,
  ) async {
    emit(GoogleSignInLoading());

    final result = await _googleSignInRepository.signInWithGoogle();

    result.fold(
      (failure) => emit(GoogleSignInFailure(failure)),
      (user) => emit(GoogleSignInSuccess(user)),
    );
  }

  Future<void> _onGoogleSignInSilentlyRequested(
    GoogleSignInSilentlyRequested event,
    Emitter<GoogleSignInState> emit,
  ) async {
    emit(GoogleSignInLoading());

    final result = await _googleSignInRepository.signInSilently();

    result.fold(
      (failure) => emit(GoogleSignInFailure(failure)),
      (user) => emit(GoogleSignInSuccess(user)),
    );
  }

  Future<void> _onGoogleSignOutRequested(
    GoogleSignOutRequested event,
    Emitter<GoogleSignInState> emit,
  ) async {
    emit(GoogleSignInLoading());

    final result = await _googleSignInRepository.signOut();

    result.fold(
      (failure) => emit(GoogleSignInFailure(failure)),
      (_) => emit(GoogleSignOutSuccess()),
    );
  }
}
