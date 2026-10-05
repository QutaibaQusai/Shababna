import 'package:flutter/material.dart';

import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../core/shared/widgets/app_button.dart';
import '../../../../../core/shared/widgets/guest_gate.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../shared/home_formatters.dart';

class HomeGreeting extends StatelessWidget {
  const HomeGreeting({super.key, required this.isMember, required this.fullName});

  final bool isMember;
  final String? fullName;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colorScheme;
    final titleStyle = context.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold);
    final mutedStyle = context.textTheme.bodyMedium?.copyWith(color: colors.onSurfaceVariant);
    final fullName = this.fullName;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.screenMargin),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: isMember
            ? [
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: HomeFormatters.greeting(context, DateTime.now()),
                        style: TextStyle(
                          color: colors.onSurfaceVariant,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      if (fullName != null && fullName.isNotEmpty) TextSpan(text: ', $fullName'),
                    ],
                  ),
                  style: titleStyle,
                ),
              ]
            : [
                Text(l10n.homeGuestTitle, style: titleStyle),
                SizedBox(height: AppSpacing.xxs),
                Text(l10n.homeGuestSubtitle, style: mutedStyle),
                SizedBox(height: AppSpacing.sm),
                AppButton.primary(
                  label: l10n.loginButton,
                  onPressed: () => ensureSignedIn(context),
                ),
              ],
      ),
    );
  }
}
