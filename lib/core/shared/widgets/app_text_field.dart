import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../extensions/context_extensions.dart';
import '../../theme/app_sizes.dart';

class AppTextField extends StatefulWidget {
  const AppTextField({
    super.key,
    required this.label,
    this.hint,
    this.controller,
    this.validator,
    this.onChanged,
    this.keyboardType,
    this.textInputAction,
    this.prefixIcon,
    this.obscureText = false,
    this.readOnly = false,
    this.onTap,
    this.suffix,
    this.autofocus = false,
    this.inputFormatters,
    this.maxLines = 1,
    this.minLines,
    this.maxLength,
  });

  final String label;
  final String? hint;
  final TextEditingController? controller;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onChanged;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final IconData? prefixIcon;
  final bool obscureText;
  final bool readOnly;
  final VoidCallback? onTap;
  final Widget? suffix;
  final bool autofocus;
  final List<TextInputFormatter>? inputFormatters;
  final int maxLines;
  final int? minLines;
  final int? maxLength;

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late bool _obscure = widget.obscureText;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      validator: widget.validator,
      onChanged: widget.onChanged,
      keyboardType: widget.keyboardType,
      textInputAction: widget.textInputAction,
      obscureText: _obscure,
      maxLines: widget.maxLines,
      minLines: widget.minLines,
      maxLength: widget.maxLength,
      readOnly: widget.readOnly,
      onTap: widget.onTap,
      autofocus: widget.autofocus,
      inputFormatters: widget.inputFormatters,
      style: context.textTheme.bodyLarge,
      decoration: InputDecoration(
        labelText: widget.label,
        hintText: widget.hint,
        alignLabelWithHint: widget.maxLines > 1,
        prefixIcon: widget.prefixIcon != null
            ? Icon(widget.prefixIcon, size: AppSizes.iconField)
            : null,
        suffixIcon: widget.obscureText
            ? IconButton(
                icon: Icon(
                  _obscure ? LucideIcons.eyeOff : LucideIcons.eye,
                  size: AppSizes.iconField,
                ),
                onPressed: () => setState(() => _obscure = !_obscure),
              )
            : widget.suffix,
      ),
    );
  }
}
