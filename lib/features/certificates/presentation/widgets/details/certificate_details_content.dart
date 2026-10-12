import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/app_sizes.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../domain/repositories/certificates_repository.dart';
import '../shared/certificate_badge.dart';
import '../shared/certificate_formatters.dart';

class CertificateDetailsContent extends StatelessWidget {
  const CertificateDetailsContent({
    super.key,
    required this.certificate,
    required this.onOpen,
    required this.onCopyCode,
  });

  final Certificate certificate;
  final ValueChanged<CertificateLanguage> onOpen;
  final VoidCallback onCopyCode;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final languages = certificate.availableLanguages;
    final showDocuments = !certificate.isRevoked && languages.isNotEmpty;
    final periodStart = certificate.periodStart;
    final periodEnd = certificate.periodEnd;
    final issuedAt = certificate.issuedAt;

    return ListView(
      padding: EdgeInsets.all(AppSpacing.screenMargin),
      children: [
        _Header(certificate: certificate),
        if (certificate.isRevoked) ...[
          SizedBox(height: AppSpacing.md),
          _RevokedBanner(revokedAt: certificate.revokedAt),
        ],
        SizedBox(height: AppSpacing.md),
        _InfoCard(
          children: [
            _InfoRow(
              label: l10n.certificateNumberLabel,
              value: certificate.certificateNumber,
              valueDirection: TextDirection.ltr,
            ),
            _InfoRow(
              label: l10n.certificateHoursLabel,
              value: CertificateFormatters.hours(context, certificate.recognizedHours),
            ),
            if (periodStart != null && periodEnd != null)
              _InfoRow(
                label: l10n.certificatePeriodLabel,
                value: CertificateFormatters.period(context, periodStart, periodEnd),
              ),
            if (issuedAt != null)
              _InfoRow(
                label: l10n.certificateIssuedLabel,
                value: CertificateFormatters.date(context, issuedAt),
              ),
            if (certificate.verificationCode.isNotEmpty)
              _InfoRow(
                label: l10n.certificateVerificationCodeLabel,
                value: certificate.verificationCode,
                valueDirection: TextDirection.ltr,
                onCopy: onCopyCode,
              ),
          ],
        ),
        if (showDocuments) ...[
          SizedBox(height: AppSpacing.md),
          Text(
            l10n.certificateDocumentsTitle,
            style: context.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: AppSpacing.xs),
          for (final language in languages) ...[
            if (language != languages.first) SizedBox(height: AppSpacing.xs),
            _DocumentButton(
              label: switch (language) {
                CertificateLanguage.arabic => l10n.certificateOpenArabic,
                CertificateLanguage.english => l10n.certificateOpenEnglish,
              },
              onPressed: () => onOpen(language),
            ),
          ],
        ],
      ],
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.certificate});

  final Certificate certificate;

  @override
  Widget build(BuildContext context) {
    final isArabic = context.isArabic;
    final volunteerName = certificate.volunteerName(isArabic);

    return Column(
      children: [
        CertificateBadge(size: AppSizes.avatarSize, isRevoked: certificate.isRevoked),
        SizedBox(height: AppSpacing.sm),
        Text(
          certificate.title(isArabic),
          textAlign: TextAlign.center,
          style: context.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        if (volunteerName.isNotEmpty) ...[
          SizedBox(height: AppSpacing.xxs),
          Text(
            volunteerName,
            textAlign: TextAlign.center,
            style: context.textTheme.bodyMedium?.copyWith(
              color: context.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ],
    );
  }
}

class _RevokedBanner extends StatelessWidget {
  const _RevokedBanner({required this.revokedAt});

  static const _backgroundAlpha = 0.1;

  final DateTime? revokedAt;

  @override
  Widget build(BuildContext context) {
    final error = context.colorScheme.error;
    final revokedAt = this.revokedAt;

    return Container(
      padding: EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: error.withValues(alpha: _backgroundAlpha),
        borderRadius: AppRadius.lgRadius,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(LucideIcons.circleAlert, size: AppSizes.iconField, color: error),
          SizedBox(width: AppSpacing.xs),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.l10n.certificateRevoked,
                  style: context.textTheme.titleSmall?.copyWith(
                    color: error,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: AppSpacing.xxs),
                Text(
                  revokedAt == null
                      ? context.l10n.certificateRevokedMessage
                      : '${context.l10n.certificateRevokedMessage} · '
                            '${CertificateFormatters.date(context, revokedAt)}',
                  style: context.textTheme.bodySmall?.copyWith(color: error),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: context.colorScheme.surface,
        borderRadius: AppRadius.lgRadius,
      ),
      child: Column(
        children: [
          for (var i = 0; i < children.length; i++) ...[
            if (i > 0)
              Divider(height: AppSpacing.md, color: context.colorScheme.outlineVariant),
            children[i],
          ],
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value, this.valueDirection, this.onCopy});

  static const _labelFlex = 2;
  static const _valueFlex = 3;

  final String label;
  final String value;
  final TextDirection? valueDirection;
  final VoidCallback? onCopy;

  @override
  Widget build(BuildContext context) {
    final onCopy = this.onCopy;

    return Row(
      children: [
        Expanded(
          flex: _labelFlex,
          child: Text(
            label,
            style: context.textTheme.bodyMedium?.copyWith(
              color: context.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        SizedBox(width: AppSpacing.sm),
        Expanded(
          flex: _valueFlex,
          child: Row(
            children: [
              Flexible(
                child: Text(
                  value,
                  textDirection: valueDirection,
                  textAlign: context.isRTL ? TextAlign.right : TextAlign.left,
                  style: context.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                ),
              ),
              if (onCopy != null) ...[
                SizedBox(width: AppSpacing.xs),
                IconButton(
                  onPressed: onCopy,
                  tooltip: MaterialLocalizations.of(context).copyButtonLabel,
                  style: IconButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  icon: Icon(
                    LucideIcons.copy,
                    size: AppSizes.iconSm,
                    color: context.colorScheme.primary,
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _DocumentButton extends StatelessWidget {
  const _DocumentButton({required this.label, required this.onPressed});

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: Icon(LucideIcons.fileText, size: AppSizes.iconField),
      label: Text(label),
    );
  }
}
