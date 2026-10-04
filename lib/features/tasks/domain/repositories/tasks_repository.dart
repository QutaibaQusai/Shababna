import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';

enum TaskSubmissionStatus { pending, approved, rejected }

enum VerificationFieldType {
  image,
  file,
  text,
  longText,
  singleChoice,
  multipleChoice,
  yesNo;

  bool get isUpload => this == image || this == file;
}

class TaskSummary extends Equatable {
  const TaskSummary({
    required this.id,
    required this.eventId,
    required this.eventTitleEn,
    required this.eventTitleAr,
    required this.nameEn,
    required this.nameAr,
    required this.dueAt,
    required this.volunteeringHours,
    required this.isAssignedToMe,
    required this.attachmentCount,
    required this.submissionStatus,
  });

  final String id;
  final String eventId;
  final String eventTitleEn;
  final String eventTitleAr;
  final String nameEn;
  final String nameAr;
  final DateTime? dueAt;
  final double volunteeringHours;
  final bool isAssignedToMe;
  final int attachmentCount;
  final TaskSubmissionStatus? submissionStatus;

  String name(bool isArabic) => isArabic ? nameAr : nameEn;

  String eventTitle(bool isArabic) => isArabic ? eventTitleAr : eventTitleEn;

  bool get isOpen => submissionStatus == null || submissionStatus == TaskSubmissionStatus.rejected;

  bool get isOverdue {
    final dueAt = this.dueAt;
    return isOpen && dueAt != null && dueAt.isBefore(DateTime.now());
  }

  @override
  List<Object?> get props => [
    id,
    eventId,
    eventTitleEn,
    eventTitleAr,
    nameEn,
    nameAr,
    dueAt,
    volunteeringHours,
    isAssignedToMe,
    attachmentCount,
    submissionStatus,
  ];
}

class TaskAttachment extends Equatable {
  const TaskAttachment({
    required this.id,
    required this.fileName,
    required this.contentType,
    required this.sizeBytes,
  });

  final String id;
  final String fileName;
  final String contentType;
  final int sizeBytes;

  bool get isImage => contentType.startsWith('image/');

  @override
  List<Object?> get props => [id, fileName, contentType, sizeBytes];
}

class TaskDetails extends Equatable {
  const TaskDetails({
    required this.id,
    required this.eventId,
    required this.eventTitleEn,
    required this.eventTitleAr,
    required this.nameEn,
    required this.nameAr,
    required this.descriptionEn,
    required this.descriptionAr,
    required this.dueAt,
    required this.volunteeringHours,
    required this.isAssignedToMe,
    required this.attachments,
    required this.submissionStatus,
  });

  final String id;
  final String eventId;
  final String eventTitleEn;
  final String eventTitleAr;
  final String nameEn;
  final String nameAr;
  final String descriptionEn;
  final String descriptionAr;
  final DateTime? dueAt;
  final double volunteeringHours;
  final bool isAssignedToMe;
  final List<TaskAttachment> attachments;
  final TaskSubmissionStatus? submissionStatus;

  String name(bool isArabic) => isArabic ? nameAr : nameEn;

  String eventTitle(bool isArabic) => isArabic ? eventTitleAr : eventTitleEn;

  String description(bool isArabic) => isArabic ? descriptionAr : descriptionEn;

  bool get canSubmit => isAssignedToMe && isOpen;

  bool get isOpen => submissionStatus == null || submissionStatus == TaskSubmissionStatus.rejected;

  bool get isOverdue {
    final dueAt = this.dueAt;
    return isOpen && dueAt != null && dueAt.isBefore(DateTime.now());
  }

  @override
  List<Object?> get props => [
    id,
    eventId,
    eventTitleEn,
    eventTitleAr,
    nameEn,
    nameAr,
    descriptionEn,
    descriptionAr,
    dueAt,
    volunteeringHours,
    isAssignedToMe,
    attachments,
    submissionStatus,
  ];
}

class FieldOption extends Equatable {
  const FieldOption({required this.id, required this.labelEn, required this.labelAr});

  final String id;
  final String labelEn;
  final String labelAr;

  String label(bool isArabic) => isArabic ? labelAr : labelEn;

  @override
  List<Object?> get props => [id, labelEn, labelAr];
}

class VerificationField extends Equatable {
  const VerificationField({
    required this.id,
    required this.labelEn,
    required this.labelAr,
    required this.descriptionEn,
    required this.descriptionAr,
    required this.type,
    required this.isRequired,
    required this.maxFiles,
    required this.allowedExtensions,
    required this.maxLength,
    required this.options,
  });

  static const _imageExtensions = ['jpg', 'jpeg', 'png', 'webp'];
  static const _documentExtensions = ['pdf', 'docx', 'xlsx', 'pptx'];

  final String id;
  final String labelEn;
  final String labelAr;
  final String? descriptionEn;
  final String? descriptionAr;
  final VerificationFieldType type;
  final bool isRequired;
  final int? maxFiles;
  final List<String> allowedExtensions;
  final int? maxLength;
  final List<FieldOption> options;

