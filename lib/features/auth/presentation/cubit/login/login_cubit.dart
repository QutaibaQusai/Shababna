import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/session/auth_session_cubit.dart';
import '../../../domain/auth_identifier.dart';
import '../../../domain/login_verification.dart';
import '../../../domain/repositories/auth_repository.dart';
import 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit(this._repository, this._authSessionCubit) : super(const LoginState());

  final AuthRepository _repository;
  final AuthSessionCubit _authSessionCubit;

  Future<void> login({required AuthIdentifier identifier, required String password}) async {
    if (state.status == LoginStatus.submitting) return;
    emit(const LoginState(status: LoginStatus.submitting));

    final result = await _repository.login(identifier: identifier, password: password);
    if (isClosed) return;

    result.fold(
      (failure) => emit(LoginState(status: LoginStatus.failure, message: failure.displayMessage)),
      (outcome) => switch (outcome) {
        LoginSucceeded() => completeSignIn(),
        LoginNeedsVerification(:final pending, :final message) => emit(
          LoginState(status: LoginStatus.needsVerification, pending: pending, message: message),
        ),
      },
    );
  }

  void completeSignIn() {
    _authSessionCubit.markAuthenticated();
    emit(const LoginState(status: LoginStatus.success));
  }
}
