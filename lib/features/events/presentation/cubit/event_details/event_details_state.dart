import 'package:equatable/equatable.dart';

import '../../../domain/repositories/events_repository.dart';

enum EventActionIssue { registrationClosed, registrationRejected, statusChanged }

sealed class EventActionFeedback extends Equatable {
  const EventActionFeedback();

  @override
  List<Object?> get props => [];
}

class EventRegistered extends EventActionFeedback {
  const EventRegistered(this.status);

  final EventRegistrationStatus status;

  @override
  List<Object?> get props => [status];
}

class EventWithdrawn extends EventActionFeedback {
  const EventWithdrawn();
}

class EventProfileIncomplete extends EventActionFeedback {
  const EventProfileIncomplete(this.missingFields);

  final List<String> missingFields;

  @override
  List<Object?> get props => [missingFields];
}

class EventActionBlocked extends EventActionFeedback {
  const EventActionBlocked(this.issue);

  final EventActionIssue issue;

  @override
  List<Object?> get props => [issue];
}

class EventActionError extends EventActionFeedback {
  const EventActionError(this.message);

  final String? message;

  @override
  List<Object?> get props => [message];
}

class EventDetailsState extends Equatable {
  const EventDetailsState({
    this.isLoading = false,
    this.event,
    this.hasError = false,
    this.errorMessage,
    this.isSubmitting = false,
    this.feedback,
  });

  final bool isLoading;
  final EventDetails? event;
  final bool hasError;
  final String? errorMessage;
  final bool isSubmitting;
  final EventActionFeedback? feedback;

  EventDetailsState copyWith({
    bool? isLoading,
    EventDetails? event,
    bool? hasError,
    String? errorMessage,
    bool? isSubmitting,
    EventActionFeedback? feedback,
  }) {
    return EventDetailsState(
      isLoading: isLoading ?? this.isLoading,
      event: event ?? this.event,
      hasError: hasError ?? this.hasError,
      errorMessage: errorMessage,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      feedback: feedback,
    );
  }

  @override
  List<Object?> get props => [isLoading, event, hasError, errorMessage, isSubmitting, feedback];
}
