import 'package:flutter/material.dart';
import 'package:vivapro/core/theme/global_colors.dart';

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
  });
  final TextEditingController? controller;
  final String? hintText, initialValue, label;
  final Widget? prefixIcon, suffixIcon;
  final bool showSuffix;
  final double? height;
  bool obscure, enabled;
  final int maxLines, minLines;
  final Function(String)? onChanged;
  final String? Function(String?)? validator;

  @override
  State<CustomTextfield> createState() => _CustomTextfieldState();
}

class _CustomTextfieldState extends State<CustomTextfield> {
  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return TextFormField(
      controller: widget.controller,
      maxLines: widget.maxLines,
      minLines: widget.minLines,
      obscureText: widget.obscure,
      initialValue: widget.controller == null ? widget.initialValue : null,
      cursorColor: Colors.green,
      onChanged: widget.onChanged,
      validator: widget.validator,
      style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: GlobalColors.textThemeColor(context)),
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.all(10),
        hintText: widget.hintText,
        hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey),
        prefixIcon: widget.prefixIcon,
        labelText: widget.label,
        labelStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(),
        suffixIcon: widget.suffixIcon ??
          (widget.showSuffix
              ? GestureDetector(
                  onTap: () {
                    setState(() {
                      widget.obscure = !widget.obscure;
                    });
                  },
                  child: Icon(
                      widget.obscure
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: GlobalColors.textThemeColor(context),
                      size: 20,
                    )
                  )
              : null
            ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey, width: .3),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.lightBlue, width: 1),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: .5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.black, width: .5),
        ),
        enabled: widget.enabled,
        fillColor: GlobalColors.containerColor(context),
        filled: true,
      ),
    );
  }
}
