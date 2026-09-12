import 'package:flutter/widgets.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../extensions/context_extensions.dart';
import '../../theme/app_dimensions.dart';
import 'app_button.dart';

class AppErrorWidget extends StatelessWidget {
  const AppErrorWidget({super.key, required this.message, this.onRetry});

  final String message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(AppDimensions.spacingMd),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              LucideIcons.triangleAlert,
              size: AppDimensions.iconLg,
              color: context.colorScheme.error,
            ),
            SizedBox(height: AppDimensions.spacingXs),
            Text(
              message,
              textAlign: TextAlign.center,
              style: context.textTheme.bodyMedium,
            ),
            if (onRetry != null) ...[
              SizedBox(height: AppDimensions.spacingSm),
              AppButton.text(label: context.l10n.retry, onPressed: onRetry),
            ],
          ],
        ),
      ),
    );
  }
}
