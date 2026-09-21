import 'package:equatable/equatable.dart';

import '../../../../../core/state/form_status.dart';

class VerifyResetCodeState extends Equatable {
  const VerifyResetCodeState({
    this.status = FormStatus.initial,
    this.errorMessage,
    this.resetToken,
    this.resendMessage,
    this.resendFailed = false,
  });

  final FormStatus status;
  final String? errorMessage;
  final String? resetToken;
  final String? resendMessage;
  final bool resendFailed;

  VerifyResetCodeState copyWith({
    FormStatus? status,
    String? errorMessage,
    String? resetToken,
    String? resendMessage,
    bool? resendFailed,
  }) {
    return VerifyResetCodeState(
      status: status ?? this.status,
      errorMessage: errorMessage,
      resetToken: resetToken ?? this.resetToken,
      resendMessage: resendMessage,
      resendFailed: resendFailed ?? this.resendFailed,
    );
  }

  @override
  List<Object?> get props => [
        status,
        errorMessage,
        resetToken,
        resendMessage,
        resendFailed,
      ];
}
