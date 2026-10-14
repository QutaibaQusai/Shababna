import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/config/app_assets.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/shared/widgets/app_icon_button.dart';
import '../../../../core/shared/widgets/guest_gate.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../cubit/unread_count/unread_count_cubit.dart';

class NotificationBellButton extends StatelessWidget {
  const NotificationBellButton({super.key});

  static const _maxShownCount = 9;
  static const _badgeBorderWidth = 1.5;

  Future<void> _open(BuildContext context) async {
    if (!await ensureSignedIn(context) || !context.mounted) return;
    context.push(AppRoutes.notifications);
  }

  @override
  Widget build(BuildContext context) {
    final count = context.watch<UnreadCountCubit>().state;
    final l10n = context.l10n;
    final colors = context.colorScheme;
    final badgeSize = AppSizes.notificationBadgeSize;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        AppIconButton.svg(
          svgAsset: AppAssets.iconNotification,
          semanticLabel: count > 0
              ? l10n.notificationsUnreadLabel(count)
              : l10n.actionNotifications,
          onPressed: () => _open(context),
        ),
        if (count > 0)
          PositionedDirectional(
            top: -AppSpacing.xxs,
            end: -AppSpacing.xxs,
            child: IgnorePointer(
              child: ExcludeSemantics(
                child: Container(
                  constraints: BoxConstraints(
                    minWidth: badgeSize,
                    minHeight: badgeSize,
                  ),
                  padding: EdgeInsets.symmetric(horizontal: AppSpacing.xxs),
                  decoration: BoxDecoration(
                    color: colors.error,
                    borderRadius: AppRadius.pillRadius,
                    border: Border.all(
                      color: colors.surface,
                      width: _badgeBorderWidth,
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    count > _maxShownCount ? '$_maxShownCount+' : '$count',
                    textDirection: TextDirection.ltr,
                    style: context.textTheme.labelSmall?.copyWith(
                      color: colors.onError,
                      fontWeight: FontWeight.w700,
                      height: 1,
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
