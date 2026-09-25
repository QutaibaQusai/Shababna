import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/state/form_status.dart';
import '../../domain/repositories/contact_form_repository.dart';
import 'contact_form_state.dart';

class ContactFormCubit extends Cubit<ContactFormState> {
  ContactFormCubit(this._repository) : super(const ContactFormState());

  final ContactFormRepository _repository;

  Future<void> submit({
    required String fullName,
    required String email,
    required String subject,
    required String body,
  }) async {
    emit(const ContactFormState(status: FormStatus.submitting));

    final result = await _repository.submitContactForm(
      fullName: fullName,
      email: email,
      subject: subject,
      body: body,
    );

    result.fold(
      (failure) => emit(
        ContactFormState(status: FormStatus.failure, errorMessage: failure.displayMessage),
      ),
      (_) => emit(const ContactFormState(status: FormStatus.success)),
    );
  }
}
