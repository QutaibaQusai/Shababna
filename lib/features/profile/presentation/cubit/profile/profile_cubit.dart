import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/repositories/profile_repository.dart';
import 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit(this._repository) : super(const ProfileState());

  final ProfileRepository _repository;

  Future<void> loadProfile() async {
    emit(state.copyWith(isLoading: true, errorMessage: null));

    final result = await _repository.getProfile();

    result.fold(
      (failure) => emit(
        state.copyWith(isLoading: false, errorMessage: failure.displayMessage),
      ),
      (profile) => emit(state.copyWith(isLoading: false, profile: profile)),
    );
  }
}
