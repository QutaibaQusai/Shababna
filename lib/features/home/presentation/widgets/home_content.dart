import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../cubit/home_cubit.dart';
import '../cubit/home_state.dart';
import 'slider/home_banner_carousel.dart';
import 'whats_on/home_date_strip.dart';
import 'whats_on/home_day_events.dart';
import 'suggested/home_events_row.dart';
import 'greeting/home_greeting.dart';
import 'impact/home_impact_card.dart';
import 'news/home_news_list.dart';
import 'shared/home_section_header.dart';
import 'tasks/home_tasks_list.dart';

class HomeContent extends StatelessWidget {
  const HomeContent({super.key, required this.state});

  final HomeState state;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final cubit = context.read<HomeCubit>();
    final feed = state.feed;
    final impact = feed.impact;
    final isMember = state.isMember;
    final now = DateTime.now();

    final sections = <Widget>[
      HomeGreeting(isMember: isMember, fullName: impact?.fullName(context.isArabic)),
      if (isMember && feed.slides.isNotEmpty) HomeBannerCarousel(slides: feed.slides),
      if (isMember && impact != null)
        _Section(
          header: HomeSectionHeader(title: l10n.homeImpactTitle),
          child: HomeImpactCard(impact: impact),
        ),
      if (isMember && feed.openTasks.isNotEmpty)
        _Section(
          header: HomeSectionHeader(title: l10n.homeTasksTitle),
          child: HomeTasksList(tasks: feed.openTasks),
        ),
      if (feed.featuredEvents.isNotEmpty)
        _Section(
          header: HomeSectionHeader(
            title: isMember ? l10n.homeSuggestedTitle : l10n.homeUpcomingTitle,
          ),
          child: HomeEventsRow(events: feed.featuredEvents),
        ),
      _Section(
        header: HomeSectionHeader(title: l10n.homeWhatsOnTitle),
        child: Column(
          children: [
            HomeDateStrip(
              today: DateTime(now.year, now.month, now.day),
              selected: state.selectedDay,
              onSelected: cubit.selectDay,
            ),
            SizedBox(height: AppSpacing.sm),
            HomeDayEvents(events: feed.dayEvents, isLoading: state.isDayLoading),
          ],
        ),
      ),
      if (feed.news.isNotEmpty)
        _Section(
          header: HomeSectionHeader(title: l10n.homeNewsTitle),
          child: HomeNewsList(news: feed.news),
        ),
    ];

    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.only(
        top: AppSpacing.sm,
        bottom: AppSpacing.screenMargin + MediaQuery.paddingOf(context).bottom,
      ),
      children: [
        for (var i = 0; i < sections.length; i++) ...[
          if (i > 0) SizedBox(height: AppSpacing.md),
          sections[i],
        ],
      ],
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.header, required this.child});

  final Widget header;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        header,
        SizedBox(height: AppSpacing.sm),
        child,
      ],
    );
  }
}
