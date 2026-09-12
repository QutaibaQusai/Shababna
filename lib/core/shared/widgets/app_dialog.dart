import 'package:flutter/material.dart';

import 'app_button.dart';

class AppDialog {
  AppDialog._();

  static Future<bool> confirm(
    BuildContext context, {
    required String title,
    required String message,
    required String confirmText,
    required String cancelText,
  }) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          AppButton.text(
            label: cancelText,
            onPressed: () => Navigator.of(context).pop(false),
          ),
          AppButton.text(
            label: confirmText,
            onPressed: () => Navigator.of(context).pop(true),
          ),
        ],
      ),
    );
    return confirmed ?? false;
  }
}
