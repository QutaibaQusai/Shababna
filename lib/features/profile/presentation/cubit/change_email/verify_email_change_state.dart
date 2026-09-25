import 'package:equatable/equatable.dart';

import '../../../../../core/state/form_status.dart';

class VerifyEmailChangeState extends Equatable {
  const VerifyEmailChangeState({
    this.status = FormStatus.initial,
    this.errorMessage,
    this.resendCount = 0,
    this.resendMessage,
    this.resendFailed = false,
  });

  final FormStatus status;
  final String? errorMessage;
  final int resendCount;
  final String? resendMessage;
  final bool resendFailed;

  VerifyEmailChangeState copyWith({
    FormStatus? status,
    String? errorMessage,
    int? resendCount,
    String? resendMessage,
    bool? resendFailed,
  }) {
    return VerifyEmailChangeState(
      status: status ?? this.status,
      errorMessage: errorMessage,
      resendCount: resendCount ?? this.resendCount,
      resendMessage: resendMessage,
      resendFailed: resendFailed ?? this.resendFailed,
    );
  }

  @override
  List<Object?> get props => [status, errorMessage, resendCount, resendMessage, resendFailed];
}
