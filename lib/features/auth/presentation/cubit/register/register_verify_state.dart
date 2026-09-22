import 'package:equatable/equatable.dart';

import '../../../../../core/state/form_status.dart';

class RegisterVerifyState extends Equatable {
  const RegisterVerifyState({
    this.status = FormStatus.initial,
    this.errorMessage,
    this.verificationToken,
    this.resendMessage,
    this.resendFailed = false,
  });

  final FormStatus status;
  final String? errorMessage;
  final String? verificationToken;
  final String? resendMessage;
  final bool resendFailed;

  RegisterVerifyState copyWith({
    FormStatus? status,
    String? errorMessage,
    String? verificationToken,
    String? resendMessage,
    bool? resendFailed,
  }) {
    return RegisterVerifyState(
      status: status ?? this.status,
      errorMessage: errorMessage,
      verificationToken: verificationToken ?? this.verificationToken,
      resendMessage: resendMessage,
      resendFailed: resendFailed ?? this.resendFailed,
    );
  }

  @override
  List<Object?> get props => [
        status,
        errorMessage,
        verificationToken,
        resendMessage,
        resendFailed,
      ];
}
