import 'package:equatable/equatable.dart';

import '../../../../../core/state/form_status.dart';

class VerifyEmailState extends Equatable {
  const VerifyEmailState({
    this.status = FormStatus.initial,
    this.errorMessage,
    this.resendMessage,
    this.resendFailed = false,
  });

  final FormStatus status;
  final String? errorMessage;
  final String? resendMessage;
  final bool resendFailed;

  VerifyEmailState copyWith({
    FormStatus? status,
    String? errorMessage,
    String? resendMessage,
    bool? resendFailed,
  }) {
    return VerifyEmailState(
      status: status ?? this.status,
      errorMessage: errorMessage,
      resendMessage: resendMessage,
      resendFailed: resendFailed ?? this.resendFailed,
    );
  }

  @override
  List<Object?> get props => [
        status,
        errorMessage,
        resendMessage,
        resendFailed,
      ];
}
