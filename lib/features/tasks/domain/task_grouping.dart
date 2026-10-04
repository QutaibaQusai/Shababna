import 'repositories/tasks_repository.dart';

enum TaskTab {
  all,
  todo,
  inReview,
  completed;

  static TaskTab of(TaskSubmissionStatus? status) => switch (status) {
    null || TaskSubmissionStatus.rejected => todo,
    TaskSubmissionStatus.pending => inReview,
    TaskSubmissionStatus.approved => completed,
  };

  bool includes(TaskSummary task) => this == all || this == task.tab;
}

enum TaskDueWindow {
  overdue,
  thisWeek,
  later,
  noDueDate;

  static const _weekDays = 7;

  static TaskDueWindow of(DateTime? dueAt, DateTime now) {
    if (dueAt == null) return noDueDate;
    if (dueAt.isBefore(now)) return overdue;
    return dueAt.difference(now).inDays < _weekDays ? thisWeek : later;
  }
}

extension TaskSummaryGrouping on TaskSummary {
  TaskTab get tab => TaskTab.of(submissionStatus);
}

int compareTasksByPriority(TaskSummary a, TaskSummary b) {
  final byTab = a.tab.index.compareTo(b.tab.index);
  if (byTab != 0) return byTab;
  return a.tab == TaskTab.completed ? compareTasksByDue(b, a) : compareTasksByDue(a, b);
}

int compareTasksByDue(TaskSummary a, TaskSummary b) {
  final first = a.dueAt;
  final second = b.dueAt;
  if (first == null && second == null) return 0;
  if (first == null) return 1;
  if (second == null) return -1;
  return first.compareTo(second);
}
