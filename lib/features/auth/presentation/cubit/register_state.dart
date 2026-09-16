import 'package:equatable/equatable.dart';

import '../../../../core/state/form_status.dart';

class RegisterState extends Equatable {
  const RegisterState({
    this.status = FormStatus.initial,
    this.errorMessage,
    this.registeredEmail,
  });

  final FormStatus status;
  final String? errorMessage;
  final String? registeredEmail;

  @override
  List<Object?> get props => [status, errorMessage, registeredEmail];
}
