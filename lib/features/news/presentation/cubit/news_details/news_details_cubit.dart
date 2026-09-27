import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/error/failures.dart';
import '../../../domain/repositories/news_repository.dart';
import 'news_details_state.dart';

class NewsDetailsCubit extends Cubit<NewsDetailsState> {
  NewsDetailsCubit(this._repository, {required this.id}) : super(const NewsDetailsState());

  final NewsRepository _repository;
  final String id;

  Future<void> load() async {
    if (state.isLoading) return;
    emit(const NewsDetailsState(isLoading: true));

    final result = await _repository.getNewsById(id);
    if (isClosed) return;

    result.fold(
      (failure) => emit(NewsDetailsState(
        hasError: true,
        errorMessage: failure is UnexpectedFailure ? null : failure.displayMessage,
      )),
      (article) => emit(NewsDetailsState(article: article)),
    );
  }
}
