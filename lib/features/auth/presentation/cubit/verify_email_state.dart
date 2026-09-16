import 'package:equatable/equatable.dart';

import '../../../../core/state/form_status.dart';

class VerifyEmailState extends Equatable {
  const VerifyEmailState({
    this.status = FormStatus.initial,
    this.errorMessage,
    this.isResending = false,
    this.resendMessage,
  });

  final FormStatus status;
  final String? errorMessage;
  final bool isResending;
  final String? resendMessage;

  VerifyEmailState copyWith({
    FormStatus? status,
    String? errorMessage,
    bool? isResending,
    String? resendMessage,
  }) {
    return VerifyEmailState(
      status: status ?? this.status,
      errorMessage: errorMessage,
      isResending: isResending ?? this.isResending,
      resendMessage: resendMessage,
    );
  }

  @override
  List<Object?> get props => [status, errorMessage, isResending, resendMessage];
}
