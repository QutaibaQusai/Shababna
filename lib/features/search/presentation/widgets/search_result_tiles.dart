import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/repositories/search_repository.dart';
import 'search_date_format.dart';
import 'search_result_tile.dart';

class SearchVolunteeringOpportunityTile extends StatelessWidget {
  const SearchVolunteeringOpportunityTile({super.key, required this.result});

  final SearchVolunteeringOpportunityResult result;

  @override
  Widget build(BuildContext context) {
    final isArabic = context.isArabic;
    final typeName = result.typeName(isArabic);
    final dates = searchDateRange(context, result.from, result.to);

    return SearchResultTile(
      leading: SearchImageThumbnail(url: result.imageUrl),
      title: result.title(isArabic),
      subtitle: typeName.isEmpty ? dates : '$typeName · $dates',
      trailing: _TimelineLabel(timeline: result.timeline),
      onTap: () => context.push(AppRoutes.volunteeringOpportunityDetailsPath(result.id)),
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

class _TimelineLabel extends StatelessWidget {
  const _TimelineLabel({required this.timeline});

  final SearchVolunteeringOpportunityTimeline timeline;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colorScheme = context.colorScheme;
    final (label, color) = switch (timeline) {
      SearchVolunteeringOpportunityTimeline.upcoming => (
        l10n.searchVolunteeringOpportunityUpcoming,
        colorScheme.primary,
      ),
      SearchVolunteeringOpportunityTimeline.ongoing => (
        l10n.searchVolunteeringOpportunityOngoing,
        AppColors.successColor,
      ),
      SearchVolunteeringOpportunityTimeline.past => (
        l10n.searchVolunteeringOpportunityPast,
        colorScheme.onSurfaceVariant,
      ),
    };

    return Text(
      label,
      style: context.textTheme.labelSmall?.copyWith(color: color, fontWeight: FontWeight.w600),
    );
  }
}
