import 'package:equatable/equatable.dart';

import '../../../../../core/state/form_status.dart';

class ForgotPasswordState extends Equatable {
  const ForgotPasswordState({
    this.status = FormStatus.initial,
    this.errorMessage,
    this.successMessage,
  });

  final FormStatus status;
  final String? errorMessage;
  final String? successMessage;

  @override
  List<Object?> get props => [status, errorMessage, successMessage];
}
