import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/service_locator.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/shared/widgets/app_app_bar.dart';
import '../../../../core/shared/widgets/app_bottom_safe_area.dart';
import '../../../../core/shared/widgets/app_error_widget.dart';
import '../../../../core/shared/widgets/app_refresh_indicator.dart';
import '../cubit/dashboard_cubit.dart';
import '../cubit/dashboard_state.dart';
import '../widgets/dashboard_content.dart';
import '../widgets/dashboard_fill_viewport.dart';
import '../widgets/dashboard_skeleton.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<DashboardCubit>()..load(),
      child: Scaffold(
        appBar: AppAppBar(
          title: context.l10n.myImpactTitle,
          onBack: () => context.pop(),
        ),
        body: const AppBottomSafeArea(child: _DashboardView()),
      ),
    );
  }
}

class _DashboardView extends StatelessWidget {
  const _DashboardView();

  @override
  Widget build(BuildContext context) {
    final state = context.watch<DashboardCubit>().state;
    final cubit = context.read<DashboardCubit>();
    final dashboard = state.dashboard;

    return AppRefreshIndicator(
      onRefresh: cubit.refresh,
      child: switch (state.status) {
        DashboardStatus.initial ||
        DashboardStatus.loading => const DashboardSkeleton(),
        DashboardStatus.failure => DashboardFillViewport(
          child: AppErrorWidget(
            message: state.errorMessage ?? context.l10n.somethingWentWrong,
            onRetry: cubit.load,
          ),
        ),
        DashboardStatus.success when dashboard != null => DashboardContent(
          dashboard: dashboard,
        ),
        DashboardStatus.success => const DashboardSkeleton(),
      },
    );
  }
}
