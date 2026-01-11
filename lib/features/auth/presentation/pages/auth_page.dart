import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vivapro/features/auth/presentation/bloc/google_signin/google_sign_in_bloc.dart';
import 'package:vivapro/features/auth/presentation/bloc/google_signin/google_sign_in_event.dart';
import 'package:vivapro/features/auth/presentation/bloc/google_signin/google_sign_in_state.dart';
import 'package:vivapro/features/auth/presentation/pages/sign_up_page.dart';
import 'package:vivapro/features/auth/presentation/widgets/auth_button.dart';
import 'package:vivapro/pages/navigation/navigation_page.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final height = size.height;
    return Scaffold(
      body: BlocListener<GoogleSignInBloc, GoogleSignInState>(
        listener: (context, state) {
          if (state is GoogleSignInLoading) {
            setState(() {
              isLoading = true;
            });
          } else if (state is GoogleSignInSuccess) {
            setState(() {
              isLoading = false;
            });
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => NavigationPage(user: state.user),
              ),
            );
          } else if (state is GoogleSignInFailure) {
            setState(() {
              isLoading = false;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Sign in failed: ${state.failure.toString()}'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 25),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(
                  'assets/images/business-illustration.png',
                  height: height * .45,
                ),
                // const Spacer(),
                Text(
                  "Welcome to Vivapro",
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "Never lose touch with people who matter.",
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: Colors.grey),
                ),
                const SizedBox(height: 40),
                AuthButton(
                  label: 'Continue with Email',
                  icon: 'assets/svgs/gmail.svg',
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const SignUpPage()),
                  ),
                  // isLoading: isLoading,
                ),
                const SizedBox(height: 20),
                AuthButton(
                  label: 'Continue with Google',
                  icon: 'assets/svgs/google.svg',
                  onPressed: () {
                    context.read<GoogleSignInBloc>().add(
                      GoogleSignInRequested(),
                    );
                  },
                  isLoading: isLoading,
                ),
                const SizedBox(height: 20),
                AuthButton(
                  label: 'Continue with Apple',
                  icon: 'assets/svgs/apple.svg',
                  onPressed: () {},
                  // isLoading: isLoading,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
