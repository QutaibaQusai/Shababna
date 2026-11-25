import 'package:equatable/equatable.dart';

import '../../../core/error/failures.dart';
import 'verification_channel.dart';

class PendingVerification extends Equatable {
  const PendingVerification({
    required this.token,
    required this.channel,
    required this.destination,
    required this.codeSent,
    required this.retryAfterSeconds,
  });

  final String token;
  final VerificationChannel channel;
  final String destination;
  final bool codeSent;
  final int retryAfterSeconds;

  @override
  List<Object?> get props => [token, channel, destination, codeSent, retryAfterSeconds];
}

sealed class LoginOutcome {
  const LoginOutcome();
}

final class LoginSucceeded extends LoginOutcome {
  const LoginSucceeded();
}

final class LoginNeedsVerification extends LoginOutcome {
  const LoginNeedsVerification(this.pending, {required this.message});

  final PendingVerification pending;
  final String message;
}

abstract final class AuthErrorCodes {
  static const emailNotVerified = 'EMAIL_NOT_VERIFIED';
  static const phoneNotVerified = 'PHONE_NOT_VERIFIED';
  static const verificationTokenInvalid = 'VERIFICATION_TOKEN_INVALID';
  static const resendTooSoon = 'OTP_RESEND_TOO_SOON';

  static const notVerified = {emailNotVerified, phoneNotVerified};
}

int? readSeconds(Object? value) => switch (value) {
  final int seconds => seconds,
  final num seconds => seconds.round(),
  final String seconds => int.tryParse(seconds),
  _ => null,
};

extension LoginVerificationFailure on Failure {
  int? get retryAfterSeconds => readSeconds(extensions['retryAfterSeconds']);
}
