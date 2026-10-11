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
import '../../domain/repositories/volunteering_opportunities_repository.dart';
import '../cubit/volunteering_opportunity_details/volunteering_opportunity_details_cubit.dart';
import '../cubit/volunteering_opportunity_details/volunteering_opportunity_details_state.dart';
import '../widgets/volunteering_opportunity_details/volunteering_opportunity_details_content.dart';
import '../widgets/volunteering_opportunity_details/volunteering_opportunity_details_skeleton.dart';
import '../widgets/volunteering_opportunity_details/volunteering_opportunity_registration_bar.dart';
import '../../../profile/presentation/widgets/missing_fields/profile_incomplete_sheet.dart';
import '../widgets/shared/volunteering_opportunity_fill_viewport.dart';

class VolunteeringOpportunityDetailsPage extends StatelessWidget {
  const VolunteeringOpportunityDetailsPage({super.key, required this.id});

  final String id;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<VolunteeringOpportunityDetailsCubit>(param1: id)..load(),
      child: const _VolunteeringOpportunityDetailsView(),
    );
  }
}

class _VolunteeringOpportunityDetailsView extends StatelessWidget {
  const _VolunteeringOpportunityDetailsView();

  void _onFeedback(BuildContext context, VolunteeringOpportunityActionFeedback feedback) {
    final l10n = context.l10n;

    switch (feedback) {
      case VolunteeringOpportunityRegistered(
        status: VolunteeringOpportunityRegistrationStatus.approved,
      ):
        AppToast.success(context, l10n.volunteeringOpportunityRegisteredApprovedMessage);
      case VolunteeringOpportunityRegistered(
        status: VolunteeringOpportunityRegistrationStatus.rejected,
      ):
        AppToast.warning(context, l10n.volunteeringOpportunityRegistrationRejectedMessage);
      case VolunteeringOpportunityRegistered():
        AppToast.info(context, l10n.volunteeringOpportunityRegisteredPendingMessage);
      case VolunteeringOpportunityWithdrawn():
        AppToast.info(context, l10n.volunteeringOpportunityWithdrawnMessage);
      case VolunteeringOpportunityProfileIncomplete(:final missingFields):
        showProfileIncompleteSheet(context, missingFields);
      case VolunteeringOpportunityActionBlocked(:final issue):
        switch (issue) {
          case VolunteeringOpportunityActionIssue.registrationClosed:
            AppToast.warning(context, l10n.volunteeringOpportunityRegistrationClosedMessage);
          case VolunteeringOpportunityActionIssue.registrationRejected:
            AppToast.warning(context, l10n.volunteeringOpportunityRegistrationRejectedMessage);
          case VolunteeringOpportunityActionIssue.statusChanged:
            AppToast.info(context, l10n.volunteeringOpportunityStatusChangedMessage);
        }
      case VolunteeringOpportunityActionError(:final message):
        AppToast.error(context, message ?? l10n.somethingWentWrong);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<VolunteeringOpportunityDetailsCubit>().state;
    final cubit = context.read<VolunteeringOpportunityDetailsCubit>();
    final volunteeringOpportunity = state.volunteeringOpportunity;

    return MultiBlocListener(
      listeners: [
        BlocListener<VolunteeringOpportunityDetailsCubit, VolunteeringOpportunityDetailsState>(
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
            title: context.l10n.navVolunteeringOpportunities,
            onBack: () => context.pop(),
            actions: [
              ShareIconButton(path: AppShareLinks.volunteeringOpportunityDetails(cubit.id)),
            ],
          ),
          body: volunteeringOpportunity != null
              ? VolunteeringOpportunityDetailsContent(
                  volunteeringOpportunity: volunteeringOpportunity,
                )
              : _placeholder(context, state, cubit),
          bottomNavigationBar: const VolunteeringOpportunityRegistrationBar(),
        ),
      ),
    );
  }

  Widget _placeholder(
    BuildContext context,
    VolunteeringOpportunityDetailsState state,
    VolunteeringOpportunityDetailsCubit cubit,
  ) {
    if (state.hasError) {
      return VolunteeringOpportunityFillViewport(
        child: AppErrorWidget(
          message: state.errorMessage ?? context.l10n.somethingWentWrong,
          onRetry: cubit.load,
        ),
      );
    }
    return const VolunteeringOpportunityDetailsSkeleton();
  }
}
