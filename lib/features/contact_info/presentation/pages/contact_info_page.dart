import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/di/service_locator.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/shared/widgets/app_app_bar.dart';
import '../../../../core/shared/widgets/app_error_widget.dart';
import '../../../../core/shared/widgets/app_refresh_indicator.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../domain/repositories/contact_info_repository.dart';
import '../cubit/contact_info_cubit.dart';
import '../widgets/contact_info_skeleton.dart';
import '../widgets/contact_location_map.dart';

class ContactInfoPage extends StatelessWidget {
  const ContactInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppAppBar(title: context.l10n.profileMenuContactInfo, onBack: () => context.pop()),
      body: const ContactInfoView(),
    );
  }
}

class ContactInfoView extends StatelessWidget {
  const ContactInfoView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ContactInfoCubit>()..loadContactInfo(),
      child: const _ContactInfoBody(),
    );
  }
}

class _ContactInfoBody extends StatelessWidget {
  const _ContactInfoBody();

  Future<void> _launch(Uri uri) async {
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<ContactInfoCubit>().state;
    final margin = AppSpacing.screenMargin;

    return AppRefreshIndicator(
      onRefresh: () => context.read<ContactInfoCubit>().loadContactInfo(),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.fromLTRB(
          margin,
          margin,
          margin,
          margin + MediaQuery.paddingOf(context).bottom,
        ),
        child: state.errorMessage != null && !state.isLoading
            ? AppErrorWidget(
                message: state.errorMessage!,
                onRetry: () => context.read<ContactInfoCubit>().loadContactInfo(),
              )
            : state.isLoading || state.content == null
            ? const ContactInfoSkeleton()
            : _ContactInfoSection(content: state.content!, onLaunch: _launch),
      ),
    );
  }
}

class _ContactInfoSection extends StatelessWidget {
  const _ContactInfoSection({required this.content, required this.onLaunch});

  final ContactInfo content;
  final Future<void> Function(Uri uri) onLaunch;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _InfoRow(
          icon: LucideIcons.mail,
          label: context.l10n.contactInfoEmailLabel,
          value: content.email,
          onTap: () => onLaunch(Uri(scheme: 'mailto', path: content.email)),
        ),
        _InfoRow(
          icon: LucideIcons.mail,
          label: context.l10n.contactInfoComplaintsEmailLabel,
          value: content.complaintsEmail,
          onTap: () => onLaunch(Uri(scheme: 'mailto', path: content.complaintsEmail)),
        ),
        _InfoRow(
          icon: LucideIcons.phone,
          label: context.l10n.contactInfoPhoneLabel,
          value: content.phoneNumber,
          valueDirection: TextDirection.ltr,
          onTap: () => onLaunch(Uri(scheme: 'tel', path: content.phoneNumber)),
        ),
        _InfoRow(
          icon: LucideIcons.phone,
          label: context.l10n.contactInfoComplaintsPhoneLabel,
          value: content.complaintsPhoneNumber,
          valueDirection: TextDirection.ltr,
          onTap: () => onLaunch(Uri(scheme: 'tel', path: content.complaintsPhoneNumber)),
        ),
        _InfoRow(
          icon: LucideIcons.mapPin,
          label: context.l10n.contactInfoAddressLabel,
          value: content.address,
          onTap: () => onLaunch(Uri.parse(content.googleMapsUrl)),
        ),
        SizedBox(height: AppSpacing.xs),
        ContactLocationMap(
          latitude: content.latitude,
          longitude: content.longitude,
          onTap: () => onLaunch(Uri.parse(content.googleMapsUrl)),
        ),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.onTap,
    this.valueDirection,
  });

  final IconData icon;
  final String label;
  final String value;
  final VoidCallback onTap;
  final TextDirection? valueDirection;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: AppSpacing.sm),
        child: Row(
          children: [
            Icon(icon, size: AppSizes.iconMd, color: context.colorScheme.onSurfaceVariant),
            SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: context.textTheme.bodySmall?.copyWith(
                      color: context.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  SizedBox(height: AppSpacing.xxs),
                  Text(value, textDirection: valueDirection, style: context.textTheme.bodyLarge),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
