import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/state/form_status.dart';
import '../../../domain/repositories/auth_repository.dart';
import 'verify_email_state.dart';

class VerifyEmailCubit extends Cubit<VerifyEmailState> {
  VerifyEmailCubit(this._repository) : super(const VerifyEmailState());

  final AuthRepository _repository;

  Future<void> verify({required String email, required String code}) async {
    emit(state.copyWith(status: FormStatus.submitting));

    final result = await _repository.verifyEmail(email: email, code: code);

    result.fold(
      (failure) => emit(
        state.copyWith(status: FormStatus.failure, errorMessage: failure.displayMessage),
      ),
      (_) => emit(state.copyWith(status: FormStatus.success)),
    );
  }

  Future<void> resend({required String email}) async {
    emit(state.copyWith(isResending: true, resendMessage: null, resendFailed: false));

    final result = await _repository.resendEmailVerification(email: email);

    result.fold(
      (failure) => emit(
        state.copyWith(
          isResending: false,
          resendMessage: failure.displayMessage,
          resendFailed: true,
        ),
      ),
      (message) => emit(
        state.copyWith(isResending: false, resendMessage: message, resendFailed: false),
      ),
    );
  }
}
