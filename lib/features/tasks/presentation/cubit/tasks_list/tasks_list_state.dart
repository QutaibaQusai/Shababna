import 'package:equatable/equatable.dart';

import '../../../domain/repositories/tasks_repository.dart';
import '../../../domain/task_grouping.dart';

enum TasksListStatus { initial, loading, success, failure }

class TasksListState extends Equatable {
  const TasksListState({
    this.status = TasksListStatus.initial,
    this.items = const [],
    this.tab = TaskTab.all,
    this.errorMessage,
  });

  final TasksListStatus status;
  final List<TaskSummary> items;
  final TaskTab tab;
  final String? errorMessage;

  int countOf(TaskTab tab) => items.where(tab.includes).length;

  int get completedCount => countOf(TaskTab.completed);

  double get earnedHours => items
      .where((task) => task.tab == TaskTab.completed)
      .fold(0, (total, task) => total + task.volunteeringHours);

  List<TaskSummary> get visible => items.where(tab.includes).toList()..sort(compareTasksByPriority);

  TasksListState copyWith({
    TasksListStatus? status,
    List<TaskSummary>? items,
    TaskTab? tab,
    String? errorMessage,
  }) {
    return TasksListState(
      status: status ?? this.status,
      items: items ?? this.items,
      tab: tab ?? this.tab,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, items, tab, errorMessage];
}
