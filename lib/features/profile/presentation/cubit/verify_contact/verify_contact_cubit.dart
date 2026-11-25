import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/error/failures.dart';
import '../../../../auth/domain/verification_channel.dart';
import '../../../domain/repositories/contact_verification_repository.dart';
import '../profile/profile_cubit.dart';
import 'verify_contact_state.dart';

class VerifyContactCubit extends Cubit<VerifyContactState> {
  VerifyContactCubit(this._repository, this._profileCubit, {required VerificationChannel channel})
    : super(VerifyContactState(channel: channel));

  static const _defaultCooldownSeconds = 60;
  static const _resendTooSoonCode = 'OTP_RESEND_TOO_SOON';
  static const _alreadyVerifiedCodes = {'EMAIL_ALREADY_VERIFIED', 'PHONE_ALREADY_VERIFIED'};

  final ContactVerificationRepository _repository;
  final ProfileCubit _profileCubit;

  Future<void> start() => _send();

  Future<void> resend() async {
    if (state.isBusy) return;
    await _send();
  }

  Future<void> verify(String code) async {
    if (state.isBusy) return;
    emit(state.copyWith(status: VerifyContactStatus.verifying));

    final result = await _repository.verifyCode(state.channel, code);
    if (isClosed) return;

    result.fold((failure) => _onFailure(failure), (_) => _markVerified());
  }

  Future<void> _send() async {
    emit(state.copyWith(status: VerifyContactStatus.sending));

    final result = await _repository.sendCode(state.channel);
    if (isClosed) return;

    result.fold(
      (failure) => _onFailure(failure),
      (resendAfterSeconds) => emit(
        state.copyWith(
          status: VerifyContactStatus.idle,
          cooldownSeconds: resendAfterSeconds > 0 ? resendAfterSeconds : _defaultCooldownSeconds,
          restartCooldown: true,
        ),
      ),
    );
  }

  void _onFailure(Failure failure) {
    if (_alreadyVerifiedCodes.contains(failure.code)) {
      _markVerified(message: failure.displayMessage);
      return;
    }
    final isTooSoon = failure.code == _resendTooSoonCode;
    emit(
      state.copyWith(
        status: VerifyContactStatus.idle,
        cooldownSeconds: isTooSoon ? _retryAfter(failure) : null,
        restartCooldown: isTooSoon,
        errorMessage: failure.displayMessage,
      ),
    );
  }

  void _markVerified({String? message}) {
    _profileCubit.patch(
      (profile) => switch (state.channel) {
        VerificationChannel.email => profile.copyWith(emailConfirmed: true),
        VerificationChannel.phone => profile.copyWith(phoneNumberVerified: true),
      },
    );
    emit(state.copyWith(status: VerifyContactStatus.verified, message: message));
  }

  static int _retryAfter(Failure failure) => switch (failure.extensions['retryAfterSeconds']) {
    final num seconds => seconds.round(),
    final String seconds => int.tryParse(seconds) ?? _defaultCooldownSeconds,
    _ => _defaultCooldownSeconds,
  };
}
