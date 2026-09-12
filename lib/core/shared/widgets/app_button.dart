import 'package:flutter/material.dart';

enum _ButtonType { primary, secondary, text }

class AppButton extends StatelessWidget {
  const AppButton.primary({super.key, required this.label, required this.onPressed})
      : _type = _ButtonType.primary;

  const AppButton.secondary({super.key, required this.label, required this.onPressed})
      : _type = _ButtonType.secondary;

  const AppButton.text({super.key, required this.label, required this.onPressed})
      : _type = _ButtonType.text;

  final String label;
  final VoidCallback? onPressed;
  final _ButtonType _type;

  @override
  Widget build(BuildContext context) {
    final child = Text(label);

    return switch (_type) {
      _ButtonType.primary => ElevatedButton(onPressed: onPressed, child: child),
      _ButtonType.secondary => OutlinedButton(onPressed: onPressed, child: child),
      _ButtonType.text => TextButton(onPressed: onPressed, child: child),
    };
  }
}
