import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/error/failures.dart';
import '../../../domain/repositories/tasks_repository.dart';
import 'task_submission_state.dart';

class TaskSubmissionCubit extends Cubit<TaskSubmissionState> {
  TaskSubmissionCubit(this._repository, {required this.taskId})
    : super(const TaskSubmissionState());

  static const _formChangedCode = 'VERIFICATION_FORM_CHANGED';
  static const _alreadySubmittedCode = 'TASK_ALREADY_SUBMITTED';
  static final _answerErrorKey = RegExp(r'^answers\[(.+)\]$', caseSensitive: false);

  final TasksRepository _repository;
  final String taskId;

  Future<void> load() async {
    emit(state.copyWith(status: TaskSubmissionLoadStatus.loading));
    final result = await _repository.getForm(taskId);
    if (isClosed) return;

    result.fold(
      (failure) => emit(
        state.copyWith(status: TaskSubmissionLoadStatus.failure, errorMessage: _messageOf(failure)),
      ),
      (form) => emit(
        state.copyWith(
          status: TaskSubmissionLoadStatus.ready,
          form: form,
          answers: {
            for (final MapEntry(:key, :value) in state.answers.entries)
              if (form.fields.any((field) => field.id == key)) key: value,
          },
        ),
      ),
    );
  }

  void setText(String fieldId, String text) => _setAnswer(fieldId, TextAnswer(text));

  void setYesNo(String fieldId, bool value) => _setAnswer(fieldId, YesNoAnswer(value));

  void toggleOption(VerificationField field, String optionId) {
    final current = switch (state.answers[field.id]) {
      ChoiceAnswer(:final optionIds) => optionIds,
      _ => const <String>{},
    };
    final next = field.type == VerificationFieldType.multipleChoice
        ? (current.contains(optionId) ? ({...current}..remove(optionId)) : {...current, optionId})
        : {optionId};
    _setAnswer(field.id, ChoiceAnswer(next));
  }

  void addFiles(String fieldId, List<PickedTaskFile> files) {
    if (files.isEmpty) return;
    _setAnswer(fieldId, FilesAnswer([..._filesOf(fieldId), ...files]));
  }

  void removeFile(String fieldId, PickedTaskFile file) {
    _setAnswer(fieldId, FilesAnswer(_filesOf(fieldId).where((item) => item != file).toList()));
  }

  bool validate() {
    final form = state.form;
    if (form == null || state.isSubmitting) return false;

    final issues = _validate(form);
    if (issues.isNotEmpty) {
      emit(state.copyWith(issues: issues, feedback: const TaskFormInvalid()));
      return false;
    }

    final totalFiles = state.answers.values.whereType<FilesAnswer>().fold<int>(
      0,
      (sum, answer) => sum + answer.files.length,
    );
    if (form.maxFilesPerSubmission > 0 && totalFiles > form.maxFilesPerSubmission) {
      emit(state.copyWith(feedback: TaskTooManyFiles(form.maxFilesPerSubmission)));
      return false;
    }
    return true;
  }

  Future<void> submit() async {
    if (!validate()) return;

    emit(state.copyWith(isSubmitting: true, issues: const {}));
    final result = await _repository.submit(taskId, state.answers);
    if (isClosed) return;

    await result.fold(
      _onSubmitFailed,
      (_) async => emit(state.copyWith(isSubmitting: false, feedback: const TaskSubmitted())),
    );
  }

  Future<void> _onSubmitFailed(Failure failure) async {
    switch (failure.code) {
      case _alreadySubmittedCode:
        emit(state.copyWith(isSubmitting: false, feedback: const TaskAlreadySubmitted()));
      case _formChangedCode:
        emit(state.copyWith(isSubmitting: false, feedback: const TaskFormChanged()));
        await load();
      default:
        final serverIssues = _serverIssues(failure);
        emit(
          state.copyWith(
            isSubmitting: false,
            issues: serverIssues,
            feedback: serverIssues.isEmpty
                ? TaskSubmitFailed(_messageOf(failure))
                : const TaskFormInvalid(),
          ),
        );
    }
  }

  Map<String, TaskFieldIssue> _validate(VerificationForm form) {
    final issues = <String, TaskFieldIssue>{};
    for (final field in form.fields) {
      final issue = _issueFor(field, state.answers[field.id], form.maxFileBytes);
      if (issue != null) issues[field.id] = issue;
    }
    return issues;
  }

  TaskFieldIssue? _issueFor(VerificationField field, TaskAnswer? answer, int maxFileBytes) {
    if (answer == null || answer.isEmpty) {
      return field.isRequired ? const TaskFieldIssue(TaskFieldIssueKind.required) : null;
    }

    switch (answer) {
      case TextAnswer(:final text):
        final maxLength = field.maxLength;
        if (maxLength != null && text.trim().length > maxLength) {
          return const TaskFieldIssue(TaskFieldIssueKind.tooLong);
        }
      case FilesAnswer(:final files):
        final maxFiles = field.maxFiles;
        if (maxFiles != null && files.length > maxFiles) {
          return const TaskFieldIssue(TaskFieldIssueKind.tooManyFiles);
        }
        if (maxFileBytes > 0 && files.any((file) => file.sizeBytes > maxFileBytes)) {
          return const TaskFieldIssue(TaskFieldIssueKind.fileTooLarge);
        }
        final accepted = field.acceptedExtensions;
        if (accepted.isNotEmpty && files.any((file) => !accepted.contains(file.extension))) {
          return const TaskFieldIssue(TaskFieldIssueKind.unsupportedFile);
        }
      case YesNoAnswer() || ChoiceAnswer():
        break;
    }
    return null;
  }

  Map<String, TaskFieldIssue> _serverIssues(Failure failure) {
    if (failure is! ValidationFailure) return const {};
    final issues = <String, TaskFieldIssue>{};
    for (final MapEntry(:key, :value) in (failure.errors ?? const {}).entries) {
      final fieldId = _answerErrorKey.firstMatch(key)?.group(1);
      if (fieldId == null) continue;
      issues[fieldId] = TaskFieldIssue(
        TaskFieldIssueKind.server,
        message: value.isEmpty ? null : value.first,
      );
    }
    return issues;
  }

  void _setAnswer(String fieldId, TaskAnswer answer) {
    emit(
      state.copyWith(
        answers: {...state.answers, fieldId: answer},
        issues: {...state.issues}..remove(fieldId),
      ),
    );
  }

  List<PickedTaskFile> _filesOf(String fieldId) => switch (state.answers[fieldId]) {
    FilesAnswer(:final files) => files,
    _ => const [],
  };

  String? _messageOf(Failure failure) =>
      failure is UnexpectedFailure ? null : failure.displayMessage;
}
