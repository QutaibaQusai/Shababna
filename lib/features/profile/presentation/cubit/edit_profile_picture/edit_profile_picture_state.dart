import 'package:equatable/equatable.dart';

import '../../../../../core/state/form_status.dart';

class EditProfilePictureState extends Equatable {
  const EditProfilePictureState({this.status = FormStatus.initial, this.errorMessage});

  final FormStatus status;
  final String? errorMessage;

  EditProfilePictureState copyWith({FormStatus? status, String? errorMessage}) {
    return EditProfilePictureState(
      status: status ?? this.status,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, errorMessage];
}
