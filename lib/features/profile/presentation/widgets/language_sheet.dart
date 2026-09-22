import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/services/locale_service.dart';
import '../../../../core/theme/app_spacing.dart';
import 'sheet_option_tile.dart';

class LanguageSheet extends StatelessWidget {
  const LanguageSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final languageCode = context.watch<LocaleService>().languageCode;

    void select(String code) {
      context.read<LocaleService>().setLocale(Locale(code));
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
            SheetOptionTile(
              title: context.l10n.languageArabic,
              isSelected: languageCode == 'ar',
              onTap: () => select('ar'),
            ),
            SizedBox(height: AppSpacing.xs),
            SheetOptionTile(
              title: context.l10n.languageEnglish,
              isSelected: languageCode == 'en',
              onTap: () => select('en'),
            ),
            SizedBox(height: AppSpacing.xs),
          ],
        ),
      ),
    );
  }
}
