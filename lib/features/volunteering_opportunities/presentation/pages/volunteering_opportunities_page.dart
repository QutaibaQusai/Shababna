import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/service_locator.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/shared/widgets/app_empty_widget.dart';
import '../../../../core/shared/widgets/app_error_widget.dart';
import '../../../../core/shared/widgets/app_refresh_indicator.dart';
import '../cubit/volunteering_opportunity_types/volunteering_opportunity_types_cubit.dart';
import '../cubit/volunteering_opportunities_date_filter/volunteering_opportunities_date_filter_cubit.dart';
import '../cubit/volunteering_opportunity_types/volunteering_opportunity_types_state.dart';
import '../cubit/volunteering_opportunities_list/volunteering_opportunities_list_cubit.dart';
import '../cubit/volunteering_opportunities_list/volunteering_opportunities_list_state.dart';
import '../widgets/date_filter/volunteering_opportunities_date_filter_label.dart';
import '../widgets/volunteering_opportunities_list/volunteering_opportunity_type_tabs.dart';
import '../widgets/volunteering_opportunities_list/volunteering_opportunities_list_content.dart';
import '../widgets/volunteering_opportunities_list/volunteering_opportunities_list_skeleton.dart';
import '../widgets/shared/volunteering_opportunity_fill_viewport.dart';

class VolunteeringOpportunitiesPage extends StatelessWidget {
  const VolunteeringOpportunitiesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<VolunteeringOpportunitiesListCubit>()..loadFirstPage()),
        BlocProvider(create: (_) => sl<VolunteeringOpportunityTypesCubit>()..load()),
      ],
      child: const _VolunteeringOpportunitiesView(),
    );
  }
}

class _VolunteeringOpportunitiesView extends StatelessWidget {
  const _VolunteeringOpportunitiesView();

  void _resetHiddenType(BuildContext context, VolunteeringOpportunityTypesState typesState) {
    final cubit = context.read<VolunteeringOpportunitiesListCubit>();
    final typeId = cubit.state.typeId;
    if (typeId == null) return;
    final isVisible = typesState.visibleTypes.any((type) => type.id == typeId);
    if (!isVisible) cubit.selectType(null);
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<VolunteeringOpportunitiesListCubit>().state;
    final cubit = context.read<VolunteeringOpportunitiesListCubit>();
    final typesCubit = context.read<VolunteeringOpportunityTypesCubit>();

    final date = state.date;

    return MultiBlocListener(
      listeners: [
        BlocListener<VolunteeringOpportunityTypesCubit, VolunteeringOpportunityTypesState>(
          listenWhen: (previous, current) =>
              previous.types != current.types &&
              current.status == VolunteeringOpportunityTypesStatus.success,
          listener: _resetHiddenType,
        ),
        BlocListener<VolunteeringOpportunitiesDateFilterCubit, DateTime?>(
          bloc: sl<VolunteeringOpportunitiesDateFilterCubit>(),
          listener: (context, date) => cubit.selectDate(date),
        ),
      ],
      child: Column(
        children: [
          const VolunteeringOpportunityTypeTabs(),
          if (date != null) VolunteeringOpportunitiesDateFilterLabel(date: date),
          Expanded(
            child: AppRefreshIndicator(
              onRefresh: () => Future.wait([cubit.refresh(), typesCubit.load()]),
              child: switch (state.status) {
                VolunteeringOpportunitiesListStatus.initial ||
                VolunteeringOpportunitiesListStatus.loading =>
                  const VolunteeringOpportunitiesListSkeleton(),
                VolunteeringOpportunitiesListStatus.failure => VolunteeringOpportunityFillViewport(
                  child: AppErrorWidget(
                    message: state.errorMessage ?? context.l10n.somethingWentWrong,
                    onRetry: cubit.loadFirstPage,
                  ),
                ),
                VolunteeringOpportunitiesListStatus.success when state.items.isEmpty =>
                  VolunteeringOpportunityFillViewport(
                    child: AppEmptyWidget(
                      message: date == null
                          ? context.l10n.volunteeringOpportunitiesEmptyMessage
                          : context.l10n.volunteeringOpportunitiesNoVolunteeringOpportunitiesOnDay,
                    ),
                  ),
                VolunteeringOpportunitiesListStatus.success => VolunteeringOpportunitiesListContent(
                  state: state,
                ),
              },
            ),
          ),
        ],
      ),
    );
  }
}
