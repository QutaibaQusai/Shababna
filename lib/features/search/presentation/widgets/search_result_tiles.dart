import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../domain/repositories/search_repository.dart';
import 'search_date_format.dart';
import 'search_result_tile.dart';

class SearchEventTile extends StatelessWidget {
  const SearchEventTile({super.key, required this.result});

  final SearchEventResult result;

  @override
  Widget build(BuildContext context) {
    final isArabic = context.isArabic;
    final typeName = result.typeName(isArabic);
    final dates = searchDateRange(context, result.from, result.to);

    return SearchResultTile(
      leading: SearchImageThumbnail(url: result.imageUrl),
      title: result.title(isArabic),
      subtitle: typeName.isEmpty ? dates : '$typeName · $dates',
      trailing: _TimelinePill(timeline: result.timeline),
      onTap: () => context.push(AppRoutes.eventDetailsPath(result.id)),
    );
  }
}

class SearchNewsTile extends StatelessWidget {
  const SearchNewsTile({super.key, required this.result});

  final SearchNewsResult result;

  @override
  Widget build(BuildContext context) {
    return SearchResultTile(
      leading: SearchImageThumbnail(url: result.imageUrl),
      title: result.title(context.isArabic),
      subtitle: searchDate(context, result.date),
      onTap: () => context.push(AppRoutes.newsDetailsPath(result.id)),
    );
  }
}

class SearchFaqTile extends StatelessWidget {
  const SearchFaqTile({super.key, required this.result});

  final SearchFaqResult result;

  @override
  Widget build(BuildContext context) {
    final isArabic = context.isArabic;

    return SearchResultTile(
      leading: const SearchIconThumbnail(icon: LucideIcons.messageCircleQuestionMark),
      title: result.question(isArabic),
      subtitle: result.topicName(isArabic),
      onTap: () => context.push(
        AppRoutes.assistantQuestionPath(topicId: result.topicId, questionId: result.id),
      ),
    );
  }
}

class _TimelinePill extends StatelessWidget {
  const _TimelinePill({required this.timeline});

  static const _tintAlpha = 0.12;

  final SearchEventTimeline timeline;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colorScheme = context.colorScheme;
    final (label, color) = switch (timeline) {
      SearchEventTimeline.upcoming => (l10n.searchEventUpcoming, colorScheme.primary),
      SearchEventTimeline.ongoing => (l10n.searchEventOngoing, AppColors.successColor),
      SearchEventTimeline.past => (l10n.searchEventPast, colorScheme.onSurfaceVariant),
    };

    return DecoratedBox(
      decoration: BoxDecoration(
        color: color.withValues(alpha: _tintAlpha),
        borderRadius: AppRadius.pillRadius,
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: AppSpacing.xs, vertical: AppSpacing.xxs / 2),
        child: Text(
          label,
          style: context.textTheme.labelSmall?.copyWith(color: color, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
