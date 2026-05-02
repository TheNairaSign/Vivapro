import 'package:flutter/material.dart';
import 'package:vivapro/pages/onboarding/widgets/animated_background.dart';
import 'package:vivapro/pages/onboarding/onboarding_page.dart';

class StartPage extends StatefulWidget {
  const StartPage({super.key});

  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.65, curve: Curves.easeOut),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.65, curve: Curves.easeOutBack),
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Stack(
        children: [
          // const AnimatedBackground(),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(),
                  // Logo Section
                  ScaleTransition(
                    scale: _scaleAnimation,
                    child: FadeTransition(
                      opacity: _fadeAnimation,
                      child: Column(
                        crossAxisAlignment: .center,
                        children: [
                          Image.asset(
                            'assets/images/communicate.png',
                            width: deviceWidth,
                            height: deviceWidth,
                            fit: BoxFit.cover,
                          ),
                          const SizedBox(height: 30),
                          Text(
                            'Loop',
                            textAlign: TextAlign.center,
                            style: theme.textTheme.headlineLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.onSurface,
                              letterSpacing: -1,
                            ),
                          ),
                         
                          const SizedBox(height: 10),
                          // Text(
                          //   // 'Meaningful connections, effortlessly maintained.',
                          //   'Stay connected, intentionally',
                          //   textAlign: TextAlign.center,
                          //   style: theme.textTheme.bodyLarge?.copyWith(
                          //     color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                          //     height: 1.5,
                          //   ),
                          // ),
                          Text(
                            'Stay connected with the people that matter most, without the overwhelm.',
                            textAlign: TextAlign.left,
                            style: theme.textTheme.headlineSmall?.copyWith(
                              color: Colors.grey,
                              height: 1.5,
                              fontSize: 22
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Spacer(),
                  // Actions Section
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: Column(
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(builder: (context) => const OnboardingPage()),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: theme.colorScheme.primary,
                            foregroundColor: Colors.white,
                            minimumSize: const Size(double.infinity, 60),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                            // elevation: 8,
                            // shadowColor: theme.colorScheme.primary.withValues(alpha: 0.5),
                          ),
                          child: Text(
                            'Get Started',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
