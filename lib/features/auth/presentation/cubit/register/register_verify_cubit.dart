import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/state/form_status.dart';
import '../../../domain/repositories/auth_repository.dart';
import 'register_verify_state.dart';

class RegisterVerifyCubit extends Cubit<RegisterVerifyState> {
  RegisterVerifyCubit(this._repository) : super(const RegisterVerifyState());

  final AuthRepository _repository;

  Future<void> sendCode({required String email, required String phoneNumber}) async {
    emit(const RegisterVerifyState(status: FormStatus.submitting));

    final result = await _repository.checkRegistration(
      email: email,
      phoneNumber: phoneNumber,
    );

    result.fold(
      (failure) => emit(
        RegisterVerifyState(status: FormStatus.failure, errorMessage: failure.displayMessage),
      ),
      (_) => emit(const RegisterVerifyState(status: FormStatus.success)),
    );
  }

  Future<void> verify({
    required String email,
    required String phoneNumber,
    required String code,
  }) async {
    emit(state.copyWith(status: FormStatus.submitting));

    final result = await _repository.verifyRegistrationCode(
      email: email,
      phoneNumber: phoneNumber,
      code: code,
    );

    result.fold(
      (failure) => emit(
        state.copyWith(status: FormStatus.failure, errorMessage: failure.displayMessage),
      ),
      (token) => emit(
        state.copyWith(status: FormStatus.success, verificationToken: token),
      ),
    );
  }

  Future<void> resend({required String email, required String phoneNumber}) async {
    emit(state.copyWith(resendMessage: null, resendFailed: false));

    final result = await _repository.checkRegistration(
      email: email,
      phoneNumber: phoneNumber,
    );

    result.fold(
      (failure) => emit(
        state.copyWith(resendMessage: failure.displayMessage, resendFailed: true),
      ),
      (message) => emit(state.copyWith(resendMessage: message, resendFailed: false)),
    );
  }
}
