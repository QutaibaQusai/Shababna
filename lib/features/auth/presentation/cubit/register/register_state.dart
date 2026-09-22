import 'package:equatable/equatable.dart';

import '../../../../../core/state/form_status.dart';
import '../../../domain/repositories/auth_repository.dart';

class RegisterState extends Equatable {
  const RegisterState({
    this.status = FormStatus.initial,
    this.errorMessage,
    this.phoneCodes = const [],
    this.isLoadingPhoneCodes = false,
    this.phoneCodesError,
  });

  final FormStatus status;
  final String? errorMessage;
  final List<CountryPhoneCode> phoneCodes;
  final bool isLoadingPhoneCodes;
  final String? phoneCodesError;

  RegisterState copyWith({
    FormStatus? status,
    String? errorMessage,
    List<CountryPhoneCode>? phoneCodes,
    bool? isLoadingPhoneCodes,
    String? phoneCodesError,
  }) {
    return RegisterState(
      status: status ?? this.status,
      errorMessage: errorMessage,
      phoneCodes: phoneCodes ?? this.phoneCodes,
      isLoadingPhoneCodes: isLoadingPhoneCodes ?? this.isLoadingPhoneCodes,
      phoneCodesError: phoneCodesError,
    );
  }

  @override
  List<Object?> get props => [
        status,
        errorMessage,
        phoneCodes,
        isLoadingPhoneCodes,
        phoneCodesError,
      ];
}
