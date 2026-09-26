import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/state/form_status.dart';
import '../../../domain/repositories/profile_email_repository.dart';
import '../../utils/failure_message.dart';
import '../profile/profile_cubit.dart';
import 'change_email_state.dart';

class ChangeEmailCubit extends Cubit<ChangeEmailState> {
  ChangeEmailCubit(this._repository, this._profileCubit) : super(const ChangeEmailState());

  final ProfileEmailRepository _repository;
  final ProfileCubit _profileCubit;

  Future<void> submit({required String currentPassword, required String newEmail}) async {
    if (state.isSubmitting) return;
    emit(const ChangeEmailState(status: FormStatus.submitting));

    final result = await _repository.changeEmail(
      currentPassword: currentPassword,
      newEmail: newEmail,
    );
    if (isClosed) return;

    result.fold(
      (failure) => emit(
        ChangeEmailState(status: FormStatus.failure, errorMessage: failure.userMessage),
      ),
      (response) {
        if (!response.verificationRequired) {
          _profileCubit.patch((profile) => profile.copyWith(email: response.newEmail));
        }
        emit(ChangeEmailState(
          status: FormStatus.success,
          verificationRequired: response.verificationRequired,
          newEmail: response.newEmail,
        ));
      },
    );
  }
}
