import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../core/routes/app_routes.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../shared/home_formatters.dart';

class HomeGreeting extends StatelessWidget {
  const HomeGreeting({super.key, required this.isMember, required this.firstName});

  final bool isMember;
  final String? firstName;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colorScheme;
    final titleStyle = context.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold);
    final mutedStyle = context.textTheme.bodyMedium?.copyWith(color: colors.onSurfaceVariant);
    final firstName = this.firstName;

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
                      if (firstName != null && firstName.isNotEmpty) TextSpan(text: ', $firstName'),
                    ],
                  ),
                  style: titleStyle,
                ),
              ]
            : [
                Text(l10n.homeGuestTitle, style: titleStyle),
                SizedBox(height: AppSpacing.xxs),
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(text: '${l10n.homeGuestSubtitle} '),
                      WidgetSpan(
                        alignment: PlaceholderAlignment.baseline,
                        baseline: TextBaseline.alphabetic,
                        child: Semantics(
                          button: true,
                          child: GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () => context.push(AppRoutes.loginModal),
                            child: Text(
                              l10n.loginButton,
                              style: mutedStyle?.copyWith(
                                color: colors.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  style: mutedStyle,
                ),
              ],
      ),
    );
  }
}
