import 'package:equatable/equatable.dart';

import '../../../domain/repositories/auth_repository.dart';

class PhoneCodesState extends Equatable {
  const PhoneCodesState({
    this.codes = const [],
    this.selected,
    this.isLoading = false,
    this.errorMessage,
  });

  final List<CountryPhoneCode> codes;
  final CountryPhoneCode? selected;
  final bool isLoading;
  final String? errorMessage;

  bool get isLoaded => codes.isNotEmpty;

  PhoneCodesState copyWith({
    List<CountryPhoneCode>? codes,
    CountryPhoneCode? selected,
    bool? isLoading,
    String? errorMessage,
  }) {
    return PhoneCodesState(
      codes: codes ?? this.codes,
      selected: selected ?? this.selected,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [codes, selected, isLoading, errorMessage];
}
