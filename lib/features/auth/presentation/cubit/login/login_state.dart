import 'package:equatable/equatable.dart';

import '../../../domain/login_verification.dart';

enum LoginStatus { initial, submitting, success, failure, needsVerification }

class LoginState extends Equatable {
  const LoginState({this.status = LoginStatus.initial, this.message, this.pending});

  final LoginStatus status;
  final String? message;
  final PendingVerification? pending;

  @override
  List<Object?> get props => [status, message, pending];
}
