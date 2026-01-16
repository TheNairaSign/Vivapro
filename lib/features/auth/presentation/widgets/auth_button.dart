import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class AuthButton extends StatelessWidget {
  const AuthButton({
    super.key,
    required this.label,
    required this.icon,
    required this.onPressed,
    this.isLoading = false,
  });
  final String label;
  final String icon;
  final VoidCallback onPressed;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: isLoading ? null : onPressed,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          // border: Border.all(color: Colors.grey[300]!, width: 1.5),
          borderRadius: BorderRadius.circular(25),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(width: 24, height: 24, child: SvgPicture.asset(icon)),
            const SizedBox(width: 12),
            Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
            if (isLoading)
              Padding(
                padding: const EdgeInsets.only(left: 12),
                child: SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    color: isDark ? Colors.white : Colors.black,
                    strokeWidth: 2,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
