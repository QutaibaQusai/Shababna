import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';

import '../../../../core/network/api_consumer.dart';
import '../../../../core/network/end_points.dart';
import '../../../../core/network/paged_result.dart';
import '../../domain/repositories/tasks_repository.dart';
import '../models/task_models.dart';

class TasksRemoteDataSource {
  TasksRemoteDataSource(this._apiConsumer);

  static const _downloadFolder = 'shababna';
  static const _fallbackMediaType = 'application/octet-stream';
  static const _mediaTypes = {
    'jpg': 'image/jpeg',
    'jpeg': 'image/jpeg',
    'png': 'image/png',
    'webp': 'image/webp',
    'pdf': 'application/pdf',
    'docx': 'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
    'xlsx': 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
    'pptx': 'application/vnd.openxmlformats-officedocument.presentationml.presentation',
  };
  static final _unsafeFileNameChars = RegExp(r'[\\/:*?"<>|]');

  final ApiConsumer _apiConsumer;

  Future<PagedResult<TaskSummaryModel>> getMyTasks({
    required int page,
    required int pageSize,
  }) async {
    final response = await _apiConsumer.get(
      EndPoints.volunteeringOpportunityTasks,
      queryParameters: {'Page': page, 'PageSize': pageSize, 'AssignedOnly': true},
    );
    return PagedResult.fromJson(response as Map<String, dynamic>, TaskSummaryModel.fromJson);
  }

  Future<PagedResult<TaskSummaryModel>> getVolunteeringOpportunityTasks(
    String volunteeringOpportunityId, {
    required int page,
    required int pageSize,
  }) async {
    final response = await _apiConsumer.get(
      EndPoints.volunteeringOpportunityTasksOfVolunteeringOpportunity(volunteeringOpportunityId),
      queryParameters: {'Page': page, 'PageSize': pageSize, 'AssignedOnly': true},
    );
    return PagedResult.fromJson(response as Map<String, dynamic>, TaskSummaryModel.fromJson);
  }

  Future<TaskDetailsModel> getTask(String id) async {
    final response = await _apiConsumer.get(EndPoints.volunteeringOpportunityTask(id));
    return TaskDetailsModel.fromJson(response as Map<String, dynamic>);
  }

  Future<VerificationFormModel> getForm(String taskId) async {
    final response = await _apiConsumer.get(EndPoints.volunteeringOpportunityTaskForm(taskId));
    return VerificationFormModel.fromJson(response as Map<String, dynamic>);
  }

  Future<TaskSubmissionModel> getSubmission(String taskId) async {
    final response = await _apiConsumer.get(
      EndPoints.volunteeringOpportunityTaskSubmission(taskId),
    );
    return TaskSubmissionModel.fromJson(response as Map<String, dynamic>);
  }

  Future<TaskSubmissionModel> submit(String taskId, Map<String, TaskAnswer> answers) async {
    final files = <MultipartFile>[];
    final payload = <Map<String, dynamic>>[];

    for (final MapEntry(key: fieldId, value: answer) in answers.entries) {
      if (answer.isEmpty) continue;
      switch (answer) {
        case TextAnswer(:final text):
          payload.add({'fieldId': fieldId, 'text': text.trim()});
        case YesNoAnswer(:final value):
          payload.add({'fieldId': fieldId, 'yesNo': value});
        case ChoiceAnswer(:final optionIds):
          payload.add({'fieldId': fieldId, 'optionIds': optionIds.toList()});
        case FilesAnswer(files: final picked):
          final indexes = <int>[];
          for (final file in picked) {
            indexes.add(files.length);
            files.add(
              await MultipartFile.fromFile(
                file.path,
                filename: file.name,
                contentType: _mediaTypeOf(file.extension),
              ),
            );
          }
          payload.add({'fieldId': fieldId, 'fileIndexes': indexes});
      }
    }

    final response = await _apiConsumer.post(
      EndPoints.volunteeringOpportunityTaskSubmission(taskId),
      data: {'Answers': jsonEncode(payload), 'Files': files},
      isFormData: true,
    );
    return TaskSubmissionModel.fromJson(response as Map<String, dynamic>);
  }

  Future<String> downloadAttachment(
    String taskId,
    String attachmentId,
    String fileName,
    int sizeBytes,
  ) {
    return _download(
      EndPoints.volunteeringOpportunityTaskAttachment(taskId, attachmentId),
      attachmentId,
      fileName,
      sizeBytes,
    );
  }

  Future<String> downloadSubmissionFile(
    String taskId,
    String fileId,
    String fileName,
    int sizeBytes,
  ) {
    return _download(
      EndPoints.volunteeringOpportunityTaskSubmissionFile(taskId, fileId),
      fileId,
      fileName,
      sizeBytes,
    );
  }

  Future<String> _download(String endpoint, String id, String fileName, int sizeBytes) async {
    final directory = Directory('${Directory.systemTemp.path}/$_downloadFolder');
    if (!await directory.exists()) await directory.create(recursive: true);
    final safeName = fileName.replaceAll(_unsafeFileNameChars, '_');
    final file = File('${directory.path}/${id}_$safeName');

    if (sizeBytes > 0 && await file.exists() && await file.length() == sizeBytes) {
      return file.path;
    }

    try {
      await _apiConsumer.download(endpoint, file.path);
    } catch (_) {
      if (await file.exists()) await file.delete();
      rethrow;
    }
    return file.path;
  }

  static DioMediaType _mediaTypeOf(String extension) =>
      DioMediaType.parse(_mediaTypes[extension] ?? _fallbackMediaType);
}
