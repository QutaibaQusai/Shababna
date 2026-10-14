import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../core/di/service_locator.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/shared/widgets/app_app_bar.dart';
import '../../../../core/shared/widgets/app_error_widget.dart';
import '../../../../core/shared/widgets/app_network_image.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../domain/repositories/notifications_repository.dart';
import '../cubit/notification_details/notification_details_cubit.dart';
import '../widgets/notification_time_text.dart';
import '../widgets/notification_type_icon.dart';

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
        title: context.l10n.notificationsTitle,
        onBack: () => context.pop(),
      ),
      body: SafeArea(
        top: false,
        child: switch (notification) {
          final AppNotification value => _NotificationContent(
            notification: value,
          ),
          null when state.hasError => AppErrorWidget(
            message: state.errorMessage ?? context.l10n.somethingWentWrong,
            onRetry: cubit.load,
          ),
          null => const _NotificationDetailsSkeleton(),
        },
      ),
    );
  }
}

class _NotificationContent extends StatelessWidget {
  const _NotificationContent({required this.notification});

  static const _imageAspectRatio = 16 / 9;
  static const _bodyLineHeight = 1.6;

  final AppNotification notification;

  @override
  Widget build(BuildContext context) {
    final isArabic = context.isArabic;
    final imageUrl = notification.imageUrl;

    return ListView(
      padding: EdgeInsets.all(AppSpacing.screenMargin),
      children: [
        Row(
          children: [
            NotificationTypeIcon(type: notification.type),
            SizedBox(width: AppSpacing.sm),
            NotificationTimeText(createdAt: notification.createdAt),
          ],
        ),
        SizedBox(height: AppSpacing.md),
        Text(
          notification.title(isArabic),
          style: context.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        if (imageUrl != null) ...[
          SizedBox(height: AppSpacing.md),
          ClipRRect(
            borderRadius: AppRadius.lgRadius,
            child: AspectRatio(
              aspectRatio: _imageAspectRatio,
              child: AppNetworkImage(url: imageUrl, size: AppSizes.iconLg * 2),
            ),
          ),
        ],
        SizedBox(height: AppSpacing.md),
        Text(
          notification.body(isArabic),
          style: context.textTheme.bodyLarge?.copyWith(height: _bodyLineHeight),
        ),
      ],
    );
  }
}

class _NotificationDetailsSkeleton extends StatelessWidget {
  const _NotificationDetailsSkeleton();

  static const _bodyLines = 4;

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: true,
      child: ListView(
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.all(AppSpacing.screenMargin),
        children: [
          Row(
            children: [
              Bone.circle(size: AppSizes.notificationIconSize),
              SizedBox(width: AppSpacing.sm),
              const Bone.text(words: 2),
            ],
          ),
          SizedBox(height: AppSpacing.md),
          const Bone.text(words: 5),
          for (var i = 0; i < _bodyLines; i++) ...[
            SizedBox(height: AppSpacing.sm),
            const Bone.text(words: 8),
          ],
        ],
      ),
    );
  }
}
