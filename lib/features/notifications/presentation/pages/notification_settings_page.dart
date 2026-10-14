import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../core/di/service_locator.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/shared/widgets/app_app_bar.dart';
import '../../../../core/shared/widgets/app_button.dart';
import '../../../../core/shared/widgets/app_error_widget.dart';
import '../../../../core/shared/widgets/app_page_header.dart';
import '../../../../core/shared/widgets/app_switch.dart';
import '../../../../core/shared/widgets/app_toast.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/repositories/notifications_repository.dart';
import '../cubit/notification_settings/notification_settings_cubit.dart';
import '../cubit/notification_settings/notification_settings_state.dart';

class NotificationSettingsPage extends StatelessWidget {
  const NotificationSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<NotificationSettingsCubit>()..load(),
      child: Scaffold(
        appBar: AppAppBar(
          title: context.l10n.notificationSettingsTitle,
          onBack: () => context.pop(),
        ),
        body: const SafeArea(top: false, child: _NotificationSettingsView()),
      ),
    );
  }
}

class _NotificationSettingsView extends StatefulWidget {
  const _NotificationSettingsView();

  @override
  State<_NotificationSettingsView> createState() =>
      _NotificationSettingsViewState();
}

class _NotificationSettingsViewState extends State<_NotificationSettingsView> {
  late final AppLifecycleListener _lifecycle;

  @override
  void initState() {
    super.initState();
    _lifecycle = AppLifecycleListener(
      onResume: () =>
          context.read<NotificationSettingsCubit>().refreshPermission(),
    );
  }

  @override
  void dispose() {
    _lifecycle.dispose();
    super.dispose();
  }

  void _onFeedback(
    BuildContext context,
    NotificationSettingsFeedback feedback,
  ) {
    final l10n = context.l10n;
    switch (feedback) {
      case NotificationSettingsError(:final message):
        AppToast.error(context, message ?? l10n.somethingWentWrong);
      case NotificationTestSent():
        AppToast.success(context, l10n.notificationsTestSent);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final state = context.watch<NotificationSettingsCubit>().state;
    final cubit = context.read<NotificationSettingsCubit>();
    final preferences = state.preferences;

    return BlocListener<NotificationSettingsCubit, NotificationSettingsState>(
      listenWhen: (previous, current) =>
          current.feedback != null && previous.feedback != current.feedback,
      listener: (context, state) => _onFeedback(context, state.feedback!),
      child: switch (state.status) {
        NotificationSettingsStatus.failure => AppErrorWidget(
          message: state.errorMessage ?? l10n.somethingWentWrong,
          onRetry: cubit.load,
        ),
        _ => ListView(
          padding: EdgeInsets.all(AppSpacing.screenMargin),
          children: [
            if (!state.isPermissionGranted) ...[
              _PermissionBanner(
                isBlocked: state.isPermissionBlocked,
                onTurnOn: cubit.requestPermission,
              ),
              SizedBox(height: AppSpacing.md),
            ],
            AppPageHeader(
              title: l10n.notificationSettingsHeaderTitle,
              subtitle: l10n.notificationSettingsSubtitle,
            ),
            SizedBox(height: AppSpacing.md),
            Skeletonizer(
              enabled: preferences == null,
              child: Column(
                children: [
                  for (final preference in NotificationPreference.values)
                    _PreferenceRow(
                      preference: preference,
                      value: preferences?.isEnabled(preference) ?? true,
                      onChanged: preferences == null
                          ? null
                          : () => cubit.toggle(preference),
                    ),
                ],
              ),
            ),
            SizedBox(height: AppSpacing.sm),
            const _GeneralNote(),
            if (kDebugMode) ...[
              SizedBox(height: AppSpacing.lg),
              AppButton.secondary(
                label: l10n.notificationsSendTest,
                onPressed: state.isSendingTest ? null : cubit.sendTest,
              ),
            ],
          ],
        ),
      },
    );
  }
}

class _PreferenceRow extends StatelessWidget {
  const _PreferenceRow({
    required this.preference,
    required this.value,
    required this.onChanged,
  });

  final NotificationPreference preference;
  final bool value;
  final VoidCallback? onChanged;

  (String, String) _texts(AppLocalizations l10n) => switch (preference) {
    NotificationPreference.news => (
      l10n.notificationPrefNews,
      l10n.notificationPrefNewsHint,
    ),
    NotificationPreference.event => (
      l10n.notificationPrefOpportunities,
      l10n.notificationPrefOpportunitiesHint,
    ),
    NotificationPreference.registration => (
      l10n.notificationPrefRegistrations,
      l10n.notificationPrefRegistrationsHint,
    ),
    NotificationPreference.task => (
      l10n.notificationPrefTasks,
      l10n.notificationPrefTasksHint,
    ),
    NotificationPreference.tier => (
      l10n.notificationPrefTier,
      l10n.notificationPrefTierHint,
    ),
    NotificationPreference.certificate => (
      l10n.notificationPrefCertificates,
      l10n.notificationPrefCertificatesHint,
    ),
  };

  @override
  Widget build(BuildContext context) {
    final (title, hint) = _texts(context.l10n);
    final onChanged = this.onChanged;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: context.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: AppSpacing.xxs),
                Text(
                  hint,
                  style: context.textTheme.bodySmall?.copyWith(
                    color: context.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: AppSpacing.sm),
          AppSwitch(
            value: value,
            onChanged: (selected) {
              if (onChanged != null && selected != value) onChanged();
            },
          ),
        ],
      ),
    );
  }
}

class _GeneralNote extends StatelessWidget {
  const _GeneralNote();

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme.onSurfaceVariant;

    return Row(
      children: [
        Icon(LucideIcons.megaphone, size: AppSizes.iconSm, color: color),
        SizedBox(width: AppSpacing.xs),
        Expanded(
          child: Text(
            context.l10n.notificationGeneralNote,
            style: context.textTheme.bodySmall?.copyWith(color: color),
          ),
        ),
      ],
    );
  }
}

class _PermissionBanner extends StatelessWidget {
  const _PermissionBanner({required this.isBlocked, required this.onTurnOn});

  static const _tintAlpha = 0.08;

  final bool isBlocked;
  final VoidCallback onTurnOn;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colorScheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.primary.withValues(alpha: _tintAlpha),
        borderRadius: AppRadius.lgRadius,
      ),
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.sm),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Icon(
                  LucideIcons.bellOff,
                  size: AppSizes.iconField,
                  color: colors.primary,
                ),
                SizedBox(width: AppSpacing.xs),
                Expanded(
                  child: Text(
                    l10n.notificationPermissionOffTitle,
                    style: context.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: AppSpacing.xs),
            Text(
              isBlocked
                  ? l10n.notificationPermissionSettingsHint
                  : l10n.notificationPermissionOffMessage,
              style: context.textTheme.bodySmall?.copyWith(
                color: colors.onSurfaceVariant,
              ),
            ),
            if (!isBlocked) ...[
              SizedBox(height: AppSpacing.sm),
              AppButton.primary(
                label: l10n.notificationPermissionTurnOn,
                onPressed: onTurnOn,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
