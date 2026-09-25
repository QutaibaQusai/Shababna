import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/config/app_share_links.dart';
import '../../../../core/di/service_locator.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/shared/widgets/app_app_bar.dart';
import '../../../../core/shared/widgets/app_empty_widget.dart';
import '../../../../core/shared/widgets/app_error_widget.dart';
import '../../../../core/shared/widgets/app_refresh_indicator.dart';
import '../../../../core/shared/widgets/share_icon_button.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../domain/repositories/social_media_repository.dart';
import '../cubit/social_media_cubit.dart';
import '../widgets/social_media_skeleton.dart';

class SocialMediaPage extends StatelessWidget {
  const SocialMediaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<SocialMediaCubit>()..loadSocialMediaLinks(),
      child: const _SocialMediaView(),
    );
  }
}

class _SocialMediaView extends StatelessWidget {
  const _SocialMediaView();

  void _openWebView(BuildContext context, String rawUrl, String title) {
    final normalizedUrl = rawUrl.startsWith('http') ? rawUrl : 'https://$rawUrl';
    context.pushNamed(
      AppRoutes.webViewName,
      queryParameters: {'url': normalizedUrl, 'title': title},
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<SocialMediaCubit>().state;

    return Scaffold(
      appBar: AppAppBar(
        title: context.l10n.profileMenuSocialMedia,
        onBack: () => context.pop(),
        actions: [ShareIconButton(path: AppShareLinks.socialMedia)],
      ),
      body: AppRefreshIndicator(
        onRefresh: () => context.read<SocialMediaCubit>().loadSocialMediaLinks(),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.all(AppSpacing.screenMargin),
          child: state.errorMessage != null && !state.isLoading
              ? AppErrorWidget(
                  message: state.errorMessage!,
                  onRetry: () => context.read<SocialMediaCubit>().loadSocialMediaLinks(),
                )
              : state.isLoading || state.links == null
                  ? const SocialMediaSkeleton()
                  : state.links!.hasAnyLink
                      ? _SocialMediaSection(links: state.links!, onOpen: _openWebView)
                      : AppEmptyWidget(message: context.l10n.socialMediaEmptyMessage),
        ),
      ),
    );
  }
}

class _SocialMediaSection extends StatelessWidget {
  const _SocialMediaSection({required this.links, required this.onOpen});

  final SocialMediaLinks links;
  final void Function(BuildContext context, String url, String title) onOpen;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (links.facebook != null)
          _SocialRow(
            asset: 'assets/images/icon_facebook.svg',
            label: context.l10n.socialMediaFacebook,
            onTap: () => onOpen(context, links.facebook!, context.l10n.socialMediaFacebook),
          ),
        if (links.instagram != null)
          _SocialRow(
            asset: 'assets/images/icon_instagram.svg',
            label: context.l10n.socialMediaInstagram,
            onTap: () => onOpen(context, links.instagram!, context.l10n.socialMediaInstagram),
          ),
        if (links.twitter != null)
          _SocialRow(
            asset: 'assets/images/icon_twitter.svg',
            label: context.l10n.socialMediaTwitter,
            onTap: () => onOpen(context, links.twitter!, context.l10n.socialMediaTwitter),
          ),
        if (links.linkedIn != null)
          _SocialRow(
            asset: 'assets/images/icon_linkedin.svg',
            label: context.l10n.socialMediaLinkedIn,
            onTap: () => onOpen(context, links.linkedIn!, context.l10n.socialMediaLinkedIn),
          ),
        if (links.youTube != null)
          _SocialRow(
            asset: 'assets/images/icon_youtube.svg',
            label: context.l10n.socialMediaYoutube,
            onTap: () => onOpen(context, links.youTube!, context.l10n.socialMediaYoutube),
          ),
        if (links.threads != null)
          _SocialRow(
            icon: LucideIcons.atSign,
            label: context.l10n.socialMediaThreads,
            onTap: () => onOpen(context, links.threads!, context.l10n.socialMediaThreads),
          ),
        if (links.snapchat != null)
          _SocialRow(
            icon: LucideIcons.ghost,
            label: context.l10n.socialMediaSnapchat,
            onTap: () => onOpen(context, links.snapchat!, context.l10n.socialMediaSnapchat),
          ),
        if (links.tikTok != null)
          _SocialRow(
            icon: LucideIcons.music2,
            label: context.l10n.socialMediaTikTok,
            onTap: () => onOpen(context, links.tikTok!, context.l10n.socialMediaTikTok),
          ),
      ],
    );
  }
}

class _SocialRow extends StatelessWidget {
  const _SocialRow({required this.label, required this.onTap, this.asset, this.icon});

  final String label;
  final VoidCallback onTap;
  final String? asset;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: AppSpacing.sm),
        child: Row(
          children: [
            SizedBox(
              width: AppSizes.iconMd,
              height: AppSizes.iconMd,
              child: asset != null
                  ? SvgPicture.asset(asset!)
                  : Icon(icon, size: AppSizes.iconMd, color: context.colorScheme.onSurfaceVariant),
            ),
            SizedBox(width: AppSpacing.sm),
            Expanded(child: Text(label, style: context.textTheme.bodyLarge)),
            Icon(
              context.isRTL ? LucideIcons.chevronLeft : LucideIcons.chevronRight,
              size: AppSizes.iconSm,
              color: context.colorScheme.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }
}
