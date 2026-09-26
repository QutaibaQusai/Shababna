import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/state/form_status.dart';
import '../../../domain/repositories/profile_repository.dart';
import '../../utils/failure_message.dart';
import '../profile/profile_cubit.dart';
import 'edit_profile_state.dart';

class EditProfileCubit extends Cubit<EditProfileState> {
  EditProfileCubit(this._repository, this._profileCubit, Profile profile)
      : super(_stateFor(profile));

  final ProfileRepository _repository;
  final ProfileCubit _profileCubit;

  static EditProfileState _stateFor(Profile profile) {
    final details = ProfileDetails.fromProfile(profile);
    return EditProfileState(initial: details, draft: details);
  }

  void edit(ProfileDetails Function(ProfileDetails draft) change) {
    if (state.isSubmitting) return;
    emit(state.copyWith(draft: change(state.draft), status: FormStatus.initial));
  }

  Future<void> submit() async {
    if (!state.canSave) return;
    emit(state.copyWith(status: FormStatus.submitting));

    final result = await _repository.updateDetails(state.draft);
    if (isClosed) return;

    result.fold(
      (failure) => emit(
        state.copyWith(status: FormStatus.failure, errorMessage: failure.userMessage),
      ),
      (profile) {
        _profileCubit.replace(profile);
        final details = ProfileDetails.fromProfile(profile);
        emit(EditProfileState(initial: details, draft: details, status: FormStatus.success));
      },
    );
  }
}
