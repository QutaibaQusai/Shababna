import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/config/app_share_links.dart';
import '../../../../core/di/service_locator.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/session/auth_session_cubit.dart';
import '../../../../core/session/auth_status.dart';
import '../../../../core/shared/widgets/app_app_bar.dart';
import '../../../../core/shared/widgets/app_error_widget.dart';
import '../../../../core/shared/widgets/app_loading_overlay.dart';
import '../../../../core/shared/widgets/app_toast.dart';
import '../../../../core/shared/widgets/share_icon_button.dart';
import '../../domain/repositories/events_repository.dart';
import '../cubit/event_details/event_details_cubit.dart';
import '../cubit/event_details/event_details_state.dart';
import '../widgets/event_details/event_details_content.dart';
import '../widgets/event_details/event_details_skeleton.dart';
import '../widgets/event_details/event_registration_bar.dart';
import '../../../profile/presentation/widgets/missing_fields/profile_incomplete_sheet.dart';
import '../widgets/shared/event_fill_viewport.dart';

class EventDetailsPage extends StatelessWidget {
  const EventDetailsPage({super.key, required this.id});

  final String id;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<EventDetailsCubit>(param1: id)..load(),
      child: const _EventDetailsView(),
    );
  }
}

class _EventDetailsView extends StatelessWidget {
  const _EventDetailsView();

  void _onFeedback(BuildContext context, EventActionFeedback feedback) {
    final l10n = context.l10n;

    switch (feedback) {
      case EventRegistered(status: EventRegistrationStatus.approved):
        AppToast.success(context, l10n.eventRegisteredApprovedMessage);
      case EventRegistered(status: EventRegistrationStatus.rejected):
        AppToast.warning(context, l10n.eventRegistrationRejectedMessage);
      case EventRegistered():
        AppToast.info(context, l10n.eventRegisteredPendingMessage);
      case EventWithdrawn():
        AppToast.info(context, l10n.eventWithdrawnMessage);
      case EventProfileIncomplete(:final missingFields):
        showProfileIncompleteSheet(context, missingFields);
      case EventActionBlocked(:final issue):
        switch (issue) {
          case EventActionIssue.registrationClosed:
            AppToast.warning(context, l10n.eventRegistrationClosedMessage);
          case EventActionIssue.registrationRejected:
            AppToast.warning(context, l10n.eventRegistrationRejectedMessage);
          case EventActionIssue.statusChanged:
            AppToast.info(context, l10n.eventStatusChangedMessage);
        }
      case EventActionError(:final message):
        AppToast.error(context, message ?? l10n.somethingWentWrong);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<EventDetailsCubit>().state;
    final cubit = context.read<EventDetailsCubit>();
    final event = state.event;

    return MultiBlocListener(
      listeners: [
        BlocListener<EventDetailsCubit, EventDetailsState>(
          listenWhen: (previous, current) =>
              current.feedback != null && previous.feedback != current.feedback,
          listener: (context, state) => _onFeedback(context, state.feedback!),
        ),
        BlocListener<AuthSessionCubit, AuthStatus>(
          listenWhen: (previous, current) => previous != current && current.isAuthenticated,
          listener: (context, _) => cubit.load(),
        ),
      ],
      child: AppLoadingOverlay(
        isLoading: state.isSubmitting,
        child: Scaffold(
          appBar: AppAppBar(
            title: context.l10n.navEvents,
            onBack: () => context.pop(),
            actions: [ShareIconButton(path: AppShareLinks.eventDetails(cubit.id))],
          ),
          body: event != null
              ? EventDetailsContent(event: event)
              : _placeholder(context, state, cubit),
          bottomNavigationBar: const EventRegistrationBar(),
        ),
      ),
    );
  }

  Widget _placeholder(BuildContext context, EventDetailsState state, EventDetailsCubit cubit) {
    if (state.hasError) {
      return EventFillViewport(
        child: AppErrorWidget(
          message: state.errorMessage ?? context.l10n.somethingWentWrong,
          onRetry: cubit.load,
        ),
      );
    }
    return const EventDetailsSkeleton();
  }
}
