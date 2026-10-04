import 'package:equatable/equatable.dart';

import '../../../domain/repositories/tasks_repository.dart';

enum TasksListStatus { initial, loading, success, failure }

class TasksListState extends Equatable {
  const TasksListState({
    this.status = TasksListStatus.initial,
    this.items = const [],
    this.page = 0,
    this.hasNextPage = false,
    this.isLoadingMore = false,
    this.loadMoreFailed = false,
    this.errorMessage,
  });

  final TasksListStatus status;
  final List<TaskSummary> items;
  final int page;
  final bool hasNextPage;
  final bool isLoadingMore;
  final bool loadMoreFailed;
  final String? errorMessage;

  bool get canLoadMore =>
      status == TasksListStatus.success && hasNextPage && !isLoadingMore && !loadMoreFailed;

  TasksListState copyWith({
    TasksListStatus? status,
    List<TaskSummary>? items,
    int? page,
    bool? hasNextPage,
    bool? isLoadingMore,
    bool? loadMoreFailed,
    String? errorMessage,
  }) {
    return TasksListState(
      status: status ?? this.status,
      items: items ?? this.items,
      page: page ?? this.page,
      hasNextPage: hasNextPage ?? this.hasNextPage,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      loadMoreFailed: loadMoreFailed ?? this.loadMoreFailed,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    items,
    page,
    hasNextPage,
    isLoadingMore,
    loadMoreFailed,
    errorMessage,
  ];
}
