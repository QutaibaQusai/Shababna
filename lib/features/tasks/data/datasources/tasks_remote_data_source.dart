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

  final ApiConsumer _apiConsumer;

  Future<PagedResult<TaskSummaryModel>> getMyTasks({
    required int page,
    required int pageSize,
  }) async {
    final response = await _apiConsumer.get(
      EndPoints.eventTasks,
      queryParameters: {'Page': page, 'PageSize': pageSize, 'AssignedOnly': true},
    );
    return PagedResult.fromJson(response as Map<String, dynamic>, TaskSummaryModel.fromJson);
  }

  Future<PagedResult<TaskSummaryModel>> getEventTasks(
    String eventId, {
    required int page,
    required int pageSize,
  }) async {
    final response = await _apiConsumer.get(
      EndPoints.eventTasksOfEvent(eventId),
      queryParameters: {'Page': page, 'PageSize': pageSize, 'AssignedOnly': true},
    );
    return PagedResult.fromJson(response as Map<String, dynamic>, TaskSummaryModel.fromJson);
  }

  Future<TaskDetailsModel> getTask(String id) async {
    final response = await _apiConsumer.get(EndPoints.eventTask(id));
    return TaskDetailsModel.fromJson(response as Map<String, dynamic>);
  }

  Future<VerificationFormModel> getForm(String taskId) async {
    final response = await _apiConsumer.get(EndPoints.eventTaskForm(taskId));
    return VerificationFormModel.fromJson(response as Map<String, dynamic>);
  }

  Future<TaskSubmissionModel> getSubmission(String taskId) async {
    final response = await _apiConsumer.get(EndPoints.eventTaskSubmission(taskId));
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
            files.add(await MultipartFile.fromFile(file.path, filename: file.name));
          }
          payload.add({'fieldId': fieldId, 'fileIndexes': indexes});
      }
    }

    final response = await _apiConsumer.post(
      EndPoints.eventTaskSubmission(taskId),
      data: {'Answers': jsonEncode(payload), 'Files': files},
      isFormData: true,
    );
    return TaskSubmissionModel.fromJson(response as Map<String, dynamic>);
  }

  Future<String> downloadAttachment(String taskId, String attachmentId, String fileName) {
    return _download(EndPoints.eventTaskAttachment(taskId, attachmentId), attachmentId, fileName);
  }

  Future<String> downloadSubmissionFile(String taskId, String fileId, String fileName) {
    return _download(EndPoints.eventTaskSubmissionFile(taskId, fileId), fileId, fileName);
  }

  Future<String> _download(String endpoint, String id, String fileName) async {
    final directory = Directory('${Directory.systemTemp.path}/$_downloadFolder');
    if (!await directory.exists()) await directory.create(recursive: true);
    final safeName = fileName.replaceAll(RegExp(r'[\\/:*?"<>|]'), '_');
    final path = '${directory.path}/${id}_$safeName';
    await _apiConsumer.download(endpoint, path);
    return path;
  }
}
