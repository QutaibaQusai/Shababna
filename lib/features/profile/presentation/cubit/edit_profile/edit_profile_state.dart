import 'package:equatable/equatable.dart';

import '../../../../../core/state/form_status.dart';
import '../../../domain/repositories/profile_repository.dart';

class EditProfileState extends Equatable {
  const EditProfileState({
    required this.initial,
    required this.draft,
    this.status = FormStatus.initial,
    this.errorMessage,
  });

  final ProfileDetails initial;
  final ProfileDetails draft;
  final FormStatus status;
  final String? errorMessage;

  bool get isDirty => draft != initial;

  bool get isSubmitting => status == FormStatus.submitting;

  bool get canSave => isDirty && !isSubmitting;

  EditProfileState copyWith({
    ProfileDetails? initial,
    ProfileDetails? draft,
    FormStatus? status,
    String? errorMessage,
  }) {
    return EditProfileState(
      initial: initial ?? this.initial,
      draft: draft ?? this.draft,
      status: status ?? this.status,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [initial, draft, status, errorMessage];
}
