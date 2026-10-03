import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../core/shared/widgets/app_text_field.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/app_sizes.dart';
import '../../../../../core/theme/app_spacing.dart';

class FieldCard extends StatelessWidget {
  const FieldCard({
    super.key,
    required this.label,
    required this.icon,
    required this.value,
    this.valueDirection,
    this.badge,
    this.opensPage = false,
    this.onTap,
    this.hasError = false,
  });

  final String label;
  final IconData icon;
  final String? value;
  final TextDirection? valueDirection;
  final Widget? badge;
  final bool opensPage;
  final VoidCallback? onTap;
  final bool hasError;

  IconData _arrowIcon(BuildContext context) {
    if (!opensPage) return LucideIcons.chevronDown;
    return context.isRTL ? LucideIcons.chevronLeft : LucideIcons.chevronRight;
  }

  @override
  Widget build(BuildContext context) {
    final inputTheme = Theme.of(context).inputDecorationTheme;
    final text = value?.trim() ?? '';
    final arrow = onTap == null ? null : Icon(_arrowIcon(context), size: AppSizes.iconField);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        AppFieldLabel(label: label, hasError: hasError),
        SizedBox(height: AppSpacing.xs),
        InkWell(
          onTap: onTap,
          borderRadius: AppRadius.mdRadius,
          child: InputDecorator(
            isEmpty: text.isEmpty,
            decoration: InputDecoration(
              enabledBorder: hasError ? inputTheme.errorBorder : null,
              prefixIcon: Icon(icon, size: AppSizes.iconField),
              suffixIcon: _suffix(arrow),
            ),
            child: Text(
              text,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textDirection: valueDirection,
              textAlign: valueDirection == null ? null : TextAlign.start,
              style: context.textTheme.bodyLarge,
            ),
          ),
        ),
      ],
    );
  }

  Widget? _suffix(Widget? arrow) {
    if (badge == null) return arrow;
    if (arrow == null) return badge;

    return Padding(
      padding: EdgeInsetsDirectional.only(
        end: (kMinInteractiveDimension - AppSizes.iconField) / 2,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [badge!, SizedBox(width: AppSpacing.xs), arrow],
      ),
    );
  }
}

class VerificationBadge extends StatelessWidget {
  const VerificationBadge({super.key, required this.isVerified});

  final bool isVerified;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: isVerified ? context.l10n.emailVerifiedLabel : context.l10n.emailNotVerifiedLabel,
      child: Icon(
        isVerified ? Icons.verified_rounded : Icons.error_rounded,
        size: AppSizes.iconField,
        color: isVerified ? context.colorScheme.primary : context.colorScheme.error,
      ),
    );
  }
}
