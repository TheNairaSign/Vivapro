import 'package:flutter/material.dart';
import 'package:vivapro/auth/presentation/pages/sign_up_page.dart';
import 'package:vivapro/auth/presentation/widgets/auth_button.dart';
import 'package:vivapro/core/theme/global_colors.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final isLoading = false;
  
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final height = size.height;
    final width = size.width;
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 25),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset('assets/images/business-illustration.png', height: height * .45),
              // const Spacer(),
              Text("Welcome to Vivapro", style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),),
              Text("Got an interview to prepare for?\nBook practice sessions with mentors or your peers", style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey)),
              const SizedBox(height: 40),
              AuthButton(
                label: 'Continue with Email',
                icon: 'assets/svgs/gmail.svg',
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const SignUpPage(),
                  ),
                ),
                isLoading: isLoading,
              ),
              const SizedBox(height: 20),
              AuthButton(
                label: 'Continue with Google',
                icon: 'assets/svgs/google.svg',
                onPressed: () {},
                isLoading: isLoading,
              ),
              const SizedBox(height: 20),
              AuthButton(
                label: 'Continue with Apple',
                icon: 'assets/svgs/apple.svg',
                onPressed: () {},
                isLoading: isLoading,
              ),
            ],
          ),
        ),
      )
    );
  }
}