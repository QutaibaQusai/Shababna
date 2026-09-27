import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../core/routes/app_routes.dart';
import '../../../../../core/shared/widgets/app_button.dart';
import '../../../../../core/theme/app_sizes.dart';
import '../../../../../core/theme/app_spacing.dart';

class GuestProfileHeader extends StatelessWidget {
  const GuestProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    void openLogin() => context.push(AppRoutes.loginModal);

    return InkWell(
      onTap: openLogin,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.screenMargin,
          vertical: AppSpacing.sm,
        ),
        child: Row(
          children: [
            Container(
              width: AppSizes.avatarSize,
              height: AppSizes.avatarSize,
              decoration: BoxDecoration(
                color: context.colorScheme.primary,
                shape: BoxShape.circle,
              ),
              child: Icon(
                LucideIcons.user,
                size: AppSizes.iconMd,
                color: context.colorScheme.onPrimary,
              ),
            ),
            SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    context.l10n.guestProfileTitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: context.textTheme.displaySmall?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: AppSpacing.xxs),
                  TextButtonTheme(
                    data: TextButtonThemeData(
                      style: context.theme.textButtonTheme.style?.copyWith(
                        padding: const WidgetStatePropertyAll(EdgeInsets.zero),
                        minimumSize: const WidgetStatePropertyAll(Size.zero),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                    ),
                    child: AppButton.text(label: context.l10n.loginButton, onPressed: openLogin),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
