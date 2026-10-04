import 'package:dartz/dartz.dart';

import '../../../../core/data/repository_guard_mixin.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/paged_result.dart';
import '../../domain/repositories/tasks_repository.dart';
import '../datasources/tasks_remote_data_source.dart';
import '../mappers/tasks_mapper.dart';
import '../models/task_models.dart';

class TasksRepositoryImpl with RepositoryGuardMixin implements TasksRepository {
  TasksRepositoryImpl(this._remoteDataSource);

  static const _notFoundCode = 'RESOURCE_NOT_FOUND';

  final TasksRemoteDataSource _remoteDataSource;

  @override
  Future<Either<Failure, PagedResult<TaskSummary>>> getMyTasks({
    required int page,
    required int pageSize,
  }) {
    return guard(
      () async => _mapPage(await _remoteDataSource.getMyTasks(page: page, pageSize: pageSize)),
    );
  }

  @override
  Future<Either<Failure, PagedResult<TaskSummary>>> getEventTasks(
    String eventId, {
    required int page,
    required int pageSize,
  }) {
    return guard(
      () async =>
          _mapPage(await _remoteDataSource.getEventTasks(eventId, page: page, pageSize: pageSize)),
    );
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
      () => _remoteDataSource.downloadAttachment(taskId, attachment.id, attachment.fileName),
    );
  }

  @override
  Future<Either<Failure, String>> downloadSubmissionFile(String taskId, SubmittedFile file) {
    return guard(() => _remoteDataSource.downloadSubmissionFile(taskId, file.id, file.fileName));
  }

  PagedResult<TaskSummary> _mapPage(PagedResult<TaskSummaryModel> response) {
    return PagedResult(
      items: response.items.map((item) => item.toEntity()).toList(),
      page: response.page,
      pageSize: response.pageSize,
      totalCount: response.totalCount,
      hasNextPage: response.hasNextPage,
    );
  }
}
