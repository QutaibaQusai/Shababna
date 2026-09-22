import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/repositories/legal_repository.dart';
import 'legal_state.dart';

class LegalCubit extends Cubit<LegalState> {
  LegalCubit(this._repository) : super(const LegalState());

  final LegalRepository _repository;

  Future<void> loadContent() async {
    emit(state.copyWith(isLoading: true, errorMessage: null));

    final result = await _repository.getContent();

    result.fold(
      (failure) => emit(
        state.copyWith(isLoading: false, errorMessage: failure.displayMessage),
      ),
      (content) => emit(state.copyWith(isLoading: false, content: content)),
    );
  }
}
