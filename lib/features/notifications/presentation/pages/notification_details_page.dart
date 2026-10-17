import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/service_locator.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/shared/widgets/app_app_bar.dart';
import '../../../../core/shared/widgets/app_error_widget.dart';
import '../../domain/repositories/notifications_repository.dart';
import '../cubit/notification_details/notification_details_cubit.dart';
import '../widgets/notification_details_content.dart';
import '../widgets/notification_details_skeleton.dart';
import '../../../../core/shared/widgets/app_bottom_safe_area.dart';

class NotificationDetailsPage extends StatelessWidget {
  const NotificationDetailsPage({super.key, required this.id});

  final String id;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<NotificationDetailsCubit>(param1: id)..load(),
      child: const _NotificationDetailsView(),
    );
  }
}

class _NotificationDetailsView extends StatelessWidget {
  const _NotificationDetailsView();

  @override
  Widget build(BuildContext context) {
    final state = context.watch<NotificationDetailsCubit>().state;
    final cubit = context.read<NotificationDetailsCubit>();
    final notification = state.notification;

    return Scaffold(
      appBar: AppAppBar(
        title: context.l10n.notificationDetailsTitle,
        onBack: () => context.pop(),
      ),
      body: AppBottomSafeArea(
        child: switch (notification) {
          final AppNotification value => NotificationDetailsContent(
            notification: value,
          ),
          null when state.hasError => AppErrorWidget(
            message: state.errorMessage ?? context.l10n.somethingWentWrong,
            onRetry: cubit.load,
          ),
          null => const NotificationDetailsSkeleton(),
        },
      ),
    );
  }
}
