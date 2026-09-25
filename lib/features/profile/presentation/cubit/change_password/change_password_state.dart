import 'package:equatable/equatable.dart';

import '../../../../../core/state/form_status.dart';

class ChangePasswordState extends Equatable {
  const ChangePasswordState({this.status = FormStatus.initial, this.errorMessage});

  final FormStatus status;
  final String? errorMessage;

  ChangePasswordState copyWith({FormStatus? status, String? errorMessage}) {
    return ChangePasswordState(
      status: status ?? this.status,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, errorMessage];
}
