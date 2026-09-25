import 'package:equatable/equatable.dart';

import '../../../../core/state/form_status.dart';

class ContactFormState extends Equatable {
  const ContactFormState({this.status = FormStatus.initial, this.errorMessage});

  final FormStatus status;
  final String? errorMessage;

  ContactFormState copyWith({FormStatus? status, String? errorMessage}) {
    return ContactFormState(
      status: status ?? this.status,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, errorMessage];
}
