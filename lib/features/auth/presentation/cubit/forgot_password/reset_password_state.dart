import 'package:equatable/equatable.dart';

import '../../../../../core/state/form_status.dart';

class ResetPasswordState extends Equatable {
  const ResetPasswordState({this.status = FormStatus.initial, this.errorMessage});

  final FormStatus status;
  final String? errorMessage;

  @override
  List<Object?> get props => [status, errorMessage];
}
