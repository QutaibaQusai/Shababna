import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/state/form_status.dart';
import '../../domain/repositories/auth_repository.dart';
import 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit(this._repository) : super(const RegisterState());

  final AuthRepository _repository;

  Future<void> submit({
    required String email,
    required String phoneNumber,
    required String fullNameEn,
    required String fullNameAr,
    required String password,
    required String confirmPassword,
  }) async {
    emit(const RegisterState(status: FormStatus.submitting));

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
        RegisterState(status: FormStatus.failure, errorMessage: failure.displayMessage),
      ),
      (registerResult) => emit(
        RegisterState(status: FormStatus.success, registeredEmail: registerResult.email),
      ),
    );
  }
}
