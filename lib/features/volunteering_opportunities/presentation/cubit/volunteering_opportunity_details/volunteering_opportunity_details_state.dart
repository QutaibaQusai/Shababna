import 'package:equatable/equatable.dart';

import '../../../domain/repositories/volunteering_opportunities_repository.dart';

enum VolunteeringOpportunityActionIssue { registrationClosed, registrationRejected, statusChanged }

sealed class VolunteeringOpportunityActionFeedback extends Equatable {
  const VolunteeringOpportunityActionFeedback();

  @override
  List<Object?> get props => [];
}

class VolunteeringOpportunityRegistered extends VolunteeringOpportunityActionFeedback {
  const VolunteeringOpportunityRegistered(this.status);

  final VolunteeringOpportunityRegistrationStatus status;

  @override
  List<Object?> get props => [status];
}

class VolunteeringOpportunityWithdrawn extends VolunteeringOpportunityActionFeedback {
  const VolunteeringOpportunityWithdrawn();
}

class VolunteeringOpportunityProfileIncomplete extends VolunteeringOpportunityActionFeedback {
  const VolunteeringOpportunityProfileIncomplete(this.missingFields);

  final List<String> missingFields;

  @override
  List<Object?> get props => [missingFields];
}

class VolunteeringOpportunityActionBlocked extends VolunteeringOpportunityActionFeedback {
  const VolunteeringOpportunityActionBlocked(this.issue);

  final VolunteeringOpportunityActionIssue issue;

  @override
  List<Object?> get props => [issue];
}

class VolunteeringOpportunityActionError extends VolunteeringOpportunityActionFeedback {
  const VolunteeringOpportunityActionError(this.message);

  final String? message;

  @override
  List<Object?> get props => [message];
}

class VolunteeringOpportunityDetailsState extends Equatable {
  const VolunteeringOpportunityDetailsState({
    this.isLoading = false,
    this.volunteeringOpportunity,
    this.hasError = false,
    this.errorMessage,
    this.isSubmitting = false,
    this.feedback,
  });

  final bool isLoading;
  final VolunteeringOpportunityDetails? volunteeringOpportunity;
  final bool hasError;
  final String? errorMessage;
  final bool isSubmitting;
  final VolunteeringOpportunityActionFeedback? feedback;

  VolunteeringOpportunityDetailsState copyWith({
    bool? isLoading,
    VolunteeringOpportunityDetails? volunteeringOpportunity,
    bool? hasError,
    String? errorMessage,
    bool? isSubmitting,
    VolunteeringOpportunityActionFeedback? feedback,
  }) {
    return VolunteeringOpportunityDetailsState(
      isLoading: isLoading ?? this.isLoading,
      volunteeringOpportunity: volunteeringOpportunity ?? this.volunteeringOpportunity,
      hasError: hasError ?? this.hasError,
      errorMessage: errorMessage,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      feedback: feedback,
    );
  }

  @override
  List<Object?> get props => [
    isLoading,
    volunteeringOpportunity,
    hasError,
    errorMessage,
    isSubmitting,
    feedback,
  ];
}
