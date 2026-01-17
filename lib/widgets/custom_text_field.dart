// ignore_for_file: must_be_immutable

import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';

class CustomTextfield extends StatefulWidget {
  CustomTextfield({
    super.key,
    this.controller,
    this.hintText,
    this.prefixIcon,
    this.showSuffix = false,
    this.obscure = false,
    this.height,
    this.enabled = true,
    this.suffixIcon,
    this.initialValue,
    this.onChanged,
    this.validator,
    this.label,
    this.maxLines = 1,
    this.minLines = 1,
    this.keyboardType = TextInputType.text,
    this.fillColor,
  }) : assert(maxLines > 0),
       assert(minLines > 0),
       assert(maxLines >= minLines),
       assert(controller != null || initialValue != null);

  final TextEditingController? controller;
  final String? hintText, initialValue, label;
  final Widget? prefixIcon, suffixIcon;
  final bool showSuffix;
  final double? height;
  final Color? fillColor;
  bool obscure, enabled;
  final int maxLines, minLines;
  final Function(String)? onChanged;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;

  @override
  State<CustomTextfield> createState() => _CustomTextfieldState();
}

class _CustomTextfieldState extends State<CustomTextfield> {
  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return TextFormField(
      controller: widget.controller,
      keyboardType: widget.keyboardType,
      maxLines: widget.maxLines,
      minLines: widget.minLines,
      obscureText: widget.obscure,
      initialValue: widget.initialValue,
      cursorColor: Theme.of(context).colorScheme.primary,
      onChanged: widget.onChanged,
      validator: widget.validator,
      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
        color: Theme.of(context).colorScheme.onSurface,
        fontWeight: FontWeight.w500,
      ),
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        hintText: widget.hintText,
        hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey.withValues(alpha: 0.6)),
        prefixIcon: widget.prefixIcon,
        labelText: widget.label,
        labelStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(),
        suffixIcon:
            widget.suffixIcon ??
            (widget.showSuffix
                ? GestureDetector(
                    onTap: () {
                      setState(() {
                        widget.obscure = !widget.obscure;
                      });
                    },
                    child: Icon(
                      widget.obscure ? EvaIcons.eyeOff : EvaIcons.eye,
                      color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                      size: 20,
                    ),
                  )
                : null),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: isDarkMode ? Colors.white.withValues(alpha: 0.05) : Colors.black.withValues(alpha: 0.05),
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.5),
            width: 1.5,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Colors.redAccent, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
        ),
        enabled: widget.enabled,
        fillColor: widget.fillColor ?? (isDarkMode 
            ? Colors.white.withValues(alpha: 0.03) 
            : Colors.black.withValues(alpha: 0.03)),
        filled: true,
      ),
    );
  }
}
