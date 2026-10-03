import 'package:flutter/widgets.dart';

import '../../config/app_assets.dart';
import '../../extensions/context_extensions.dart';
import '../../theme/app_sizes.dart';
import '../../theme/app_spacing.dart';
import 'app_illustration.dart';

class AppEmptyWidget extends StatelessWidget {
  const AppEmptyWidget({super.key, this.message});

  final String? message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(AppSpacing.md),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppIllustration(
              asset: AppAssets.illustrationEmpty,
              height: AppSizes.illustrationSize,
            ),
            SizedBox(height: AppSpacing.md),
            Text(
              message ?? context.l10n.noItemsFound,
              textAlign: TextAlign.center,
              style: context.textTheme.bodyMedium?.copyWith(
                color: context.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
