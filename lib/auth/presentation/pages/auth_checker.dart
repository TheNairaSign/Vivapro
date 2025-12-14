import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:vivapro/auth/data/auth_user.dart';
import 'package:vivapro/auth/presentation/bloc/auth_change/auth_change_bloc.dart';
import 'package:vivapro/auth/presentation/bloc/auth_change/auth_change_event.dart';
import 'package:vivapro/auth/presentation/bloc/auth_change/auth_change_state.dart';
import 'package:vivapro/auth/presentation/pages/auth_page.dart';
import 'package:vivapro/core/theme/global_colors.dart';
import 'package:vivapro/pages/navigation/navigation_page.dart';

class AuthChecker extends StatefulWidget {
  const AuthChecker({super.key});

  @override
  State<AuthChecker> createState() => _AuthCheckerState();
}

class _AuthCheckerState extends State<AuthChecker> {
  final _firebaseAuth = FirebaseAuth.instance;
  @override
  void initState() {
    super.initState();
    if (_firebaseAuth.currentUser == null) return;
    context.read<AuthStateChangeBloc>().add(AuthStateChange(AuthUser.fromFirebaseUser(_firebaseAuth.currentUser!)));
  }
  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthStateChangeBloc, AuthStateChangeState>(
      listener: (context, state) {
        if (state is AuthStateChangeSuccess) {
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (builder) => const NavigationPage()));
        } else if (state is AuthStateChangeFailure) {
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (builder) => AuthPage()));
        }
      },
      child: Scaffold(
        body: Center(
          child: LoadingAnimationWidget.threeRotatingDots(color: GlobalColors.darkPurple, size: 20),
        ),
      ),
    );
  }
}