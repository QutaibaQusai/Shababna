import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../core/config/app_share_links.dart';
import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../core/shared/widgets/app_icon_button.dart';
import '../../../../../core/shared/widgets/app_network_image.dart';
import '../../../../../core/shared/widgets/share_icon_button.dart';
import '../../../../../core/theme/app_sizes.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../domain/repositories/news_repository.dart';
import '../shared/news_date_text.dart';

class NewsDetailsContent extends StatefulWidget {
  const NewsDetailsContent({super.key, required this.article});

  final NewsArticle article;

  @override
  State<NewsDetailsContent> createState() => _NewsDetailsContentState();
}

class _NewsDetailsContentState extends State<NewsDetailsContent> {
  static const _expandedHeight = 260.0;
  static const _bodyLineHeight = 1.6;
  static const _titleFadeDuration = Duration(milliseconds: 200);

  final _scrollController = ScrollController();
  bool _isCollapsed = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    final collapsed = _scrollController.offset > _expandedHeight - kToolbarHeight;
    if (collapsed != _isCollapsed) setState(() => _isCollapsed = collapsed);
  }

  Future<void> _openLink(String? url) async {
    final uri = url == null ? null : Uri.tryParse(url);
    if (uri == null) return;
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    final article = widget.article;
    final isArabic = context.isArabic;

    return CustomScrollView(
      controller: _scrollController,
      slivers: [
        SliverAppBar(
          pinned: true,
          expandedHeight: _expandedHeight,
          automaticallyImplyLeading: false,
          leading: const NewsBackButton(),
          leadingWidth: AppSizes.iconButtonSize + AppSpacing.screenMargin,
          title: AnimatedOpacity(
            opacity: _isCollapsed ? 1 : 0,
            duration: _titleFadeDuration,
            child: Text(article.title(isArabic), maxLines: 1, overflow: TextOverflow.ellipsis),
          ),
          actions: [
            ShareIconButton(path: AppShareLinks.newsDetails(article.id)),
            SizedBox(width: AppSpacing.screenMargin),
          ],
          flexibleSpace: FlexibleSpaceBar(
            collapseMode: CollapseMode.parallax,
            background: AppNetworkImage(url: article.imageUrl, size: AppSizes.iconLg * 2),
          ),
        ),
        SliverPadding(
          padding: EdgeInsets.all(AppSpacing.screenMargin),
          sliver: SliverList.list(
            children: [
              NewsDateText(date: article.date),
              SizedBox(height: AppSpacing.xs),
              Text(
                article.title(isArabic),
                style: context.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: AppSpacing.sm),
              Html(
                data: article.description(isArabic),
                onLinkTap: (url, attributes, element) => _openLink(url),
                style: {
                  'body': Style(
                    margin: Margins.zero,
                    padding: HtmlPaddings.zero,
                    fontSize: FontSize(context.textTheme.bodyLarge?.fontSize ?? 16),
                    lineHeight: const LineHeight(_bodyLineHeight),
                    color: context.colorScheme.onSurface,
                  ),
                  'a': Style(color: context.colorScheme.primary),
                },
              ),
              SizedBox(height: AppSpacing.lg),
            ],
          ),
        ),
      ],
    );
  }
}

class NewsBackButton extends StatelessWidget {
  const NewsBackButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.only(start: AppSpacing.screenMargin),
      child: Center(
        child: AppIconButton(
          icon: context.isRTL ? LucideIcons.chevronRight : LucideIcons.chevronLeft,
          onPressed: () => context.pop(),
        ),
      ),
    );
  }
}
