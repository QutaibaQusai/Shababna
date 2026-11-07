import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/failures.dart';
import '../../domain/repositories/home_repository.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit(this._repository) : super(HomeState(selectedDay: _today()));

  static const whatsOnDayCount = 10;

  final HomeRepository _repository;
  int _loadId = 0;

  Future<void> load({required bool isMember}) async {
    final loadId = ++_loadId;
    final today = _today();
    final days = [
      for (var i = 0; i < whatsOnDayCount; i++) DateTime(today.year, today.month, today.day + i),
    ];
    emit(
      HomeState(
        status: HomeStatus.loading,
        isMember: isMember,
        selectedDay: today,
        whatsOnDays: days,
        feed: state.feed,
      ),
    );

    final result = await _repository.loadFeed(isMember: isMember, days: days);
    if (isClosed || loadId != _loadId) return;

    result.fold(
      (failure) =>
          emit(state.copyWith(status: HomeStatus.failure, errorMessage: _messageOf(failure))),
      (feed) => emit(state.copyWith(status: HomeStatus.ready, feed: feed)),
    );
  }

  Future<void> refresh() => load(isMember: state.isMember);

  void selectDay(DateTime day) {
    if (day == state.selectedDay || state.status != HomeStatus.ready) return;
    emit(state.copyWith(selectedDay: day));
  }

  static DateTime _today() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  String? _messageOf(Failure failure) =>
      failure is UnexpectedFailure ? null : failure.displayMessage;
}
