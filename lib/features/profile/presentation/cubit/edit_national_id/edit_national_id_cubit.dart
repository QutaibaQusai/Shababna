import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/state/form_status.dart';
import '../../../domain/repositories/profile_national_id_repository.dart';
import 'edit_national_id_state.dart';

class EditNationalIdCubit extends Cubit<EditNationalIdState> {
  EditNationalIdCubit(this._repository) : super(const EditNationalIdState());

  final ProfileNationalIdRepository _repository;

  Future<void> upload(String filePath) async {
    emit(state.copyWith(status: FormStatus.submitting, errorMessage: null));

    final result = await _repository.updateNationalIdPicture(filePath);

    result.fold(
      (failure) => emit(
        state.copyWith(status: FormStatus.failure, errorMessage: failure.displayMessage),
      ),
      (_) => emit(state.copyWith(status: FormStatus.success)),
    );
  }

  Future<void> remove() async {
    emit(state.copyWith(status: FormStatus.submitting, errorMessage: null));

    final result = await _repository.deleteNationalIdPicture();

    result.fold(
      (failure) => emit(
        state.copyWith(status: FormStatus.failure, errorMessage: failure.displayMessage),
      ),
      (_) => emit(state.copyWith(status: FormStatus.success)),
    );
  }
}
