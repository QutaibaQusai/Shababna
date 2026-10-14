import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/error/failures.dart';
import '../../../domain/repositories/notifications_repository.dart';
import 'notifications_list_state.dart';

class NotificationsListCubit extends Cubit<NotificationsListState> {
  NotificationsListCubit(this._repository)
    : super(const NotificationsListState());

  static const pageSize = 20;

  final NotificationsRepository _repository;

  Future<void> loadFirstPage() async {
    if (state.status == NotificationsListStatus.loading) return;
    emit(state.copyWith(status: NotificationsListStatus.loading));
    await _fetchFirstPage();
  }

  Future<void> refresh() => loadFirstPage();

  Future<void> loadMore() async {
    if (!state.canLoadMore) return;
    emit(state.copyWith(isLoadingMore: true, loadMoreFailed: false));

    final nextPage = state.page + 1;
    final result = await _repository.getNotifications(
      page: nextPage,
      pageSize: pageSize,
    );
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

  void markRead(String id) {
    emit(
      state.copyWith(
        items: [
          for (final item in state.items)
            item.id == id ? item.markedRead() : item,
        ],
      ),
    );
  }

  Future<void> _fetchFirstPage() async {
    final result = await _repository.getNotifications(
      page: 1,
      pageSize: pageSize,
    );
    if (isClosed) return;

    result.fold(
      (failure) => emit(
        state.items.isEmpty
            ? state.copyWith(
                status: NotificationsListStatus.failure,
                errorMessage: _messageOf(failure),
              )
            : state.copyWith(status: NotificationsListStatus.success),
      ),
      (paged) => emit(
        NotificationsListState(
          status: NotificationsListStatus.success,
          items: paged.items,
          page: 1,
          hasNextPage: paged.hasNextPage,
        ),
      ),
    );
  }

  String? _messageOf(Failure failure) =>
      failure is UnexpectedFailure ? null : failure.displayMessage;
}
