int parseTaskInt(Object? value) => switch (value) {
  int() => value,
  num() => value.toInt(),
  String() => int.tryParse(value) ?? 0,
  _ => 0,
};

double? parseTaskDouble(Object? value) => switch (value) {
  num() => value.toDouble(),
  String() => double.tryParse(value),
  _ => null,
};

int? parseTaskNullableInt(Object? value) => value == null ? null : parseTaskInt(value);

List<T> parseTaskList<T>(Object? value, T Function(Map<String, dynamic> json) fromJson) {
  if (value is! List) return const [];
  return value.whereType<Map<String, dynamic>>().map(fromJson).toList();
}

class TaskSummaryModel {
  const TaskSummaryModel({
    required this.id,
    required this.volunteeringOpportunityId,
    required this.volunteeringOpportunityTitleEn,
    required this.volunteeringOpportunityTitleAr,
    required this.nameEn,
    required this.nameAr,
    required this.dueAtUtc,
    required this.volunteeringHours,
    required this.isAssignedToMe,
    required this.attachmentCount,
    required this.mySubmissionStatus,
  });

  factory TaskSummaryModel.fromJson(Map<String, dynamic> json) {
    return TaskSummaryModel(
      id: json['id'] as String,
      volunteeringOpportunityId: json['eventId'] as String? ?? '',
      volunteeringOpportunityTitleEn: json['eventTitleEn'] as String? ?? '',
      volunteeringOpportunityTitleAr: json['eventTitleAr'] as String? ?? '',
      nameEn: json['nameEn'] as String? ?? '',
      nameAr: json['nameAr'] as String? ?? '',
      dueAtUtc: json['dueAtUtc'] as String?,
      volunteeringHours: parseTaskDouble(json['volunteeringHours']) ?? 0,
      isAssignedToMe: json['isAssignedToMe'] as bool? ?? false,
      attachmentCount: parseTaskInt(json['attachmentCount']),
      mySubmissionStatus: json['mySubmissionStatus'] as String?,
    );
  }

  final String id;
  final String volunteeringOpportunityId;
  final String volunteeringOpportunityTitleEn;
  final String volunteeringOpportunityTitleAr;
  final String nameEn;
  final String nameAr;
  final String? dueAtUtc;
  final double volunteeringHours;
  final bool isAssignedToMe;
  final int attachmentCount;
  final String? mySubmissionStatus;
}

class TaskFileModel {
  const TaskFileModel({
    required this.id,
    required this.fileName,
    required this.contentType,
    required this.sizeBytes,
  });

  factory TaskFileModel.fromJson(Map<String, dynamic> json) {
    return TaskFileModel(
      id: json['id'] as String,
      fileName: json['fileName'] as String? ?? '',
      contentType: json['contentType'] as String? ?? '',
      sizeBytes: parseTaskInt(json['sizeBytes']),
    );
  }

  final String id;
  final String fileName;
  final String contentType;
  final int sizeBytes;
}

class TaskDetailsModel {
  const TaskDetailsModel({
    required this.summary,
    required this.descriptionEn,
    required this.descriptionAr,
    required this.attachments,
  });

  factory TaskDetailsModel.fromJson(Map<String, dynamic> json) {
    return TaskDetailsModel(
      summary: TaskSummaryModel.fromJson(json),
      descriptionEn: json['descriptionEn'] as String? ?? '',
      descriptionAr: json['descriptionAr'] as String? ?? '',
      attachments: parseTaskList(json['attachments'], TaskFileModel.fromJson),
    );
  }

  final TaskSummaryModel summary;
  final String descriptionEn;
  final String descriptionAr;
  final List<TaskFileModel> attachments;
}

class FieldOptionModel {
  const FieldOptionModel({required this.id, required this.labelEn, required this.labelAr});

  factory FieldOptionModel.fromJson(Map<String, dynamic> json) {
    return FieldOptionModel(
      id: json['id'] as String,
      labelEn: json['labelEn'] as String? ?? '',
      labelAr: json['labelAr'] as String? ?? '',
    );
  }

  final String id;
  final String labelEn;
  final String labelAr;
}

class VerificationFieldModel {
  const VerificationFieldModel({
    required this.id,
    required this.labelEn,
    required this.labelAr,
    required this.descriptionEn,
    required this.descriptionAr,
    required this.type,
    required this.isRequired,
    required this.order,
    required this.maxFiles,
    required this.allowedExtensions,
    required this.maxLength,
    required this.options,
  });

