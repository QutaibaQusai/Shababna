import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/state/form_status.dart';
import '../../domain/repositories/change_password_repository.dart';
import 'change_password_state.dart';

class ChangePasswordCubit extends Cubit<ChangePasswordState> {
  ChangePasswordCubit(this._repository) : super(const ChangePasswordState());

  final ChangePasswordRepository _repository;

  Future<void> submit({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    emit(const ChangePasswordState(status: FormStatus.submitting));

    final result = await _repository.changePassword(
      currentPassword: currentPassword,
      newPassword: newPassword,
      confirmPassword: confirmPassword,
    );

    result.fold(
      (failure) => emit(
        ChangePasswordState(status: FormStatus.failure, errorMessage: failure.displayMessage),
      ),
      (_) => emit(const ChangePasswordState(status: FormStatus.success)),
    );
  }
}
