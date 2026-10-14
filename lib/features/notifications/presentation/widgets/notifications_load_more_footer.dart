import 'package:flutter/material.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/shared/widgets/app_button.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_spacing.dart';

class NotificationsLoadMoreFooter extends StatelessWidget {
  const NotificationsLoadMoreFooter({
    super.key,
    required this.failed,
    required this.onRetry,
  });

  static const _strokeWidth = 2.0;

  final bool failed;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Center(
        child: failed
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    context.l10n.loadMoreFailedMessage,
                    style: context.textTheme.bodyMedium?.copyWith(
                      color: context.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  AppButton.text(label: context.l10n.retry, onPressed: onRetry),
                ],
              )
            : SizedBox.square(
                dimension: AppSizes.iconMd,
                child: CircularProgressIndicator(
                  strokeWidth: _strokeWidth,
                  color: context.colorScheme.primary,
                ),
              ),
      ),
    );
  }
}
