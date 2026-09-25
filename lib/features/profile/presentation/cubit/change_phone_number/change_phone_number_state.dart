import 'package:equatable/equatable.dart';

import '../../../../../core/state/form_status.dart';

class ChangePhoneNumberState extends Equatable {
  const ChangePhoneNumberState({this.status = FormStatus.initial, this.errorMessage});

  final FormStatus status;
  final String? errorMessage;

  ChangePhoneNumberState copyWith({FormStatus? status, String? errorMessage}) {
    return ChangePhoneNumberState(
      status: status ?? this.status,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, errorMessage];
}
