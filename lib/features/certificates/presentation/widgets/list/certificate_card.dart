import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../core/routes/app_routes.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/app_sizes.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../domain/repositories/certificates_repository.dart';
import '../shared/certificate_badge.dart';
import '../shared/certificate_formatters.dart';
import '../shared/certificate_revoked_tag.dart';

class CertificateCard extends StatelessWidget {
  const CertificateCard({super.key, required this.certificate});

  final Certificate certificate;

  @override
  Widget build(BuildContext context) {
    final colors = context.colorScheme;
    final issuedAt = certificate.issuedAt;
    final meta = [
      CertificateFormatters.hours(context, certificate.recognizedHours),
      if (issuedAt != null)
        context.l10n.certificateIssuedOn(CertificateFormatters.date(context, issuedAt)),
    ].join(' · ');

    return Material(
      color: colors.surface,
      borderRadius: AppRadius.lgRadius,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => context.push(AppRoutes.certificateDetailsPath(certificate.id)),
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.sm),
          child: Row(
            children: [
              CertificateBadge(size: AppSizes.iconLg, isRevoked: certificate.isRevoked),
              SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      certificate.title(context.isArabic),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: context.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: AppSpacing.xxs),
                    Text(
                      meta,
                      style: context.textTheme.bodySmall?.copyWith(color: colors.onSurfaceVariant),
                    ),
                  ],
                ),
              ),
              SizedBox(width: AppSpacing.xs),
              if (certificate.isRevoked)
                const CertificateRevokedTag()
              else
                Icon(
                  context.isRTL ? LucideIcons.chevronLeft : LucideIcons.chevronRight,
                  size: AppSizes.iconSm,
                  color: colors.onSurfaceVariant,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
