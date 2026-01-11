import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in_platform_interface/google_sign_in_platform_interface.dart';
import 'package:vivapro/features/auth/data/auth_user.dart';
import 'package:vivapro/core/failures/auth_failure.dart';

class GoogleSignInRepository {
  final FirebaseAuth _firebaseAuth;
  Future<void>? _initialization;

  GoogleSignInRepository({FirebaseAuth? firebaseAuth})
    : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  static const List<String> _scopes = <String>[
    'email',
    'profile',
    'https://www.googleapis.com/auth/contacts.readonly',
  ];

  /// Initialize Google Sign-In
  Future<void> _ensureInitialized() {
    debugPrint("Initializing Google Sign-In");
    return _initialization ??=
        GoogleSignInPlatform.instance.init(const InitParameters())
          ..catchError((dynamic _) {
            _initialization = null;
            debugPrint("Failed to initialize Google Sign-In");
          });
  }

  /// Sign in with Google and authenticate with Firebase
  Future<Either<AuthFailure, AuthUser>> signInWithGoogle() async {
    try {
      await _ensureInitialized();

      // Trigger the Google Sign-In flow
      final AuthenticationResults result = await GoogleSignInPlatform.instance
          .authenticate(const AuthenticateParameters());

      debugPrint("Google Sign-In result: $result");

      final GoogleSignInUserData? googleUser = result.user;

      debugPrint("Google Sign-In user: $googleUser");

      if (googleUser == null) {
        // User canceled the sign-in
        debugPrint("User cancelled request");
        return left(AuthFailure.cancelledByUser());
      }

      // Get the authentication tokens
      final ClientAuthorizationTokenData? tokens = await GoogleSignInPlatform
          .instance
          .clientAuthorizationTokensForScopes(
            ClientAuthorizationTokensForScopesParameters(
              request: AuthorizationRequestDetails(
                scopes: _scopes,
                userId: googleUser.id,
                email: googleUser.email,
                promptIfUnauthorized: true,
              ),
            ),
          );

      debugPrint("Google Sign-In tokens: $tokens");

      if (tokens == null) {
        debugPrint("Failed to get tokens");
        // return left(AuthFailure.serverError());
      }

      // Create a new credential for Firebase
      // Note: Google Sign-In Platform Interface doesn't provide idToken directly
      // We'll use just the access token for now
      final credential = GoogleAuthProvider.credential(
        accessToken: tokens?.accessToken,
      );

      // Sign in to Firebase with the Google credential
      final UserCredential userCredential = await _firebaseAuth
          .signInWithCredential(credential);

      if (userCredential.user != null) {
        debugPrint("User signed in successfully");
        return right(AuthUser.fromFirebaseUser(userCredential.user!));
      } else {
        debugPrint("User not found");
        return left(AuthFailure.userNotFound());
      }
    } on GoogleSignInException catch (e) {
      if (e.code == GoogleSignInExceptionCode.canceled) {
        debugPrint("User cancelled request");
        return left(AuthFailure.cancelledByUser());
      }
      debugPrint("Google Sign-In Error: ${e.description}");
      return left(
        AuthFailure.unknownError('Google Sign-In Error: ${e.description}'),
      );
    } on FirebaseAuthException catch (e) {
      return left(_handleFirebaseAuthException(e));
    } catch (e) {
      debugPrint("Unknown error: ${e.toString()}");
      return left(AuthFailure.unknownError(e.toString()));
    }
  }

  /// Attempt lightweight authentication (silent sign-in)
  /// This will sign in the user if they have previously signed in
  Future<Either<AuthFailure, AuthUser>> signInSilently() async {
    try {
      await _ensureInitialized();

      final AuthenticationResults? result = await GoogleSignInPlatform.instance
          .attemptLightweightAuthentication(
            const AttemptLightweightAuthenticationParameters(),
          );

      final GoogleSignInUserData? googleUser = result?.user;

      if (googleUser == null) {
        return left(AuthFailure.userNotFound());
      }

      // Get the authentication tokens
      final ClientAuthorizationTokenData? tokens = await GoogleSignInPlatform
          .instance
          .clientAuthorizationTokensForScopes(
            ClientAuthorizationTokensForScopesParameters(
              request: AuthorizationRequestDetails(
                scopes: const [],
                userId: googleUser.id,
                email: googleUser.email,
                promptIfUnauthorized: false,
              ),
            ),
          );

      if (tokens == null) {
        return left(AuthFailure.serverError());
      }

      final credential = GoogleAuthProvider.credential(
        accessToken: tokens.accessToken,
      );

      final UserCredential userCredential = await _firebaseAuth
          .signInWithCredential(credential);

      if (userCredential.user != null) {
        return right(AuthUser.fromFirebaseUser(userCredential.user!));
      } else {
        return left(AuthFailure.userNotFound());
      }
    } on GoogleSignInException catch (e) {
      return left(
        AuthFailure.unknownError('Google Sign-In Error: ${e.description}'),
      );
    } on FirebaseAuthException catch (e) {
      return left(_handleFirebaseAuthException(e));
    } catch (e) {
      return left(AuthFailure.unknownError(e.toString()));
    }
  }

  Future<Either<AuthFailure, Unit>> signOut() async {
    try {
      await _ensureInitialized();
      await GoogleSignInPlatform.instance.disconnect(const DisconnectParams());
      await _firebaseAuth.signOut();
      return right(unit);
    } catch (e) {
      return left(AuthFailure.unknownError(e.toString()));
    }
  }

  AuthFailure _handleFirebaseAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'account-exists-with-different-credential':
        return AuthFailure.emailAlreadyInUse();
      case 'invalid-credential':
        return AuthFailure.invalidEmailOrPassword();
      case 'operation-not-allowed':
        return AuthFailure.operationNotAllowed();
      case 'user-disabled':
        return AuthFailure.userNotFound();
      case 'user-not-found':
        return AuthFailure.userNotFound();
      case 'wrong-password':
        return AuthFailure.wrongPassword();
      default:
        return AuthFailure.unknownError(
          e.message ?? 'An unknown error occurred during Google Sign-In.',
        );
    }
  }
}

/// Provider for GoogleSignInRepository
final googleSignInRepositoryProvider = Provider<GoogleSignInRepository>((ref) {
  return GoogleSignInRepository();
});
