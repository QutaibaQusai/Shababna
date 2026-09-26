import 'package:flutter/widgets.dart';
import 'package:flutter_undraw/flutter_undraw.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../extensions/context_extensions.dart';
import '../../theme/app_sizes.dart';
import '../../theme/app_spacing.dart';

class AppEmptyWidget extends StatelessWidget {
  const AppEmptyWidget({super.key, this.message});

  final String? message;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme.primary;

    return Center(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(AppSpacing.md),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Undraw(
              illustration: UndrawIllustration.empty,
              color: color,
              height: AppSizes.illustrationSize,
              placeholder: SizedBox(height: AppSizes.illustrationSize),
              errorWidget: Icon(LucideIcons.inbox, size: AppSizes.iconLg, color: color),
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
