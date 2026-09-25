import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/repositories/social_media_repository.dart';
import 'social_media_state.dart';

class SocialMediaCubit extends Cubit<SocialMediaState> {
  SocialMediaCubit(this._repository) : super(const SocialMediaState());

  final SocialMediaRepository _repository;

  Future<void> loadSocialMediaLinks() async {
    emit(state.copyWith(isLoading: true, errorMessage: null));

    final result = await _repository.getSocialMediaLinks();

    result.fold(
      (failure) => emit(
        state.copyWith(isLoading: false, errorMessage: failure.displayMessage),
      ),
      (links) => emit(state.copyWith(isLoading: false, links: links)),
    );
  }
}
