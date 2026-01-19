import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';

void showFlushbar(
  BuildContext context,
  String title,
  String message,
  {Color? color}
) {
  Flushbar(
    titleText: Text(title, style: Theme.of(context).textTheme.bodyMedium),
    message: message,
    icon: Icon(Icons.info_outline, size: 28.0, color: color ?? Theme.of(context).colorScheme.primary),
    leftBarIndicatorColor: color ?? Theme.of(context).colorScheme.primary,
    duration: const Duration(seconds: 3),
    flushbarPosition: FlushbarPosition.TOP,
    margin: const EdgeInsets.all(8),
    borderRadius: BorderRadius.circular(8),
    backgroundColor: Theme.of(context).colorScheme.surface,
    boxShadows: [
      BoxShadow(
        color: Colors.black.withValues(alpha: 0.2),
        offset: const Offset(0.0, 2.0),
        blurRadius: 3.0,
      ),
    ],
  ).show(context);
}
