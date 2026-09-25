import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/state/form_status.dart';
import '../../../domain/repositories/profile_phone_repository.dart';
import 'change_phone_number_state.dart';

class ChangePhoneNumberCubit extends Cubit<ChangePhoneNumberState> {
  ChangePhoneNumberCubit(this._repository) : super(const ChangePhoneNumberState());

  final ProfilePhoneRepository _repository;

  Future<void> submit(String phoneNumber) async {
    emit(const ChangePhoneNumberState(status: FormStatus.submitting));

    final result = await _repository.updatePhoneNumber(phoneNumber);

    result.fold(
      (failure) => emit(
        ChangePhoneNumberState(status: FormStatus.failure, errorMessage: failure.displayMessage),
      ),
      (_) => emit(const ChangePhoneNumberState(status: FormStatus.success)),
    );
  }
}
