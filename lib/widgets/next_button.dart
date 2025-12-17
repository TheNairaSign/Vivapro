import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:vivapro/core/theme/global_colors.dart';

class NextButton extends StatelessWidget {
  const NextButton({
    super.key,
    required this.label,
    this.icon,
    required this.onPressed,
    this.isLoading = false,
    this.radius,
    this.color,
    this.borderColor,
  });
  final String label;
  final Widget? icon;
  final VoidCallback onPressed;
  final bool isLoading;
  final double? radius;
  final Color? color, borderColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: isLoading ? 
        Center(
          child: SizedBox(
            width: 20,
            height: 20,
            child: LoadingAnimationWidget.threeRotatingDots(
              color: GlobalColors.freshPink,
              size: 20,
            ),
          ),
        )
      : GestureDetector(
        onTap: isLoading ? null : onPressed,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(radius ?? 30),
            color: color ?? GlobalColors.freshPink,
            boxShadow: [
              BoxShadow(
                color: (color ?? GlobalColors.freshPink).withOpacity(0.3),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                icon!,
                const SizedBox(width: 10),
              ],
              Text(
                label,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}