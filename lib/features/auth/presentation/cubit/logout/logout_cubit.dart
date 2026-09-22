import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/logging/app_logger.dart';
import '../../../../../core/session/auth_session_cubit.dart';
import '../../../../../core/state/form_status.dart';
import '../../../domain/repositories/auth_repository.dart';
import 'logout_state.dart';

class LogoutCubit extends Cubit<LogoutState> {
  LogoutCubit(this._repository, this._authSessionCubit, this._logger)
      : super(const LogoutState());

  final AuthRepository _repository;
  final AuthSessionCubit _authSessionCubit;
  final AppLogger _logger;

  Future<void> logout() async {
    emit(const LogoutState(status: FormStatus.submitting));

    final result = await _repository.logout();
    result.fold(
      (failure) => _logger.warning(
        'Server logout failed, clearing session locally anyway: ${failure.displayMessage}',
        tag: 'LogoutCubit',
      ),
      (_) {},
    );

    await _authSessionCubit.markUnauthenticated();
    emit(const LogoutState(status: FormStatus.success));
  }
}