  factory VerificationFieldModel.fromJson(Map<String, dynamic> json) {
    final extensions = json['allowedExtensions'];
    return VerificationFieldModel(
      id: json['id'] as String,
      labelEn: json['labelEn'] as String? ?? '',
      labelAr: json['labelAr'] as String? ?? '',
      descriptionEn: json['descriptionEn'] as String?,
      descriptionAr: json['descriptionAr'] as String?,
      type: json['type'] as String? ?? '',
      isRequired: json['isRequired'] as bool? ?? false,
      order: parseTaskInt(json['order']),
      maxFiles: parseTaskNullableInt(json['maxFiles']),
      allowedExtensions: extensions is List ? extensions.whereType<String>().toList() : const [],
      maxLength: parseTaskNullableInt(json['maxLength']),
      options: parseTaskList(json['options'], FieldOptionModel.fromJson),
    );
  }

  final String id;
  final String labelEn;
  final String labelAr;
  final String? descriptionEn;
  final String? descriptionAr;
  final String type;
  final bool isRequired;
  final int order;
  final int? maxFiles;
  final List<String> allowedExtensions;
  final int? maxLength;
  final List<FieldOptionModel> options;
}

class VerificationFormModel {
  const VerificationFormModel({
    required this.canSubmit,
    required this.submissionStatus,
    required this.maxFileBytes,
    required this.maxFilesPerSubmission,
    required this.fields,
  });

  factory VerificationFormModel.fromJson(Map<String, dynamic> json) {
    return VerificationFormModel(
      canSubmit: json['canSubmit'] as bool? ?? false,
      submissionStatus: json['submissionStatus'] as String?,
      maxFileBytes: parseTaskInt(json['maxFileBytes']),
      maxFilesPerSubmission: parseTaskInt(json['maxFilesPerSubmission']),
      fields: parseTaskList(json['fields'], VerificationFieldModel.fromJson),
    );
  }

  final bool canSubmit;
  final String? submissionStatus;
  final int maxFileBytes;
  final int maxFilesPerSubmission;
  final List<VerificationFieldModel> fields;
}

class SubmittedAnswerModel {
  const SubmittedAnswerModel({
    required this.fieldId,
    required this.labelEn,
    required this.labelAr,
    required this.type,
    required this.order,
    required this.text,
    required this.yesNo,
    required this.options,
    required this.files,
  });

  factory SubmittedAnswerModel.fromJson(Map<String, dynamic> json) {
    return SubmittedAnswerModel(
      fieldId: json['fieldId'] as String? ?? '',
      labelEn: json['labelEn'] as String? ?? '',
      labelAr: json['labelAr'] as String? ?? '',
      type: json['type'] as String? ?? '',
      order: parseTaskInt(json['order']),
      text: json['text'] as String?,
      yesNo: json['yesNo'] as bool?,
      options: parseTaskList(json['options'], FieldOptionModel.fromJson),
      files: parseTaskList(json['files'], TaskFileModel.fromJson),
    );
  }

  final String fieldId;
  final String labelEn;
  final String labelAr;
  final String type;
  final int order;
  final String? text;
  final bool? yesNo;
  final List<FieldOptionModel> options;
  final List<TaskFileModel> files;
}

class TaskSubmissionModel {
  const TaskSubmissionModel({
    required this.status,
    required this.submittedAtUtc,
    required this.reviewedAtUtc,
    required this.rejectionReason,
    required this.creditedHours,
    required this.answers,
  });

  factory TaskSubmissionModel.fromJson(Map<String, dynamic> json) {
    return TaskSubmissionModel(
      status: json['status'] as String? ?? '',
      submittedAtUtc: json['submittedAtUtc'] as String,
      reviewedAtUtc: json['reviewedAtUtc'] as String?,
      rejectionReason: json['rejectionReason'] as String?,
      creditedHours: parseTaskDouble(json['creditedHours']),
      answers: parseTaskList(json['answers'], SubmittedAnswerModel.fromJson),
    );
  }

  final String status;
  final String submittedAtUtc;
  final String? reviewedAtUtc;
  final String? rejectionReason;
  final double? creditedHours;
  final List<SubmittedAnswerModel> answers;
}
