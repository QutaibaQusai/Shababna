import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../theme/app_sizes.dart';
import '../../theme/app_spacing.dart';
import 'app_icon_button.dart';

class AppAppBar extends StatelessWidget implements PreferredSizeWidget {
  const AppAppBar({
    super.key,
    required this.title,
    this.onBack,
    this.leadingIcon,
    this.actions,
  });

  final String title;
  final VoidCallback? onBack;
  final IconData? leadingIcon;
  final List<Widget>? actions;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final isRtl = Directionality.of(context) == TextDirection.rtl;
    final showBack = onBack != null;

    return AppBar(
      automaticallyImplyLeading: false,
      title: Text(title),
      centerTitle: true,
      leadingWidth: showBack ? (AppSizes.iconButtonSize + AppSpacing.screenMargin) : null,
      leading: showBack
          ? Padding(
              padding: EdgeInsetsDirectional.only(start: AppSpacing.screenMargin),
              child: Center(
                child: AppIconButton(
                  icon: leadingIcon ?? (isRtl ? LucideIcons.chevronRight : LucideIcons.chevronLeft),
                  onPressed: onBack,
                ),
              ),
            )
          : null,
      actions: actions != null
          ? [
              Padding(
                padding: EdgeInsetsDirectional.only(end: AppSpacing.screenMargin),
                child: Row(mainAxisSize: MainAxisSize.min, children: actions!),
              ),
            ]
          : null,
    );
  }
}
