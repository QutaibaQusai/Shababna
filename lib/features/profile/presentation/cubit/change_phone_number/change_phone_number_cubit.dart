import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/state/form_status.dart';
import '../../../domain/repositories/profile_lookups_repository.dart';
import '../../../domain/repositories/profile_repository.dart';
import '../../utils/failure_message.dart';
import '../profile/profile_cubit.dart';
import 'change_phone_number_state.dart';

class ChangePhoneNumberCubit extends Cubit<ChangePhoneNumberState> {
  ChangePhoneNumberCubit(this._repository, this._lookupsRepository, this._profileCubit)
      : super(const ChangePhoneNumberState());

  final ProfileRepository _repository;
  final ProfileLookupsRepository _lookupsRepository;
  final ProfileCubit _profileCubit;

  Future<void> loadPhoneCodes() async {
    if (state.isLoadingPhoneCodes) return;
    emit(state.copyWith(isLoadingPhoneCodes: true));

    final result = await _lookupsRepository.getPhoneCodes();
    if (isClosed) return;

    result.fold(
      (failure) => emit(state.copyWith(
        isLoadingPhoneCodes: false,
        hasPhoneCodesError: true,
        phoneCodesError: failure.userMessage,
      )),
      (phoneCodes) => emit(state.copyWith(isLoadingPhoneCodes: false, phoneCodes: phoneCodes)),
    );
  }

  Future<void> submit(String phoneNumber) async {
    if (state.isSubmitting) return;
    emit(state.copyWith(status: FormStatus.submitting));

    final result = await _repository.updatePhoneNumber(phoneNumber);
    if (isClosed) return;

    result.fold(
      (failure) => emit(
        state.copyWith(status: FormStatus.failure, errorMessage: failure.userMessage),
      ),
      (_) {
        _profileCubit.patch((profile) => profile.copyWith(phoneNumber: phoneNumber));
        emit(state.copyWith(status: FormStatus.success));
      },
    );
  }
}
