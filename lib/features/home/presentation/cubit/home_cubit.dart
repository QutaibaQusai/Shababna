import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/failures.dart';
import '../../domain/repositories/home_repository.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit(this._repository) : super(HomeState(selectedDay: _today()));

  final HomeRepository _repository;
  int _loadId = 0;

  Future<void> load({required bool isMember}) async {
    final loadId = ++_loadId;
    final today = _today();
    emit(
      HomeState(
        status: HomeStatus.loading,
        isMember: isMember,
        selectedDay: today,
        feed: state.feed,
      ),
    );

    final result = await _repository.loadFeed(isMember: isMember, day: today);
    if (isClosed || loadId != _loadId) return;

    result.fold(
      (failure) =>
          emit(state.copyWith(status: HomeStatus.failure, errorMessage: _messageOf(failure))),
      (feed) => emit(state.copyWith(status: HomeStatus.ready, feed: feed)),
    );
  }

  Future<void> refresh() => load(isMember: state.isMember);

  Future<void> selectDay(DateTime day) async {
    if (day == state.selectedDay || state.status != HomeStatus.ready) return;
    emit(state.copyWith(selectedDay: day, isDayLoading: true));

    final result = await _repository.eventsOn(day);
    if (isClosed || day != state.selectedDay) return;

    emit(
      state.copyWith(
        isDayLoading: false,
        feed: state.feed.withDayEvents(result.getOrElse(() => const [])),
      ),
    );
  }

  static DateTime _today() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  String? _messageOf(Failure failure) =>
      failure is UnexpectedFailure ? null : failure.displayMessage;
}
