import 'package:flutter/widgets.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../extensions/context_extensions.dart';
import '../../theme/app_dimensions.dart';

class AppEmptyWidget extends StatelessWidget {
  const AppEmptyWidget({super.key, this.message});

  final String? message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(AppDimensions.spacingMd),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              LucideIcons.inbox,
              size: AppDimensions.iconLg,
              color: context.colorScheme.onSurfaceVariant,
            ),
            SizedBox(height: AppDimensions.spacingXs),
            Text(
              message ?? context.l10n.noItemsFound,
              textAlign: TextAlign.center,
              style: context.textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
