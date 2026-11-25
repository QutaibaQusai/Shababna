import 'package:equatable/equatable.dart';

import '../../../../auth/domain/verification_channel.dart';

enum VerifyContactStatus { sending, idle, verifying, verified }

class VerifyContactState extends Equatable {
  const VerifyContactState({
    required this.channel,
    this.status = VerifyContactStatus.sending,
    this.cooldownSeconds = 0,
    this.cooldownVersion = 0,
    this.errorMessage,
    this.message,
  });

  final VerificationChannel channel;
  final VerifyContactStatus status;
  final int cooldownSeconds;
  final int cooldownVersion;
  final String? errorMessage;
  final String? message;

  bool get isBusy =>
      status == VerifyContactStatus.sending || status == VerifyContactStatus.verifying;

  VerifyContactState copyWith({
    VerifyContactStatus? status,
    int? cooldownSeconds,
    bool restartCooldown = false,
    String? errorMessage,
    String? message,
  }) {
    return VerifyContactState(
      channel: channel,
      status: status ?? this.status,
      cooldownSeconds: cooldownSeconds ?? this.cooldownSeconds,
      cooldownVersion: restartCooldown ? cooldownVersion + 1 : cooldownVersion,
      errorMessage: errorMessage,
      message: message,
    );
  }

  @override
  List<Object?> get props => [
    channel,
    status,
    cooldownSeconds,
    cooldownVersion,
    errorMessage,
    message,
  ];
}
