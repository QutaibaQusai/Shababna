import 'package:equatable/equatable.dart';

import '../../../../../core/state/form_status.dart';

class EditCvState extends Equatable {
  const EditCvState({this.status = FormStatus.initial, this.errorMessage});

  final FormStatus status;
  final String? errorMessage;

  EditCvState copyWith({FormStatus? status, String? errorMessage}) {
    return EditCvState(
      status: status ?? this.status,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, errorMessage];
}
