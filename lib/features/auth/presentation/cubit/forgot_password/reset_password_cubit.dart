import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/state/form_status.dart';
import '../../../domain/repositories/auth_repository.dart';
import 'reset_password_state.dart';

class ResetPasswordCubit extends Cubit<ResetPasswordState> {
  ResetPasswordCubit(this._repository) : super(const ResetPasswordState());

  final AuthRepository _repository;

  Future<void> submit({
    required String email,
    required String resetToken,
    required String newPassword,
    required String confirmPassword,
  }) async {
    emit(const ResetPasswordState(status: FormStatus.submitting));

    final result = await _repository.resetPassword(
      email: email,
      resetToken: resetToken,
      newPassword: newPassword,
      confirmPassword: confirmPassword,
    );

    if (isClosed) return;

    result.fold(
      (failure) => emit(
        ResetPasswordState(status: FormStatus.failure, errorMessage: failure.displayMessage),
      ),
      (_) => emit(const ResetPasswordState(status: FormStatus.success)),
    );
  }

  void clearError() {
    if (state.errorMessage == null) return;
    emit(const ResetPasswordState());
  }
}
