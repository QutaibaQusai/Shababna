import 'package:equatable/equatable.dart';

import '../../../../../core/state/form_status.dart';
import '../../../domain/repositories/profile_lookups_repository.dart';

class ChangePhoneNumberState extends Equatable {
  const ChangePhoneNumberState({
    this.phoneCodes = const [],
    this.isLoadingPhoneCodes = false,
    this.hasPhoneCodesError = false,
    this.phoneCodesError,
    this.status = FormStatus.initial,
    this.errorMessage,
  });

  final List<PhoneCode> phoneCodes;
  final bool isLoadingPhoneCodes;
  final bool hasPhoneCodesError;
  final String? phoneCodesError;
  final FormStatus status;
  final String? errorMessage;

  bool get isSubmitting => status == FormStatus.submitting;

  ChangePhoneNumberState copyWith({
    List<PhoneCode>? phoneCodes,
    bool? isLoadingPhoneCodes,
    bool? hasPhoneCodesError,
    String? phoneCodesError,
    FormStatus? status,
    String? errorMessage,
  }) {
    return ChangePhoneNumberState(
      phoneCodes: phoneCodes ?? this.phoneCodes,
      isLoadingPhoneCodes: isLoadingPhoneCodes ?? this.isLoadingPhoneCodes,
      hasPhoneCodesError: hasPhoneCodesError ?? false,
      phoneCodesError: phoneCodesError,
      status: status ?? this.status,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        phoneCodes,
        isLoadingPhoneCodes,
        hasPhoneCodesError,
        phoneCodesError,
        status,
        errorMessage,
      ];
}
