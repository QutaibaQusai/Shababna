import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/shared/widgets/app_icon_button.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../notifications/presentation/widgets/notification_bell_button.dart';
import '../cubit/layout_cubit.dart';

class LayoutAppBar extends StatelessWidget implements PreferredSizeWidget {
  const LayoutAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final tab = context.watch<LayoutCubit>().state;
    final l10n = context.l10n;

    return AppBar(
      automaticallyImplyLeading: false,
      centerTitle: false,
      title: Text(
        tab.label(l10n),
        overflow: TextOverflow.ellipsis,
        style: context.textTheme.headlineLarge?.copyWith(fontWeight: FontWeight.w700),
      ),
      actions: tab.hasActions
          ? [
              if (tab.hasSearch) ...[
                AppIconButton(
                  icon: LucideIcons.search,
                  semanticLabel: l10n.actionSearch,
                  onPressed: () => context.push(AppRoutes.search),
                ),
                SizedBox(width: AppSpacing.xs),
              ],
              const NotificationBellButton(),
              SizedBox(width: AppSpacing.xs),
              AppIconButton(
                icon: LucideIcons.userRound,
                semanticLabel: l10n.navProfile,
                onPressed: () => context.push(AppRoutes.profile),
              ),
              SizedBox(width: AppSpacing.screenMargin),
            ]
          : null,
    );
  }
}
