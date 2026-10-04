import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/error/failures.dart';
import '../../../domain/repositories/tasks_repository.dart';

sealed class TaskFileFeedback extends Equatable {
  const TaskFileFeedback();

  @override
  List<Object?> get props => [];
}

class TaskFileReady extends TaskFileFeedback {
  const TaskFileReady(this.path);

  final String path;

  @override
  List<Object?> get props => [path];
}

class TaskFileFailed extends TaskFileFeedback {
  const TaskFileFailed(this.message);

  final String? message;

  @override
  List<Object?> get props => [message];
}

class TaskDetailsState extends Equatable {
  const TaskDetailsState({
    this.isLoading = false,
    this.task,
    this.submission,
    this.hasError = false,
    this.errorMessage,
    this.busyFileId,
    this.fileFeedback,
    this.hasChanges = false,
  });

  final bool isLoading;
  final TaskDetails? task;
  final TaskSubmission? submission;
  final bool hasError;
  final String? errorMessage;
  final String? busyFileId;
  final TaskFileFeedback? fileFeedback;
  final bool hasChanges;

  TaskDetailsState copyWith({
    bool? isLoading,
    TaskDetails? task,
    TaskSubmission? submission,
    String? busyFileId,
    TaskFileFeedback? fileFeedback,
    bool? hasChanges,
  }) {
    return TaskDetailsState(
      isLoading: isLoading ?? this.isLoading,
      task: task ?? this.task,
      submission: submission ?? this.submission,
      hasError: hasError,
      errorMessage: errorMessage,
      busyFileId: busyFileId,
      fileFeedback: fileFeedback,
      hasChanges: hasChanges ?? this.hasChanges,
    );
  }

  @override
  List<Object?> get props => [
    isLoading,
    task,
    submission,
    hasError,
    errorMessage,
    busyFileId,
    fileFeedback,
    hasChanges,
  ];
}

class TaskDetailsCubit extends Cubit<TaskDetailsState> {
  TaskDetailsCubit(this._repository, {required this.id}) : super(const TaskDetailsState());

  final TasksRepository _repository;
  final String id;

  Future<void> load() async {
    if (state.isLoading) return;
    emit(state.copyWith(isLoading: true));

    final result = await _repository.getTask(id);
    if (isClosed) return;

    await result.fold(
      (failure) async => emit(
        state.task != null
            ? state.copyWith(isLoading: false)
            : TaskDetailsState(hasError: true, errorMessage: _messageOf(failure)),
      ),
      (task) async {
        final submission = task.submissionStatus == null ? null : await _loadSubmission();
        if (isClosed) return;
        emit(TaskDetailsState(task: task, submission: submission, hasChanges: state.hasChanges));
      },
    );
  }

  Future<void> reloadAfterSubmit() async {
    await load();
    if (!isClosed) emit(state.copyWith(hasChanges: true));
  }

  Future<void> openAttachment(TaskAttachment attachment) {
    return _open(attachment.id, () => _repository.downloadAttachment(id, attachment));
  }

  Future<void> openSubmissionFile(SubmittedFile file) {
    return _open(file.id, () => _repository.downloadSubmissionFile(id, file));
  }

  Future<void> _open(String fileId, Future<Either<Failure, String>> Function() download) async {
    if (state.busyFileId != null) return;
    emit(state.copyWith(busyFileId: fileId));

    final result = await download();
    if (isClosed) return;

    emit(
      state.copyWith(
        fileFeedback: result.fold(
          (failure) => TaskFileFailed(_messageOf(failure)),
          TaskFileReady.new,
        ),
      ),
    );
  }

  Future<TaskSubmission?> _loadSubmission() async {
    final result = await _repository.getSubmission(id);
    return result.fold((_) => null, (submission) => submission);
  }

  String? _messageOf(Failure failure) =>
      failure is UnexpectedFailure ? null : failure.displayMessage;
}
