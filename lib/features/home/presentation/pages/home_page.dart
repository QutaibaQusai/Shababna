import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/service_locator.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/session/auth_session_cubit.dart';
import '../../../../core/session/auth_status.dart';
import '../../../../core/shared/widgets/app_error_widget.dart';
import '../../../../core/shared/widgets/app_refresh_indicator.dart';
import '../cubit/home_cubit.dart';
import '../cubit/home_state.dart';
import '../widgets/home_background_decoration.dart';
import '../widgets/home_content.dart';
import '../widgets/home_skeleton.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          sl<HomeCubit>()..load(isMember: context.read<AuthSessionCubit>().state.isAuthenticated),
      child: const _HomeView(),
    );
  }
}

class _HomeView extends StatelessWidget {
  const _HomeView();

  static const _switchDuration = Duration(milliseconds: 300);

  @override
  Widget build(BuildContext context) {
    final state = context.watch<HomeCubit>().state;
    final cubit = context.read<HomeCubit>();

    return BlocListener<AuthSessionCubit, AuthStatus>(
      listenWhen: (previous, current) => previous.isAuthenticated != current.isAuthenticated,
      listener: (context, status) => cubit.load(isMember: status.isAuthenticated),
      child: Stack(
        fit: StackFit.expand,
        children: [
          const HomeBackgroundDecoration(),
          AppRefreshIndicator(
            onRefresh: cubit.refresh,
            child: AnimatedSwitcher(
              duration: _switchDuration,
              child: switch (state.status) {
                HomeStatus.loading => HomeSkeleton(
                  key: const ValueKey(HomeStatus.loading),
                  isMember: state.isMember,
                ),
                HomeStatus.failure => _HomeError(
                  key: const ValueKey(HomeStatus.failure),
                  message: state.errorMessage ?? context.l10n.somethingWentWrong,
                  onRetry: cubit.refresh,
                ),
                HomeStatus.ready => HomeContent(key: const ValueKey(HomeStatus.ready), state: state),
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _HomeError extends StatelessWidget {
  const _HomeError({super.key, required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: constraints.maxHeight),
          child: AppErrorWidget(message: message, onRetry: onRetry),
        ),
      ),
    );
  }
}
