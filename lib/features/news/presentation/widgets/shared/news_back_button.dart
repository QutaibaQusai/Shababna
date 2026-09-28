import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../core/shared/widgets/app_icon_button.dart';
import '../../../../../core/theme/app_spacing.dart';

class NewsBackButton extends StatelessWidget {
  const NewsBackButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.only(start: AppSpacing.screenMargin),
      child: Center(
        child: AppIconButton(
          icon: context.isRTL ? LucideIcons.chevronRight : LucideIcons.chevronLeft,
          onPressed: () => context.pop(),
        ),
      ),
    );
  }
}
