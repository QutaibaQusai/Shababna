import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/notifications/push_device_registrar.dart';
import '../../../../../core/state/form_status.dart';
import '../../../domain/repositories/profile_email_repository.dart';
import '../../utils/failure_message.dart';
import '../profile/profile_cubit.dart';
import 'verify_email_change_state.dart';

class VerifyEmailChangeCubit extends Cubit<VerifyEmailChangeState> {
  VerifyEmailChangeCubit(
    this._repository,
    this._profileCubit,
    this._pushRegistrar, {
    required this.newEmail,
  }) : super(const VerifyEmailChangeState());

  final ProfileEmailRepository _repository;
  final ProfileCubit _profileCubit;
  final PushDeviceRegistrar _pushRegistrar;
  final String newEmail;

  Future<void> verify(String code) async {
    if (state.isSubmitting || state.status == FormStatus.success) return;
    emit(state.copyWith(status: FormStatus.submitting));

    final result = await _repository.verifyEmailChange(code);
    if (isClosed) return;

    result.fold(
      (failure) => emit(
        state.copyWith(status: FormStatus.failure, errorMessage: failure.userMessage),
      ),
      (_) {
        _profileCubit.patch(
          (profile) => profile.copyWith(email: newEmail, emailConfirmed: true),
        );
        unawaited(_pushRegistrar.refresh(force: true));
        emit(state.copyWith(status: FormStatus.success));
      },
    );
  }

  Future<void> resend() async {
    if (state.isResending) return;
    emit(state.copyWith(resendStatus: FormStatus.submitting));

    final result = await _repository.resendEmailChangeCode();
    if (isClosed) return;

    result.fold(
      (failure) => emit(
        state.copyWith(resendStatus: FormStatus.failure, resendError: failure.userMessage),
      ),
      (_) => emit(state.copyWith(resendStatus: FormStatus.success)),
    );
  }
}
