import 'package:flutter/material.dart';

import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/app_spacing.dart';

class CertificateRevokedTag extends StatelessWidget {
  const CertificateRevokedTag({super.key});

  static const _backgroundAlpha = 0.12;

  @override
  Widget build(BuildContext context) {
    final error = context.colorScheme.error;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.xs, vertical: AppSpacing.xxs),
      decoration: BoxDecoration(
        color: error.withValues(alpha: _backgroundAlpha),
        borderRadius: AppRadius.pillRadius,
      ),
      child: Text(
        context.l10n.certificateRevoked,
        style: context.textTheme.labelSmall?.copyWith(color: error, fontWeight: FontWeight.bold),
      ),
    );
  }
}
