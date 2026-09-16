import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/state/form_status.dart';
import '../../domain/repositories/auth_repository.dart';
import 'forgot_password_state.dart';

class ForgotPasswordCubit extends Cubit<ForgotPasswordState> {
  ForgotPasswordCubit(this._repository) : super(const ForgotPasswordState());

  final AuthRepository _repository;

  Future<void> submit({required String email}) async {
    emit(const ForgotPasswordState(status: FormStatus.submitting));

    final result = await _repository.forgotPassword(email: email);

    result.fold(
      (failure) => emit(
        ForgotPasswordState(status: FormStatus.failure, errorMessage: failure.displayMessage),
      ),
      (_) => emit(const ForgotPasswordState(status: FormStatus.success)),
    );
  }
}
