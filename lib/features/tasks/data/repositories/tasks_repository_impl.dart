import 'package:dartz/dartz.dart';

import '../../../../core/data/repository_guard_mixin.dart';
import '../../../../core/error/failures.dart';
import '../../domain/repositories/tasks_repository.dart';
import '../datasources/tasks_remote_data_source.dart';
import '../mappers/tasks_mapper.dart';

class TasksRepositoryImpl with RepositoryGuardMixin implements TasksRepository {
  TasksRepositoryImpl(this._remoteDataSource);

  static const _notFoundCode = 'RESOURCE_NOT_FOUND';
  static const _pageSize = 100;
  static const _maxPages = 5;

  final TasksRemoteDataSource _remoteDataSource;

  @override
  Future<Either<Failure, List<TaskSummary>>> getAssignedTasks({String? eventId}) {
    return guard(() async {
      final tasks = <TaskSummary>[];
      for (var page = 1; page <= _maxPages; page++) {
        final response = eventId == null
            ? await _remoteDataSource.getMyTasks(page: page, pageSize: _pageSize)
            : await _remoteDataSource.getEventTasks(eventId, page: page, pageSize: _pageSize);
        tasks.addAll(response.items.map((item) => item.toEntity()));
        if (!response.hasNextPage) break;
      }
      return tasks;
    });
  }

  @override
  Future<Either<Failure, TaskDetails>> getTask(String id) {
    return guard(() async => (await _remoteDataSource.getTask(id)).toEntity());
  }

  @override
  Future<Either<Failure, VerificationForm>> getForm(String taskId) {
    return guard(() async => (await _remoteDataSource.getForm(taskId)).toEntity());
  }

  @override
  Future<Either<Failure, TaskSubmission?>> getSubmission(String taskId) async {
    final result = await guard(
      () async => (await _remoteDataSource.getSubmission(taskId)).toEntity(),
    );
    return result.fold(
      (failure) => failure.code == _notFoundCode ? const Right(null) : Left(failure),
      Right.new,
    );
  }

  @override
  Future<Either<Failure, TaskSubmission>> submit(String taskId, Map<String, TaskAnswer> answers) {
    return guard(() async => (await _remoteDataSource.submit(taskId, answers)).toEntity());
  }

  @override
  Future<Either<Failure, String>> downloadAttachment(String taskId, TaskAttachment attachment) {
    return guard(
      () => _remoteDataSource.downloadAttachment(
        taskId,
        attachment.id,
        attachment.fileName,
        attachment.sizeBytes,
      ),
    );
  }

  @override
  Future<Either<Failure, String>> downloadSubmissionFile(String taskId, SubmittedFile file) {
    return guard(
      () =>
          _remoteDataSource.downloadSubmissionFile(taskId, file.id, file.fileName, file.sizeBytes),
    );
  }
}
