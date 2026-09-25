import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../theme/app_sizes.dart';
import 'app_text_field.dart';

class AppDateField extends StatefulWidget {
  const AppDateField({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    this.prefixIcon = LucideIcons.calendar,
    this.validator,
    this.firstDate,
    this.lastDate,
  });

  final String label;
  final DateTime? value;
  final ValueChanged<DateTime> onChanged;
  final IconData prefixIcon;
  final FormFieldValidator<String>? validator;
  final DateTime? firstDate;
  final DateTime? lastDate;

  @override
  State<AppDateField> createState() => _AppDateFieldState();
}

class _AppDateFieldState extends State<AppDateField> {
  late final _controller = TextEditingController(text: _displayText);

  String get _displayText {
    final date = widget.value;
    if (date == null) return '';
    return '${_pad(date.day)}/${_pad(date.month)}/${date.year}';
  }

  String _pad(int value) => value.toString().padLeft(2, '0');

  @override
  void didUpdateWidget(AppDateField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _controller.text = _displayText;
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final selected = await showDatePicker(
      context: context,
      initialDate: widget.value ?? DateTime(now.year - 18, now.month, now.day),
      firstDate: widget.firstDate ?? DateTime(1900),
      lastDate: widget.lastDate ?? now,
    );
    if (selected != null) widget.onChanged(selected);
  }

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      label: widget.label,
      controller: _controller,
      readOnly: true,
      prefixIcon: widget.prefixIcon,
      suffix: Icon(LucideIcons.chevronDown, size: AppSizes.iconField),
      validator: widget.validator,
      onTap: _pickDate,
    );
  }
}
