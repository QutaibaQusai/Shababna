import 'package:equatable/equatable.dart';

import '../../../../../core/state/form_status.dart';

class VerifyEmailChangeState extends Equatable {
  const VerifyEmailChangeState({
    this.status = FormStatus.initial,
    this.errorMessage,
    this.resendStatus = FormStatus.initial,
    this.resendError,
  });

  final FormStatus status;
  final String? errorMessage;
  final FormStatus resendStatus;
  final String? resendError;

  bool get isSubmitting => status == FormStatus.submitting;

  bool get isResending => resendStatus == FormStatus.submitting;

  VerifyEmailChangeState copyWith({
    FormStatus? status,
    String? errorMessage,
    FormStatus? resendStatus,
    String? resendError,
  }) {
    return VerifyEmailChangeState(
      status: status ?? this.status,
      errorMessage: errorMessage,
      resendStatus: resendStatus ?? this.resendStatus,
      resendError: resendError,
    );
  }

  @override
  List<Object?> get props => [status, errorMessage, resendStatus, resendError];
}
