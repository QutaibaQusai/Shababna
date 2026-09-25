import 'package:equatable/equatable.dart';

import '../../../../../core/state/form_status.dart';

class ChangeEmailState extends Equatable {
  const ChangeEmailState({
    this.status = FormStatus.initial,
    this.errorMessage,
    this.verificationRequired = false,
    this.newEmail,
  });

  final FormStatus status;
  final String? errorMessage;
  final bool verificationRequired;
  final String? newEmail;

  ChangeEmailState copyWith({
    FormStatus? status,
    String? errorMessage,
    bool? verificationRequired,
    String? newEmail,
  }) {
    return ChangeEmailState(
      status: status ?? this.status,
      errorMessage: errorMessage,
      verificationRequired: verificationRequired ?? this.verificationRequired,
      newEmail: newEmail ?? this.newEmail,
    );
  }

  @override
  List<Object?> get props => [status, errorMessage, verificationRequired, newEmail];
}