  String label(bool isArabic) => isArabic ? labelAr : labelEn;

  String? description(bool isArabic) => isArabic ? descriptionAr : descriptionEn;

  List<String> get acceptedExtensions {
    if (allowedExtensions.isNotEmpty) return allowedExtensions;
    return switch (type) {
      VerificationFieldType.image => _imageExtensions,
      VerificationFieldType.file => [..._imageExtensions, ..._documentExtensions],
      _ => const [],
    };
  }

  @override
  List<Object?> get props => [
    id,
    labelEn,
    labelAr,
    descriptionEn,
    descriptionAr,
    type,
    isRequired,
    maxFiles,
    allowedExtensions,
    maxLength,
    options,
  ];
}

class VerificationForm extends Equatable {
  const VerificationForm({
    required this.canSubmit,
    required this.submissionStatus,
    required this.maxFileBytes,
    required this.maxFilesPerSubmission,
    required this.fields,
  });

  final bool canSubmit;
  final TaskSubmissionStatus? submissionStatus;
  final int maxFileBytes;
  final int maxFilesPerSubmission;
  final List<VerificationField> fields;

  @override
  List<Object?> get props => [
    canSubmit,
    submissionStatus,
    maxFileBytes,
    maxFilesPerSubmission,
    fields,
  ];
}

class SubmittedFile extends Equatable {
  const SubmittedFile({
    required this.id,
    required this.fileName,
    required this.contentType,
    required this.sizeBytes,
  });

  final String id;
  final String fileName;
  final String contentType;
  final int sizeBytes;

  @override
  List<Object?> get props => [id, fileName, contentType, sizeBytes];
}

class SubmittedAnswer extends Equatable {
  const SubmittedAnswer({
    required this.fieldId,
    required this.labelEn,
    required this.labelAr,
    required this.type,
    required this.text,
    required this.yesNo,
    required this.options,
    required this.files,
  });

  final String fieldId;
  final String labelEn;
  final String labelAr;
  final VerificationFieldType type;
  final String? text;
  final bool? yesNo;
  final List<FieldOption> options;
  final List<SubmittedFile> files;

  String label(bool isArabic) => isArabic ? labelAr : labelEn;

  @override
  List<Object?> get props => [fieldId, labelEn, labelAr, type, text, yesNo, options, files];
}

class TaskSubmission extends Equatable {
  const TaskSubmission({
    required this.status,
    required this.submittedAt,
    required this.reviewedAt,
    required this.rejectionReason,
    required this.creditedHours,
    required this.answers,
  });

  final TaskSubmissionStatus status;
  final DateTime submittedAt;
  final DateTime? reviewedAt;
  final String? rejectionReason;
  final double? creditedHours;
  final List<SubmittedAnswer> answers;

  @override
  List<Object?> get props => [
    status,
    submittedAt,
    reviewedAt,
    rejectionReason,
    creditedHours,
    answers,
  ];
}

class PickedTaskFile extends Equatable {
  const PickedTaskFile({required this.path, required this.name, required this.sizeBytes});

  final String path;
  final String name;
  final int sizeBytes;

  String get extension {
    final dot = name.lastIndexOf('.');
    return dot < 0 ? '' : name.substring(dot + 1).toLowerCase();
  }

  @override
  List<Object?> get props => [path, name, sizeBytes];
}

sealed class TaskAnswer extends Equatable {
  const TaskAnswer();

  bool get isEmpty;
}

class TextAnswer extends TaskAnswer {
  const TextAnswer(this.text);

  final String text;

  @override
  bool get isEmpty => text.trim().isEmpty;

  @override
  List<Object?> get props => [text];
}

class YesNoAnswer extends TaskAnswer {
  const YesNoAnswer(this.value);

  final bool value;

  @override
  bool get isEmpty => false;

  @override
  List<Object?> get props => [value];
}

class ChoiceAnswer extends TaskAnswer {
  const ChoiceAnswer(this.optionIds);

  final Set<String> optionIds;

  @override
  bool get isEmpty => optionIds.isEmpty;

  @override
  List<Object?> get props => [optionIds];
}

class FilesAnswer extends TaskAnswer {
  const FilesAnswer(this.files);

  final List<PickedTaskFile> files;

  @override
  bool get isEmpty => files.isEmpty;

  @override
  List<Object?> get props => [files];
}

abstract interface class TasksRepository {
  Future<Either<Failure, List<TaskSummary>>> getAssignedTasks({String? eventId});

  Future<Either<Failure, TaskDetails>> getTask(String id);

  Future<Either<Failure, VerificationForm>> getForm(String taskId);

  Future<Either<Failure, TaskSubmission?>> getSubmission(String taskId);

  Future<Either<Failure, TaskSubmission>> submit(String taskId, Map<String, TaskAnswer> answers);

  Future<Either<Failure, String>> downloadAttachment(String taskId, TaskAttachment attachment);

  Future<Either<Failure, String>> downloadSubmissionFile(String taskId, SubmittedFile file);
}
