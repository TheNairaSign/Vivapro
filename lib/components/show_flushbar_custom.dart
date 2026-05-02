import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';

void showFlushbarCustom(
  BuildContext context,
  String title,
  String message,
  {Color? color, Widget? mainButton, Duration duration = const Duration(seconds: 3)}
) {
  Flushbar(
    titleText: Text(title, style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold, color: Colors.white)),
    messageText: Text(message, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white)),
    icon: Icon(Icons.info_outline, size: 28.0, color: Colors.white),
    // leftBarIndicatorColor: color ?? Theme.of(context).colorScheme.primary,
    duration: duration,
    flushbarPosition: FlushbarPosition.TOP,
    margin: const EdgeInsets.all(8),
    borderRadius: BorderRadius.circular(8),
    backgroundColor: color ?? Theme.of(context).colorScheme.primary,
    mainButton: mainButton,
    // boxShadows: [
    //   BoxShadow(
    //     color: Colors.black.withValues(alpha: 0.2),
    //     offset: const Offset(0.0, 2.0),
    //     blurRadius: 3.0,
    //   ),
    // ],
  ).show(context);
}
