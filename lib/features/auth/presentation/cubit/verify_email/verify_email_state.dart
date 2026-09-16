import 'package:equatable/equatable.dart';

import '../../../../../core/state/form_status.dart';

class VerifyEmailState extends Equatable {
  const VerifyEmailState({
    this.status = FormStatus.initial,
    this.errorMessage,
    this.isResending = false,
    this.resendMessage,
    this.resendFailed = false,
  });

  final FormStatus status;
  final String? errorMessage;
  final bool isResending;
  final String? resendMessage;
  final bool resendFailed;

  VerifyEmailState copyWith({
    FormStatus? status,
    String? errorMessage,
    bool? isResending,
    String? resendMessage,
    bool? resendFailed,
  }) {
    return VerifyEmailState(
      status: status ?? this.status,
      errorMessage: errorMessage,
      isResending: isResending ?? this.isResending,
      resendMessage: resendMessage,
      resendFailed: resendFailed ?? this.resendFailed,
    );
  }

  @override
  List<Object?> get props => [
        status,
        errorMessage,
        isResending,
        resendMessage,
        resendFailed,
      ];
}
