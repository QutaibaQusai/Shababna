import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/error/failures.dart';
import '../../../domain/login_verification.dart';
import '../../../domain/repositories/auth_repository.dart';
import 'login_verification_state.dart';

class LoginVerificationCubit extends Cubit<LoginVerificationState> {
  LoginVerificationCubit(this._repository, {required PendingVerification pending})
    : _pending = pending,
      super(
        LoginVerificationState(
          channel: pending.channel,
          destination: pending.destination,
          cooldownSeconds: _initialCooldown(pending),
        ),
      );

  static const _defaultCooldownSeconds = 60;

  final AuthRepository _repository;
  final PendingVerification _pending;

  static int _initialCooldown(PendingVerification pending) {
    if (pending.retryAfterSeconds > 0) return pending.retryAfterSeconds;
    return pending.codeSent ? _defaultCooldownSeconds : 0;
  }

  void start() {
    if (!_pending.codeSent && _pending.retryAfterSeconds == 0) resend();
  }

  Future<void> verify(String code) async {
    if (state.isBusy) return;
    emit(state.copyWith(status: LoginVerificationStatus.verifying));

    final result = await _repository.verifyLoginCode(pending: _pending, code: code);
    if (isClosed) return;

    result.fold(
      (failure) => _onFailure(failure, status: LoginVerificationStatus.idle),
      (_) => emit(state.copyWith(status: LoginVerificationStatus.verified)),
    );
  }

  Future<void> resend() async {
    if (state.isBusy) return;
    emit(state.copyWith(isResending: true));

    final result = await _repository.sendLoginCode(_pending);
    if (isClosed) return;

    result.fold(
      (failure) => _onFailure(failure, status: state.status),
      (resendAfterSeconds) => emit(
        state.copyWith(
          isResending: false,
          cooldownSeconds: resendAfterSeconds,
          restartCooldown: true,
        ),
      ),
    );
  }

  void _onFailure(Failure failure, {required LoginVerificationStatus status}) {
    switch (failure.code) {
      case AuthErrorCodes.verificationTokenInvalid:
        emit(
          state.copyWith(
            status: LoginVerificationStatus.expired,
            isResending: false,
            errorMessage: failure.displayMessage,
          ),
        );
      case AuthErrorCodes.resendTooSoon:
        emit(
          state.copyWith(
            status: status,
            isResending: false,
            cooldownSeconds: failure.retryAfterSeconds ?? _defaultCooldownSeconds,
            restartCooldown: true,
            errorMessage: failure.displayMessage,
          ),
        );
      default:
        emit(
          state.copyWith(status: status, isResending: false, errorMessage: failure.displayMessage),
        );
    }
  }
}
