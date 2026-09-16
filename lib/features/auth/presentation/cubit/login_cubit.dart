import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/session/auth_session_cubit.dart';
import '../../../../core/state/form_status.dart';
import '../../domain/repositories/auth_repository.dart';
import 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit(this._repository, this._authSessionCubit) : super(const LoginState());

  final AuthRepository _repository;
  final AuthSessionCubit _authSessionCubit;

  Future<void> login({required String email, required String password}) async {
    emit(const LoginState(status: FormStatus.submitting));

    final result = await _repository.login(email: email, password: password);

    result.fold(
      (failure) => emit(
        LoginState(status: FormStatus.failure, errorMessage: failure.displayMessage),
      ),
      (_) {
        _authSessionCubit.markAuthenticated();
        emit(const LoginState(status: FormStatus.success));
      },
    );
  }
}
