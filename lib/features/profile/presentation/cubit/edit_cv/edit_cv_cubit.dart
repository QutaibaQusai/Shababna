import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/state/form_status.dart';
import '../../../domain/repositories/profile_cv_repository.dart';
import 'edit_cv_state.dart';

class EditCvCubit extends Cubit<EditCvState> {
  EditCvCubit(this._repository) : super(const EditCvState());

  final ProfileCvRepository _repository;

  Future<void> upload(String filePath) async {
    emit(state.copyWith(status: FormStatus.submitting, errorMessage: null));

    final result = await _repository.updateCv(filePath);

    result.fold(
      (failure) => emit(
        state.copyWith(status: FormStatus.failure, errorMessage: failure.displayMessage),
      ),
      (_) => emit(state.copyWith(status: FormStatus.success)),
    );
  }

  Future<void> remove() async {
    emit(state.copyWith(status: FormStatus.submitting, errorMessage: null));

    final result = await _repository.deleteCv();

    result.fold(
      (failure) => emit(
        state.copyWith(status: FormStatus.failure, errorMessage: failure.displayMessage),
      ),
      (_) => emit(state.copyWith(status: FormStatus.success)),
    );
  }
}
