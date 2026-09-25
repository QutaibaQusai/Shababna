import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/state/form_status.dart';
import '../../../domain/repositories/profile_email_repository.dart';
import 'verify_email_change_state.dart';

class VerifyEmailChangeCubit extends Cubit<VerifyEmailChangeState> {
  VerifyEmailChangeCubit(this._repository) : super(const VerifyEmailChangeState());

  final ProfileEmailRepository _repository;

  Future<void> verify(String code) async {
    emit(state.copyWith(status: FormStatus.submitting, errorMessage: null));

    final result = await _repository.verifyEmailChange(code);

    result.fold(
      (failure) => emit(
        state.copyWith(status: FormStatus.failure, errorMessage: failure.displayMessage),
      ),
      (_) => emit(state.copyWith(status: FormStatus.success)),
    );
  }

  Future<void> resend() async {
    final result = await _repository.resendEmailChangeCode();

    result.fold(
      (failure) => emit(
        state.copyWith(
          resendCount: state.resendCount + 1,
          resendMessage: failure.displayMessage,
          resendFailed: true,
        ),
      ),
      (_) => emit(
        state.copyWith(
          resendCount: state.resendCount + 1,
          resendMessage: null,
          resendFailed: false,
        ),
      ),
    );
  }
}
