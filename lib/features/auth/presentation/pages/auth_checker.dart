import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:vivapro/features/auth/data/auth_user.dart';
import 'package:vivapro/features/auth/presentation/bloc/auth_change/auth_change_bloc.dart';
import 'package:vivapro/features/auth/presentation/bloc/auth_change/auth_change_event.dart';
import 'package:vivapro/features/auth/presentation/bloc/auth_change/auth_change_state.dart';
import 'package:vivapro/features/auth/presentation/pages/auth_page.dart';
import 'package:vivapro/pages/navigation/navigation_page.dart';

class AuthChecker extends StatelessWidget {
  const AuthChecker({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(
              child: LoadingAnimationWidget.threeRotatingDots(
                color: Theme.of(context).colorScheme.primary,
                size: 20,
              ),
            ),
          );
        }

        final user = snapshot.data;
        if (user == null) {
          return AuthPage();
        } else {
          return _LoggedInAuthHandler(user: user);
        }
      },
    );
  }
}

class _LoggedInAuthHandler extends StatefulWidget {
  const _LoggedInAuthHandler({required this.user});
  final User user;

  @override
  State<_LoggedInAuthHandler> createState() => _LoggedInAuthHandlerState();
}

class _LoggedInAuthHandlerState extends State<_LoggedInAuthHandler> {
  @override
  void initState() {
    super.initState();
    context.read<AuthStateChangeBloc>().add(
          AuthStateChange(AuthUser.fromFirebaseUser(widget.user)),
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthStateChangeBloc, AuthStateChangeState>(
      listener: (context, state) {
        if (state is AuthStateChangeSuccess) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (builder) => NavigationPage(user: state.user),
            ),
          );
        } else if (state is AuthStateChangeFailure) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (builder) => AuthPage()),
          );
        }
      },
      child: Scaffold(
        body: Center(
          child: LoadingAnimationWidget.threeRotatingDots(
            color: Theme.of(context).colorScheme.primary,
            size: 20,
          ),
        ),
      ),
    );
  }
}