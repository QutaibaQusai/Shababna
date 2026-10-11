import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/error/failures.dart';
import '../../../domain/repositories/tasks_repository.dart';
import '../../../domain/task_grouping.dart';
import 'tasks_list_state.dart';

class TasksListCubit extends Cubit<TasksListState> {
  TasksListCubit(this._repository, {this.volunteeringOpportunityId})
    : super(const TasksListState());

  final TasksRepository _repository;
  final String? volunteeringOpportunityId;

  Future<void> load() async {
    if (state.status == TasksListStatus.loading) return;
    emit(state.copyWith(status: TasksListStatus.loading));
    await _fetch();
  }

  Future<void> refresh() => load();

  Future<void> reload() => _fetch();

  void selectTab(TaskTab tab) {
    if (tab != state.tab) emit(state.copyWith(tab: tab));
  }

  Future<void> _fetch() async {
    final result = await _repository.getAssignedTasks(
      volunteeringOpportunityId: volunteeringOpportunityId,
    );
    if (isClosed) return;

    result.fold(
      (failure) => emit(
        state.items.isEmpty
            ? state.copyWith(status: TasksListStatus.failure, errorMessage: _messageOf(failure))
            : state.copyWith(status: TasksListStatus.success),
      ),
      (tasks) => emit(state.copyWith(status: TasksListStatus.success, items: tasks)),
    );
  }

  String? _messageOf(Failure failure) =>
      failure is UnexpectedFailure ? null : failure.displayMessage;
}
