import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

import '../../../../../core/error/failures.dart';
import '../../../domain/repositories/volunteering_opportunities_repository.dart';
import 'volunteering_opportunity_details_state.dart';

class VolunteeringOpportunityDetailsCubit extends Cubit<VolunteeringOpportunityDetailsState> {
  VolunteeringOpportunityDetailsCubit(this._repository, {required this.id})
      : super(const VolunteeringOpportunityDetailsState());

  static const _profileIncompleteCode = 'PROFILE_INCOMPLETE';
  static const _missingFieldsKey = 'missingFields';
  static const _statusChangedCodes = {
    'EVENT_ALREADY_REGISTERED',
    'EVENT_NOT_REGISTERED',
    'EVENT_ALREADY_WITHDRAWN',
    'EVENT_WITHDRAWAL_NOT_ALLOWED',
  };
  static const _issueByCode = {
    'EVENT_REGISTRATION_CLOSED': VolunteeringOpportunityActionIssue.registrationClosed,
    'EVENT_REGISTRATION_REJECTED': VolunteeringOpportunityActionIssue.registrationRejected,
  };

  final VolunteeringOpportunitiesRepository _repository;
  final String id;
  final _uuid = const Uuid();
  String? _registerKey;

  Future<void> load() async {
    if (state.isLoading) return;
    emit(state.copyWith(isLoading: true, hasError: false));

    final result = await _repository.getVolunteeringOpportunityById(id);
    if (isClosed) return;

    result.fold(
      (failure) => emit(
        state.volunteeringOpportunity != null
            ? state.copyWith(isLoading: false)
            : VolunteeringOpportunityDetailsState(
                hasError: true,
                errorMessage: _messageOf(failure),
              ),
      ),
      (volunteeringOpportunity) => emit(
        state.copyWith(isLoading: false, volunteeringOpportunity: volunteeringOpportunity),
      ),
    );
  }

  Future<void> register() async {
    if (state.volunteeringOpportunity == null || state.isSubmitting) return;
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
        _applyStatus(
          registration.registrationStatus,
          VolunteeringOpportunityRegistered(registration.registrationStatus),
        );
      },
    );
  }

  Future<void> withdraw() async {
    if (state.volunteeringOpportunity == null || state.isSubmitting) return;
    emit(state.copyWith(isSubmitting: true));

    final result = await _repository.withdraw(id);
    if (isClosed) return;

    result.fold(
      _handleFailure,
      (registration) => _applyStatus(
        registration.registrationStatus,
        const VolunteeringOpportunityWithdrawn(),
      ),
    );
  }

  void _applyStatus(
    VolunteeringOpportunityRegistrationStatus status,
    VolunteeringOpportunityActionFeedback feedback,
  ) {
    emit(state.copyWith(
      isSubmitting: false,
      volunteeringOpportunity: state.volunteeringOpportunity?.copyWith(registrationStatus: status),
      feedback: feedback,
    ));
  }

  void _handleFailure(Failure failure) {
    final code = failure.code;

    if (code == _profileIncompleteCode) {
      emit(state.copyWith(
        isSubmitting: false,
        feedback: VolunteeringOpportunityProfileIncomplete(_missingFields(failure)),
      ));
      return;
    }

    if (_statusChangedCodes.contains(code)) {
      emit(state.copyWith(
        isSubmitting: false,
        feedback: const VolunteeringOpportunityActionBlocked(
          VolunteeringOpportunityActionIssue.statusChanged,
        ),
      ));
      load();
      return;
    }

    final issue = _issueByCode[code];
    emit(state.copyWith(
      isSubmitting: false,
      feedback: issue != null
          ? VolunteeringOpportunityActionBlocked(issue)
          : VolunteeringOpportunityActionError(_messageOf(failure)),
    ));
  }

  List<String> _missingFields(Failure failure) {
    final value = failure.extensions[_missingFieldsKey];
    return value is List ? value.whereType<String>().toList() : const [];
  }

  String? _messageOf(Failure failure) =>
      failure is UnexpectedFailure ? null : failure.displayMessage;
}
