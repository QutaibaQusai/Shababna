import 'package:equatable/equatable.dart';

import '../../../domain/verification_channel.dart';

enum LoginVerificationStatus { idle, verifying, verified, expired }

class LoginVerificationState extends Equatable {
  const LoginVerificationState({
    required this.channel,
    required this.destination,
    this.status = LoginVerificationStatus.idle,
    this.isResending = false,
    this.cooldownSeconds = 0,
    this.cooldownVersion = 0,
    this.errorMessage,
  });

  final VerificationChannel channel;
  final String destination;
  final LoginVerificationStatus status;
  final bool isResending;
  final int cooldownSeconds;
  final int cooldownVersion;
  final String? errorMessage;

  bool get isBusy => status == LoginVerificationStatus.verifying || isResending;

  LoginVerificationState copyWith({
    LoginVerificationStatus? status,
    bool? isResending,
    int? cooldownSeconds,
    bool restartCooldown = false,
    String? errorMessage,
  }) {
    return LoginVerificationState(
      channel: channel,
      destination: destination,
      status: status ?? this.status,
      isResending: isResending ?? this.isResending,
      cooldownSeconds: cooldownSeconds ?? this.cooldownSeconds,
      cooldownVersion: restartCooldown ? cooldownVersion + 1 : cooldownVersion,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    channel,
    destination,
    status,
    isResending,
    cooldownSeconds,
    cooldownVersion,
    errorMessage,
  ];
}
