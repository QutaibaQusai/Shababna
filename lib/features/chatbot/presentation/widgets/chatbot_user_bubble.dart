import 'package:flutter/material.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';

class ChatbotUserBubble extends StatelessWidget {
  const ChatbotUserBubble({super.key, required this.text});

  static const _maxWidthFactor = 0.78;

  final String text;

  @override
  Widget build(BuildContext context) {
    final corner = Radius.circular(AppRadius.xl);
    final tail = Radius.circular(AppRadius.sm / 2);

    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: MediaQuery.sizeOf(context).width * _maxWidthFactor,
      ),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: context.colorScheme.primary,
          borderRadius: BorderRadiusDirectional.only(
            topStart: corner,
            topEnd: corner,
            bottomStart: corner,
            bottomEnd: tail,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xs + AppSpacing.xxs / 2),
          child: Text(
            text,
            style: context.textTheme.bodyLarge?.copyWith(color: context.colorScheme.onPrimary),
          ),
        ),
      ),
    );
  }
}
