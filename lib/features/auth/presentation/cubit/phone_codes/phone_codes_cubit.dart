import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/repositories/auth_repository.dart';
import 'phone_codes_state.dart';

class PhoneCodesCubit extends Cubit<PhoneCodesState> {
  PhoneCodesCubit(this._repository) : super(const PhoneCodesState());

  static const _defaultCountryCode = 'JO';

  final AuthRepository _repository;

  Future<void> ensureLoaded() async {
    if (state.isLoaded || state.isLoading) return;
    await _load();
  }

  Future<void> retry() => _load();

  void select(CountryPhoneCode code) => emit(state.copyWith(selected: code));

  Future<void> _load() async {
    emit(state.copyWith(isLoading: true));

    final result = await _repository.getPhoneCodes();
    if (isClosed) return;

    result.fold(
      (failure) => emit(state.copyWith(isLoading: false, errorMessage: failure.displayMessage)),
      (codes) => emit(
        state.copyWith(
          codes: codes,
          selected: state.selected ?? _defaultFrom(codes),
          isLoading: false,
        ),
      ),
    );
  }

  static CountryPhoneCode? _defaultFrom(List<CountryPhoneCode> codes) {
    if (codes.isEmpty) return null;
    return codes.firstWhere(
      (code) => code.countryCode == _defaultCountryCode,
      orElse: () => codes.first,
    );
  }
}
