import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/services/theme_service.dart';
import '../../../../core/shared/widgets/app_page_header.dart';
import '../../../../core/theme/app_spacing.dart';
import 'sheet_option_tile.dart';

class ThemeSheet extends StatelessWidget {
  const ThemeSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final themeMode = context.watch<ThemeService>().state;

    void select(ThemeMode mode) {
      context.read<ThemeService>().setThemeMode(mode);
      Navigator.pop(context);
    }

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          left: AppSpacing.screenMargin,
          right: AppSpacing.screenMargin,
          bottom: AppSpacing.sm,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppPageHeader(
              title: context.l10n.profileMenuTheme,
              subtitle: context.l10n.profileMenuThemeSubtitle,
            ),
            SizedBox(height: AppSpacing.sm),
            SheetOptionTile(
              title: context.l10n.themeSystem,
              isSelected: themeMode == ThemeMode.system,
              onTap: () => select(ThemeMode.system),
            ),
            SizedBox(height: AppSpacing.xs),
            SheetOptionTile( 
              title: context.l10n.themeLight,
              isSelected: themeMode == ThemeMode.light,
              onTap: () => select(ThemeMode.light),
            ),
            SizedBox(height: AppSpacing.xs),
            SheetOptionTile(
              title: context.l10n.themeDark,
              isSelected: themeMode == ThemeMode.dark,
              onTap: () => select(ThemeMode.dark),
            ),
            SizedBox(height: AppSpacing.xs),
          ],
        ),
      ),
    );
  }
}
