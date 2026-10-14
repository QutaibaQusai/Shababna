import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/repositories/onboarding_repository.dart';

class OnboardingCubit extends Cubit<bool> {
  OnboardingCubit(this._repository) : super(false);

  final OnboardingRepository _repository;

  Future<void> complete() async {
    if (state) return;
    emit(true);
    await _repository.complete();
  }
}
