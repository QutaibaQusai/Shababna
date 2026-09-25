import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/repositories/about_us_repository.dart';
import 'about_us_state.dart';

class AboutUsCubit extends Cubit<AboutUsState> {
  AboutUsCubit(this._repository) : super(const AboutUsState());

  final AboutUsRepository _repository;

  Future<void> loadAboutUs() async {
    emit(state.copyWith(isLoading: true, errorMessage: null));

    final result = await _repository.getAboutUs();

    result.fold(
      (failure) => emit(
        state.copyWith(isLoading: false, errorMessage: failure.displayMessage),
      ),
      (content) => emit(state.copyWith(isLoading: false, content: content)),
    );
  }
}
