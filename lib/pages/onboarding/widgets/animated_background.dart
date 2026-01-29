import 'package:flutter/material.dart';
import 'dart:math' as math;

class AnimatedBackground extends StatefulWidget {
  const AnimatedBackground({super.key});

  @override
  State<AnimatedBackground> createState() => _AnimatedBackgroundState();
}

class _AnimatedBackgroundState extends State<AnimatedBackground> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 15),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: isDark
                      ? [
                          const Color(0xFF0F172A),
                          const Color(0xFF1E293B),
                        ]
                      : [
                          const Color(0xFFF8FAFC),
                          const Color(0xFFE2E8F0),
                        ],
                ),
              ),
            ),
            _buildBlob(
              color: theme.colorScheme.primary.withValues(alpha: 0.15),
              size: 300,
              offset: Offset(
                math.sin(_controller.value * 2 * math.pi) * 50 + 20,
                math.cos(_controller.value * 2 * math.pi) * 50 + 100,
              ),
            ),
            _buildBlob(
              color: theme.colorScheme.secondary.withValues(alpha: 0.1),
              size: 400,
              offset: Offset(
                math.cos(_controller.value * 2 * math.pi) * 80 + 200,
                math.sin(_controller.value * 2 * math.pi) * 80 + 400,
              ),
            ),
            _buildBlob(
              color: theme.colorScheme.tertiary.withValues(alpha: 0.08),
              size: 250,
              offset: Offset(
                math.sin(_controller.value * 2 * math.pi) * 60 + 50,
                math.cos(_controller.value * 2 * math.pi) * 60 + 600,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildBlob({
    required Color color,
    required double size,
    required Offset offset,
  }) {
    return Positioned(
      left: offset.dx,
      top: offset.dy,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
