import '../../domain/login_verification.dart';
import '../../domain/verification_channel.dart';

class PendingVerificationModel {
  PendingVerificationModel._();

  static PendingVerification? fromProblemExtensions(
    Map<String, dynamic> extensions, {
    required VerificationChannel fallbackChannel,
  }) {
    final token = extensions['verificationToken'];
    if (token is! String || token.isEmpty) return null;

    final destination = extensions['destination'];
    return PendingVerification(
      token: token,
      channel: VerificationChannel.fromApi(extensions['channel']) ?? fallbackChannel,
      destination: destination is String ? destination : '',
      codeSent: _readBool(extensions['codeSent']),
      retryAfterSeconds: readSeconds(extensions['retryAfterSeconds']) ?? 0,
    );
  }

  static bool _readBool(Object? value) => switch (value) {
    final bool flag => flag,
    final String text => text.toLowerCase() == 'true',
    _ => false,
  };
}
