import 'package:equatable/equatable.dart';

import '../../../../core/state/form_status.dart';

class ContactFormState extends Equatable {
  const ContactFormState({
    this.status = FormStatus.initial,
    this.errorMessage,
    this.isRateLimited = false,
  });

  final FormStatus status;
  final String? errorMessage;
  final bool isRateLimited;

  @override
  List<Object?> get props => [status, errorMessage, isRateLimited];
}
