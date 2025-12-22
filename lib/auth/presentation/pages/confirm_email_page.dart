import 'package:flutter/material.dart';
import 'package:vivapro/auth/presentation/pages/login_page.dart';
import 'package:vivapro/core/theme/global_colors.dart';
import 'package:vivapro/widgets/next_button.dart';

class ConfirmEmailPage extends StatefulWidget {
  final String? email;

  const ConfirmEmailPage({super.key, this.email});

  @override
  State<ConfirmEmailPage> createState() => _ConfirmEmailPageState();
}

class _ConfirmEmailPageState extends State<ConfirmEmailPage> {
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
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 20,
                    offset: Offset(0, 10),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(30.0),
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
                            color: Colors.yellow,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.close, size: 20),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Icon
                    Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.yellow.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.mark_email_read_outlined,
                        size: 60,
                        color: Colors.yellow,
                      ),
                    ),
                    const SizedBox(height: 30),

                    // Title
                    Text(
                      'Check your mail',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                    ),
                    const SizedBox(height: 12),

                    // Subtitle
                    Text(
                      widget.email != null
                          ? 'We have sent a confirmation email to ${widget.email}. Please check your inbox and click the link to verify your account.'
                          : 'We have sent a confirmation email to your email address. Please check your inbox and click the link to verify your account.',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.grey[600],
                            height: 1.5,
                          ),
                    ),
                    const SizedBox(height: 30),

                    // Back to Login Button
                    NextButton(
                      color: Colors.yellow,
                      borderColor: Colors.blue,
                      onPressed: () {
                         Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginPage(),
                          ),
                        );
                      },
                      radius: 25,
                      label: 'Back to Log In',
                      isLoading: false,
                    ),
                    const SizedBox(height: 24),

                    // Resend link
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Did not receive the email? ',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                        GestureDetector(
                          onTap: () {
                            // TODO: Implement resend email logic
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Resend feature coming soon!'),
                              ),
                            );
                          },
                          child: Text(
                            'Resend',
                            style: TextStyle(
                              color: Colors.yellow,
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
    );
  }
}