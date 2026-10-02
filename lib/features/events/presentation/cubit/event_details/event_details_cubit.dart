import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

import '../../../../../core/error/failures.dart';
import '../../../domain/repositories/events_repository.dart';
import 'event_details_state.dart';

class EventDetailsCubit extends Cubit<EventDetailsState> {
  EventDetailsCubit(this._repository, {required this.id}) : super(const EventDetailsState());

  static const _profileIncompleteCode = 'PROFILE_INCOMPLETE';
  static const _missingFieldsKey = 'missingFields';
  static const _statusChangedCodes = {
    'EVENT_ALREADY_REGISTERED',
    'EVENT_NOT_REGISTERED',
    'EVENT_ALREADY_WITHDRAWN',
    'EVENT_WITHDRAWAL_NOT_ALLOWED',
  };
  static const _issueByCode = {
    'EVENT_REGISTRATION_CLOSED': EventActionIssue.registrationClosed,
    'EVENT_REGISTRATION_REJECTED': EventActionIssue.registrationRejected,
  };

  final EventsRepository _repository;
  final String id;
  final _uuid = const Uuid();
  String? _registerKey;

  Future<void> load() async {
    if (state.isLoading) return;
    emit(state.copyWith(isLoading: true, hasError: false));

    final result = await _repository.getEventById(id);
    if (isClosed) return;

    result.fold(
      (failure) => emit(
        state.event != null
            ? state.copyWith(isLoading: false)
            : EventDetailsState(hasError: true, errorMessage: _messageOf(failure)),
      ),
      (event) => emit(state.copyWith(isLoading: false, event: event)),
    );
  }

  Future<void> register() async {
    if (state.event == null || state.isSubmitting) return;
    final key = _registerKey ??= _uuid.v4();
    emit(state.copyWith(isSubmitting: true));

    final result = await _repository.register(id, idempotencyKey: key);
    if (isClosed) return;

    result.fold(
      (failure) {
        if (failure.code != null) _registerKey = null;
        _handleFailure(failure);
      },
      (registration) {
        _registerKey = null;
        _applyStatus(registration.registrationStatus, EventRegistered(registration.registrationStatus));
      },
    );
  }

  Future<void> withdraw() async {
    if (state.event == null || state.isSubmitting) return;
    emit(state.copyWith(isSubmitting: true));

    final result = await _repository.withdraw(id);
    if (isClosed) return;

    result.fold(
      _handleFailure,
      (registration) => _applyStatus(registration.registrationStatus, const EventWithdrawn()),
    );
  }

  void _applyStatus(EventRegistrationStatus status, EventActionFeedback feedback) {
    emit(state.copyWith(
      isSubmitting: false,
      event: state.event?.copyWith(registrationStatus: status),
      feedback: feedback,
    ));
  }

  void _handleFailure(Failure failure) {
    final code = failure.code;

    if (code == _profileIncompleteCode) {
      emit(state.copyWith(
        isSubmitting: false,
        feedback: EventProfileIncomplete(_missingFields(failure)),
      ));
      return;
    }

    if (_statusChangedCodes.contains(code)) {
      emit(state.copyWith(
        isSubmitting: false,
        feedback: const EventActionBlocked(EventActionIssue.statusChanged),
      ));
      load();
      return;
    }

    final issue = _issueByCode[code];
    emit(state.copyWith(
      isSubmitting: false,
      feedback: issue != null ? EventActionBlocked(issue) : EventActionError(_messageOf(failure)),
    ));
  }

  List<String> _missingFields(Failure failure) {
    final value = failure.extensions[_missingFieldsKey];
    return value is List ? value.whereType<String>().toList() : const [];
  }

  String? _messageOf(Failure failure) =>
      failure is UnexpectedFailure ? null : failure.displayMessage;
}
