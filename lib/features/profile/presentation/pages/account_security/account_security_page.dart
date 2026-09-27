import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../core/routes/app_routes.dart';
import '../../../../../core/shared/widgets/app_app_bar.dart';
import '../../../../../core/shared/widgets/app_menu_tile.dart';
import '../../../../../core/shared/widgets/app_page_header.dart';
import '../../../../../core/theme/app_spacing.dart';

class AccountSecurityPage extends StatelessWidget {
  const AccountSecurityPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppAppBar(
        title: context.l10n.profileMenuAccountSecurity,
        onBack: () => context.pop(),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(
                AppSpacing.screenMargin,
                AppSpacing.screenMargin,
                AppSpacing.screenMargin,
                0,
              ),
              child: AppPageHeader(
                title: context.l10n.profileMenuAccountSecurity,
                subtitle: context.l10n.accountSecuritySubtitle,
              ),
            ),
            SizedBox(height: AppSpacing.xs),
            AppMenuTile(
              icon: LucideIcons.lock,
              title: context.l10n.changePasswordTitle,
              onTap: () => context.push(AppRoutes.changePassword),
            ),
            AppMenuTile(
              icon: LucideIcons.trash2,
              title: context.l10n.deleteAccountTitle,
              isDestructive: true,
              onTap: () => context.push(AppRoutes.deleteAccount),
            ),
          ],
        ),
      ),
    );
  }
}
