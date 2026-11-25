import 'package:equatable/equatable.dart';

import '../../../../../core/state/form_status.dart';
import '../../../domain/verification_channel.dart';

class RegisterVerifyState extends Equatable {
  const RegisterVerifyState({
    this.status = FormStatus.initial,
    this.channel = VerificationChannel.email,
    this.errorMessage,
    this.verificationToken,
    this.resendMessage,
    this.resendFailed = false,
  });

  final FormStatus status;
  final VerificationChannel channel;
  final String? errorMessage;
  final String? verificationToken;
  final String? resendMessage;
  final bool resendFailed;

  RegisterVerifyState copyWith({
    FormStatus? status,
    VerificationChannel? channel,
    String? errorMessage,
    String? verificationToken,
    String? resendMessage,
    bool? resendFailed,
  }) {
    return RegisterVerifyState(
      status: status ?? this.status,
      channel: channel ?? this.channel,
      errorMessage: errorMessage,
      verificationToken: verificationToken ?? this.verificationToken,
      resendMessage: resendMessage,
      resendFailed: resendFailed ?? this.resendFailed,
    );
  }

  @override
  List<Object?> get props => [
    status,
    channel,
    errorMessage,
    verificationToken,
    resendMessage,
    resendFailed,
  ];
}
