import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/config/app_assets.dart';
import '../../../../core/di/service_locator.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/shared/widgets/app_app_bar.dart';
import '../../../../core/shared/widgets/app_empty_widget.dart';
import '../../../../core/shared/widgets/app_error_widget.dart';
import '../../../../core/shared/widgets/app_icon_button.dart';
import '../../../../core/shared/widgets/app_refresh_indicator.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../domain/repositories/notifications_repository.dart';
import '../cubit/notifications_list/notifications_list_cubit.dart';
import '../cubit/notifications_list/notifications_list_state.dart';
import '../cubit/unread_count/unread_count_cubit.dart';
import '../navigation/notification_navigator.dart';
import '../widgets/notification_tile.dart';
import '../widgets/notifications_fill_viewport.dart';
import '../widgets/notifications_list_skeleton.dart';
import '../widgets/notifications_load_more_footer.dart';
import '../../../../core/shared/widgets/app_bottom_safe_area.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<NotificationsListCubit>()..loadFirstPage(),
      child: Scaffold(
        appBar: AppAppBar(
          title: context.l10n.notificationsTitle,
          onBack: () => context.pop(),
          actions: [
            AppIconButton(
              icon: LucideIcons.settings,
              semanticLabel: context.l10n.notificationSettingsTitle,
              onPressed: () => context.push(AppRoutes.notificationSettings),
            ),
          ],
        ),
        body: const AppBottomSafeArea(child: _NotificationsView()),
      ),
    );
  }
}

class _NotificationsView extends StatelessWidget {
  const _NotificationsView();

  Future<void> _refresh(BuildContext context) async {
    final unreadCount = context.read<UnreadCountCubit>();
    await context.read<NotificationsListCubit>().refresh();
    await unreadCount.refresh();
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<NotificationsListCubit>().state;
    final cubit = context.read<NotificationsListCubit>();

    return AppRefreshIndicator(
      onRefresh: () => _refresh(context),
      child: switch (state.status) {
        NotificationsListStatus.initial ||
        NotificationsListStatus.loading => const NotificationsListSkeleton(),
        NotificationsListStatus.failure => NotificationsFillViewport(
          child: AppErrorWidget(
            message: state.errorMessage ?? context.l10n.somethingWentWrong,
            onRetry: cubit.loadFirstPage,
          ),
        ),
        NotificationsListStatus.success when state.items.isEmpty =>
          NotificationsFillViewport(
            child: AppEmptyWidget(
              message: context.l10n.notificationsEmptyMessage,
              asset: AppAssets.illustrationEmpty,
            ),
          ),
        NotificationsListStatus.success => _NotificationsList(state: state),
      },
    );
  }
}

class _NotificationsList extends StatelessWidget {
  const _NotificationsList({required this.state});

  static const _loadMoreThreshold = 300.0;

  final NotificationsListState state;

  bool _onScroll(BuildContext context, ScrollNotification notification) {
    final metrics = notification.metrics;
    if (metrics.axis == Axis.vertical &&
        metrics.maxScrollExtent - metrics.pixels <= _loadMoreThreshold) {
      context.read<NotificationsListCubit>().loadMore();
    }
    return false;
  }

  void _open(BuildContext context, AppNotification notification) {
    context.read<NotificationsListCubit>().markRead(notification.id);
    sl<NotificationNavigator>().open(
      notification.asPushMessage,
      wasUnread: !notification.isRead,
    );
  }

  @override
  Widget build(BuildContext context) {
    final items = state.items;

    return NotificationListener<ScrollNotification>(
      onNotification: (notification) => _onScroll(context, notification),
      child: ListView.separated(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.symmetric(vertical: AppSpacing.xs),
        itemCount: items.length + (state.hasNextPage ? 1 : 0),
        separatorBuilder: (_, _) => Divider(
          height: 1,
          indent: AppSpacing.screenMargin,
          endIndent: AppSpacing.screenMargin,
        ),
        itemBuilder: (context, index) {
          if (index == items.length) {
            return NotificationsLoadMoreFooter(
              failed: state.loadMoreFailed,
              onRetry: context.read<NotificationsListCubit>().retryLoadMore,
            );
          }
          final notification = items[index];
          return NotificationTile(
            notification: notification,
            onTap: () => _open(context, notification),
          );
        },
      ),
    );
  }
}
