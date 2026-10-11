import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/error/failures.dart';
import '../../../domain/repositories/volunteering_opportunities_repository.dart';
import 'volunteering_opportunities_list_state.dart';

class VolunteeringOpportunitiesListCubit extends Cubit<VolunteeringOpportunitiesListState> {
  VolunteeringOpportunitiesListCubit(this._repository, {DateTime? initialDate})
    : super(VolunteeringOpportunitiesListState(date: initialDate));

  static const pageSize = 10;

  final VolunteeringOpportunitiesRepository _repository;

  Future<void> loadFirstPage() async {
    if (state.status == VolunteeringOpportunitiesListStatus.loading) return;
    emit(state.copyWith(status: VolunteeringOpportunitiesListStatus.loading));
    await _fetchFirstPage();
  }

  Future<void> refresh() => loadFirstPage();

  Future<void> selectType(String? typeId) => _applyFilter(typeId: typeId, date: state.date);

  Future<void> selectDate(DateTime? date) => _applyFilter(typeId: state.typeId, date: date);

  Future<void> loadMore() async {
    if (!state.canLoadMore) return;
    emit(state.copyWith(isLoadingMore: true, loadMoreFailed: false));

    final filter = (state.typeId, state.date);
    final nextPage = state.page + 1;
    final result = await _repository.getVolunteeringOpportunities(
      page: nextPage,
      pageSize: pageSize,
      typeId: filter.$1,
      date: filter.$2,
    );
    if (isClosed || filter != (state.typeId, state.date)) return;

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

  Future<void> _applyFilter({required String? typeId, required DateTime? date}) async {
    if (typeId == state.typeId && date == state.date) return;
    emit(
      VolunteeringOpportunitiesListState(
        status: VolunteeringOpportunitiesListStatus.loading,
        typeId: typeId,
        date: date,
      ),
    );
    await _fetchFirstPage();
  }

  Future<void> _fetchFirstPage() async {
    final filter = (state.typeId, state.date);
    final result = await _repository.getVolunteeringOpportunities(
      page: 1,
      pageSize: pageSize,
      typeId: filter.$1,
      date: filter.$2,
    );
    if (isClosed || filter != (state.typeId, state.date)) return;

    result.fold(
      (failure) => emit(
        state.items.isEmpty
            ? state.copyWith(
                status: VolunteeringOpportunitiesListStatus.failure,
                errorMessage: _messageOf(failure),
              )
            : state.copyWith(status: VolunteeringOpportunitiesListStatus.success),
      ),
      (paged) => emit(
        VolunteeringOpportunitiesListState(
          status: VolunteeringOpportunitiesListStatus.success,
          typeId: filter.$1,
          date: filter.$2,
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
