import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/repositories/dashboard_repository.dart';
import 'dashboard_state.dart';

class DashboardCubit extends Cubit<DashboardState> {
  DashboardCubit(this._repository) : super(const DashboardState());

  final DashboardRepository _repository;

  Future<void> load() async {
    if (state.status == DashboardStatus.loading) return;
    emit(const DashboardState(status: DashboardStatus.loading));

    final result = await _repository.getDashboard();
    if (isClosed) return;

    result.fold(
      (failure) => emit(
        DashboardState(
          status: DashboardStatus.failure,
          errorMessage: failure.displayMessage,
        ),
      ),
      (dashboard) => emit(
        DashboardState(status: DashboardStatus.success, dashboard: dashboard),
      ),
    );
  }

  Future<void> refresh() => load();
}
