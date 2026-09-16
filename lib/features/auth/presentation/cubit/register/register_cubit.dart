import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/state/form_status.dart';
import '../../../domain/repositories/auth_repository.dart';
import 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit(this._repository) : super(const RegisterState());

  final AuthRepository _repository;

  Future<void> loadPhoneCodes() async {
    emit(state.copyWith(isLoadingPhoneCodes: true, phoneCodesError: null));

    final result = await _repository.getPhoneCodes();

    result.fold(
      (failure) => emit(
        state.copyWith(isLoadingPhoneCodes: false, phoneCodesError: failure.displayMessage),
      ),
      (phoneCodes) => emit(
        state.copyWith(isLoadingPhoneCodes: false, phoneCodes: phoneCodes),
      ),
    );
  }

  Future<void> submit({
    required String email,
    required String phoneNumber,
    required String fullNameEn,
    required String fullNameAr,
    required String password,
    required String confirmPassword,
  }) async {
    emit(state.copyWith(status: FormStatus.submitting));

    final result = await _repository.register(
      email: email,
      phoneNumber: phoneNumber,
      fullNameEn: fullNameEn,
      fullNameAr: fullNameAr,
      password: password,
      confirmPassword: confirmPassword,
    );

    result.fold(
      (failure) => emit(
        state.copyWith(status: FormStatus.failure, errorMessage: failure.displayMessage),
      ),
      (registerResult) => emit(
        state.copyWith(
          status: FormStatus.success,
          registeredEmail: registerResult.email,
          emailVerificationRequired: registerResult.emailVerificationRequired,
        ),
      ),
    );
  }
}
