import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vivapro/auth/presentation/bloc/signin/sign_in_bloc.dart';
import 'package:vivapro/auth/presentation/bloc/signin/sign_in_event.dart';
import 'package:vivapro/auth/presentation/pages/forgot_password_page.dart';
import 'package:vivapro/auth/presentation/pages/sign_up_page.dart';
import 'package:vivapro/auth/presentation/widgets/auth_button.dart';
import 'package:vivapro/core/theme/global_colors.dart';
import 'package:vivapro/widgets/custom_text_field.dart';
import 'package:vivapro/widgets/next_button.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  bool isLoading = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void signIn() {
    if (formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      context.read<SignInBloc>().add(SignInSubmitted(
        email: emailController.text,
        password: passwordController.text,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Container(
              constraints: BoxConstraints(maxWidth: 400),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 20,
                    offset: Offset(0, 10),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(30.0),
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Close button
                      Align(
                        alignment: Alignment.topRight,
                        child: GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: GlobalColors.yellow,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(Icons.close, size: 20),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      
                      // Title
                      Text(
                        'Welcome back,',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 8),
                      
                      // Subtitle
                      Text(
                        'We happy to see you here again. Enter your email address and password',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 30),
                      
                      // Email field
                      CustomTextfield(
                        controller: emailController,
                        hintText: 'Email',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          }
                          if (!value.contains('@')) {
                            return 'Please enter a valid email';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      
                      // Password field
                      CustomTextfield(
                        controller: passwordController,
                        hintText: 'Password',
                        obscure: true,
                        showSuffix: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),
                      
                      // Forgot password link
                      Align(
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ForgotPasswordPage(),
                              ),
                            );
                          },
                          child: Text(
                            'Forgot password?',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      
                      // Log In button
                      NextButton(
                        color: GlobalColors.yellow,
                        borderColor: GlobalColors.darkPurple,
                        onPressed: signIn,
                        radius: 25,
                        label: 'Log In',
                        isLoading: isLoading,
                      ),
                      const SizedBox(height: 20),
                      
                      // OR divider
                      Row(
                        children: [
                          Expanded(child: Divider(color: Colors.grey[300])),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Text(
                              'OR',
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                          ),
                          Expanded(child: Divider(color: Colors.grey[300])),
                        ],
                      ),
                      const SizedBox(height: 20),
                      
                      // Social login buttons
                      AuthButton(
                        label: 'Continue with Google',
                        icon: 'assets/svgs/google.svg',
                        onPressed: () {
                          // TODO: Implement Google sign in
                        },
                      ),
                      const SizedBox(height: 12),
                      
                      AuthButton(
                        label: 'Continue with Facebook',
                        icon: 'assets/svgs/facebook.svg',
                        onPressed: () {
                          // TODO: Implement Facebook sign in
                        },
                      ),
                      const SizedBox(height: 12),
                      
                      AuthButton(
                        label: 'Continue with Apple',
                        icon: 'assets/svgs/apple.svg',
                        onPressed: () {
                          // TODO: Implement Apple sign in
                        },
                      ),
                      const SizedBox(height: 24),
                      
                      // Create account link
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const SignUpPage(),
                                ),
                              );
                            },
                            child: Text(
                              'Create an Account',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}