import 'package:equatable/equatable.dart';

import '../../../../../core/state/form_status.dart';

class EditNationalIdState extends Equatable {
  const EditNationalIdState({this.status = FormStatus.initial, this.errorMessage});

  final FormStatus status;
  final String? errorMessage;

  EditNationalIdState copyWith({FormStatus? status, String? errorMessage}) {
    return EditNationalIdState(
      status: status ?? this.status,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, errorMessage];
}
