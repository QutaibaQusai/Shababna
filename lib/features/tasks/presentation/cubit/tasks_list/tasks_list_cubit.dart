import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/network/paged_result.dart';
import '../../../domain/repositories/tasks_repository.dart';
import 'tasks_list_state.dart';

class TasksListCubit extends Cubit<TasksListState> {
  TasksListCubit(this._repository, {this.eventId}) : super(const TasksListState());

  static const pageSize = 20;

  final TasksRepository _repository;
  final String? eventId;

  Future<void> loadFirstPage() async {
    if (state.status == TasksListStatus.loading) return;
    emit(state.copyWith(status: TasksListStatus.loading));
    await _fetchFirstPage();
  }

  Future<void> refresh() => _fetchFirstPage();

  Future<void> loadMore() async {
    if (!state.canLoadMore) return;
    emit(state.copyWith(isLoadingMore: true, loadMoreFailed: false));

    final nextPage = state.page + 1;
    final result = await _fetch(nextPage);
    if (isClosed) return;

    result.fold(
      (_) => emit(state.copyWith(isLoadingMore: false, loadMoreFailed: true)),
      (paged) => emit(
        state.copyWith(
          items: [...state.items, ...paged.items],
          page: nextPage,
          hasNextPage: paged.hasNextPage,
          isLoadingMore: false,
        ),
      ),
    );
  }

  Future<void> retryLoadMore() {
    emit(state.copyWith(loadMoreFailed: false));
    return loadMore();
  }

  Future<void> _fetchFirstPage() async {
    final result = await _fetch(1);
    if (isClosed) return;

    result.fold(
      (failure) => emit(
        state.items.isEmpty
            ? state.copyWith(status: TasksListStatus.failure, errorMessage: _messageOf(failure))
            : state.copyWith(status: TasksListStatus.success),
      ),
      (paged) => emit(
        TasksListState(
          status: TasksListStatus.success,
          items: paged.items,
          page: 1,
          hasNextPage: paged.hasNextPage,
        ),
      ),
    );
  }

  String? _messageOf(Failure failure) =>
      failure is UnexpectedFailure ? null : failure.displayMessage;

  Future<Either<Failure, PagedResult<TaskSummary>>> _fetch(int page) {
    final eventId = this.eventId;
    return eventId == null
        ? _repository.getMyTasks(page: page, pageSize: pageSize)
        : _repository.getEventTasks(eventId, page: page, pageSize: pageSize);
  }
}
