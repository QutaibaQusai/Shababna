import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/error/failures.dart';
import '../../../domain/repositories/events_repository.dart';
import 'events_list_state.dart';

class EventsListCubit extends Cubit<EventsListState> {
  EventsListCubit(this._repository) : super(const EventsListState());

  static const pageSize = 10;

  final EventsRepository _repository;

  Future<void> loadFirstPage() async {
    if (state.status == EventsListStatus.loading) return;
    emit(state.copyWith(status: EventsListStatus.loading));
    await _fetchFirstPage();
  }

  Future<void> refresh() => loadFirstPage();

  Future<void> loadMore() async {
    if (!state.canLoadMore) return;
    emit(state.copyWith(isLoadingMore: true, loadMoreFailed: false));

    final nextPage = state.page + 1;
    final result = await _repository.getEvents(page: nextPage, pageSize: pageSize);
    if (isClosed) return;

    result.fold(
      (_) => emit(state.copyWith(isLoadingMore: false, loadMoreFailed: true)),
      (paged) => emit(state.copyWith(
        items: [...state.items, ...paged.items],
        page: nextPage,
        hasNextPage: paged.hasNextPage,
        isLoadingMore: false,
      )),
    );
  }

  Future<void> retryLoadMore() {
    emit(state.copyWith(loadMoreFailed: false));
    return loadMore();
  }

  Future<void> _fetchFirstPage() async {
    final result = await _repository.getEvents(page: 1, pageSize: pageSize);
    if (isClosed) return;

    result.fold(
      (failure) => emit(
        state.items.isEmpty
            ? state.copyWith(status: EventsListStatus.failure, errorMessage: _messageOf(failure))
            : state.copyWith(status: EventsListStatus.success),
      ),
      (paged) => emit(EventsListState(
        status: EventsListStatus.success,
        items: paged.items,
        page: 1,
        hasNextPage: paged.hasNextPage,
      )),
    );
  }

  String? _messageOf(Failure failure) =>
      failure is UnexpectedFailure ? null : failure.displayMessage;
}
