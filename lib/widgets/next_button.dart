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
              color: GlobalColors.darkPurple,
              size: 20,
            ),
          ),
        )
      : GestureDetector(
        onTap: isLoading ? null : onPressed,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(radius ?? 10),
            color: color ?? GlobalColors.yellow,
            border: BorderDirectional(
              top: BorderSide(
                color: borderColor ?? GlobalColors.darkPurple,
                width: 1,
              ),
              bottom: BorderSide(
                color: borderColor ?? GlobalColors.darkPurple,
                width: 8,
              ),
              start: BorderSide(
                color: borderColor ?? GlobalColors.darkPurple,
                width: 2,
              ),
              end: BorderSide(
                color: borderColor ?? GlobalColors.darkPurple,
                width: 2,
              ),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              icon ?? const SizedBox(),
              const SizedBox(width: 10),
              Text(
                label,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: GlobalColors.darkPurple, fontWeight: FontWeight.bold),
              ),
              
            ],
          ),
        ),
      ),
    );
  }
}