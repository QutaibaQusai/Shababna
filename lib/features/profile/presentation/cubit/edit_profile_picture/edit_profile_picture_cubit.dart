import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/state/form_status.dart';
import '../../../domain/repositories/profile_picture_repository.dart';
import 'edit_profile_picture_state.dart';

class EditProfilePictureCubit extends Cubit<EditProfilePictureState> {
  EditProfilePictureCubit(this._repository) : super(const EditProfilePictureState());

  final ProfilePictureRepository _repository;

  Future<void> upload(String filePath) async {
    emit(state.copyWith(status: FormStatus.submitting, errorMessage: null));

    final result = await _repository.updatePicture(filePath);

    result.fold(
      (failure) => emit(
        state.copyWith(status: FormStatus.failure, errorMessage: failure.displayMessage),
      ),
      (_) => emit(state.copyWith(status: FormStatus.success)),
    );
  }

  Future<void> remove() async {
    emit(state.copyWith(status: FormStatus.submitting, errorMessage: null));

    final result = await _repository.deletePicture();

    result.fold(
      (failure) => emit(
        state.copyWith(status: FormStatus.failure, errorMessage: failure.displayMessage),
      ),
      (_) => emit(state.copyWith(status: FormStatus.success)),
    );
  }
}
