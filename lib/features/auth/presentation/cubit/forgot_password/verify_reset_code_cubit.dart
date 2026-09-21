import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/state/form_status.dart';
import '../../../domain/repositories/auth_repository.dart';
import 'verify_reset_code_state.dart';

class VerifyResetCodeCubit extends Cubit<VerifyResetCodeState> {
  VerifyResetCodeCubit(this._repository) : super(const VerifyResetCodeState());

  final AuthRepository _repository;

  Future<void> verify({required String email, required String code}) async {
    emit(state.copyWith(status: FormStatus.submitting));

    final result = await _repository.verifyResetCode(email: email, code: code);

    result.fold(
      (failure) => emit(
        state.copyWith(status: FormStatus.failure, errorMessage: failure.displayMessage),
      ),
      (resetToken) => emit(
        state.copyWith(status: FormStatus.success, resetToken: resetToken),
      ),
    );
  }

  Future<void> resend({required String email}) async {
    emit(state.copyWith(resendMessage: null, resendFailed: false));

    final result = await _repository.forgotPassword(email: email);

    result.fold(
      (failure) => emit(
        state.copyWith(resendMessage: failure.displayMessage, resendFailed: true),
      ),
      (message) => emit(state.copyWith(resendMessage: message, resendFailed: false)),
    );
  }
}
