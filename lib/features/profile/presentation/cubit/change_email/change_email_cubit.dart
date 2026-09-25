import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/state/form_status.dart';
import '../../../domain/repositories/profile_email_repository.dart';
import 'change_email_state.dart';

class ChangeEmailCubit extends Cubit<ChangeEmailState> {
  ChangeEmailCubit(this._repository) : super(const ChangeEmailState());

  final ProfileEmailRepository _repository;

  Future<void> submit({required String currentPassword, required String newEmail}) async {
    emit(state.copyWith(status: FormStatus.submitting, errorMessage: null));

    final result = await _repository.changeEmail(
      currentPassword: currentPassword,
      newEmail: newEmail,
    );

    result.fold(
      (failure) => emit(
        state.copyWith(status: FormStatus.failure, errorMessage: failure.displayMessage),
      ),
      (response) => emit(
        state.copyWith(
          status: FormStatus.success,
          verificationRequired: response.verificationRequired,
          newEmail: response.newEmail,
        ),
      ),
    );
  }
}
