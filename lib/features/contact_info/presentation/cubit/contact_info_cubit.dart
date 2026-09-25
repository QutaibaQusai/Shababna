import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/repositories/contact_info_repository.dart';
import 'contact_info_state.dart';

class ContactInfoCubit extends Cubit<ContactInfoState> {
  ContactInfoCubit(this._repository) : super(const ContactInfoState());

  final ContactInfoRepository _repository;

  Future<void> loadContactInfo() async {
    emit(state.copyWith(isLoading: true, errorMessage: null));

    final result = await _repository.getContactInfo();

    result.fold(
      (failure) => emit(
        state.copyWith(isLoading: false, errorMessage: failure.displayMessage),
      ),
      (content) => emit(state.copyWith(isLoading: false, content: content)),
    );
  }
}
