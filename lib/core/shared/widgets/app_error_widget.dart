import 'package:flutter/widgets.dart';

import '../../config/app_assets.dart';
import '../../extensions/context_extensions.dart';
import '../../theme/app_sizes.dart';
import '../../theme/app_spacing.dart';
import 'app_button.dart';
import 'app_illustration.dart';

class AppErrorWidget extends StatelessWidget {
  const AppErrorWidget({super.key, required this.message, this.onRetry});

  final String message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme.error;

    return Center(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(AppSpacing.md),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppIllustration(
              asset: AppAssets.illustrationWarning,
              height: AppSizes.illustrationSize,
              color: color,
            ),
            SizedBox(height: AppSpacing.md),
            Text(
              message,
              textAlign: TextAlign.center,
              style: context.textTheme.bodyMedium,
            ),
            if (onRetry != null) ...[
              SizedBox(height: AppSpacing.sm),
              AppButton.text(label: context.l10n.retry, onPressed: onRetry),
            ],
          ],
        ),
      ),
    );
  }
}
