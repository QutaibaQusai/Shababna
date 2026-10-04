import 'package:equatable/equatable.dart';

import '../../../domain/repositories/tasks_repository.dart';

enum TaskSubmissionLoadStatus { loading, ready, failure }

enum TaskFieldIssueKind { required, tooLong, tooManyFiles, fileTooLarge, unsupportedFile, server }

class TaskFieldIssue extends Equatable {
  const TaskFieldIssue(this.kind, {this.message});

  final TaskFieldIssueKind kind;
  final String? message;

  @override
  List<Object?> get props => [kind, message];
}

sealed class TaskSubmissionFeedback extends Equatable {
  const TaskSubmissionFeedback();

  @override
  List<Object?> get props => [];
}

class TaskSubmitted extends TaskSubmissionFeedback {
  const TaskSubmitted();
}

class TaskAlreadySubmitted extends TaskSubmissionFeedback {
  const TaskAlreadySubmitted();
}

class TaskFormChanged extends TaskSubmissionFeedback {
  const TaskFormChanged();
}

class TaskFormInvalid extends TaskSubmissionFeedback {
  const TaskFormInvalid();
}

class TaskTooManyFiles extends TaskSubmissionFeedback {
  const TaskTooManyFiles(this.limit);

  final int limit;

  @override
  List<Object?> get props => [limit];
}

class TaskSubmitFailed extends TaskSubmissionFeedback {
  const TaskSubmitFailed(this.message);

  final String? message;

  @override
  List<Object?> get props => [message];
}

class TaskSubmissionState extends Equatable {
  const TaskSubmissionState({
    this.status = TaskSubmissionLoadStatus.loading,
    this.form,
    this.answers = const {},
    this.issues = const {},
    this.isSubmitting = false,
    this.errorMessage,
    this.feedback,
  });

  final TaskSubmissionLoadStatus status;
  final VerificationForm? form;
  final Map<String, TaskAnswer> answers;
  final Map<String, TaskFieldIssue> issues;
  final bool isSubmitting;
  final String? errorMessage;
  final TaskSubmissionFeedback? feedback;

  List<VerificationField> get _fields => form?.fields ?? const [];

  bool _isAnswered(VerificationField field) => !(answers[field.id]?.isEmpty ?? true);

  int get totalCount => _fields.length;

  int get answeredCount => _fields.where(_isAnswered).length;

  int get requiredLeft => _fields.where((field) => field.isRequired && !_isAnswered(field)).length;

  TaskSubmissionState copyWith({
    TaskSubmissionLoadStatus? status,
    VerificationForm? form,
    Map<String, TaskAnswer>? answers,
    Map<String, TaskFieldIssue>? issues,
    bool? isSubmitting,
    String? errorMessage,
    TaskSubmissionFeedback? feedback,
  }) {
    return TaskSubmissionState(
      status: status ?? this.status,
      form: form ?? this.form,
      answers: answers ?? this.answers,
      issues: issues ?? this.issues,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      errorMessage: errorMessage,
      feedback: feedback,
    );
  }

  @override
  List<Object?> get props => [status, form, answers, issues, isSubmitting, errorMessage, feedback];
}
