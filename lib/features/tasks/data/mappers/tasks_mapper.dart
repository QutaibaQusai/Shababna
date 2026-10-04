import '../../domain/repositories/tasks_repository.dart';
import '../models/task_models.dart';

extension TaskSummaryModelMapper on TaskSummaryModel {
  TaskSummary toEntity() {
    return TaskSummary(
      id: id,
      eventId: eventId,
      eventTitleEn: eventTitleEn,
      eventTitleAr: eventTitleAr,
      nameEn: nameEn,
      nameAr: nameAr,
      dueAt: _localTime(dueAtUtc),
      volunteeringHours: volunteeringHours,
      isAssignedToMe: isAssignedToMe,
      attachmentCount: attachmentCount,
      submissionStatus: _status(mySubmissionStatus),
    );
  }
}

extension TaskDetailsModelMapper on TaskDetailsModel {
  TaskDetails toEntity() {
    return TaskDetails(
      id: summary.id,
      eventId: summary.eventId,
      eventTitleEn: summary.eventTitleEn,
      eventTitleAr: summary.eventTitleAr,
      nameEn: summary.nameEn,
      nameAr: summary.nameAr,
      descriptionEn: descriptionEn,
      descriptionAr: descriptionAr,
      dueAt: _localTime(summary.dueAtUtc),
      volunteeringHours: summary.volunteeringHours,
      isAssignedToMe: summary.isAssignedToMe,
      attachments: attachments
          .map(
            (file) => TaskAttachment(
              id: file.id,
              fileName: file.fileName,
              contentType: file.contentType,
              sizeBytes: file.sizeBytes,
            ),
          )
          .toList(),
      submissionStatus: _status(summary.mySubmissionStatus),
    );
  }
}

extension VerificationFormModelMapper on VerificationFormModel {
  VerificationForm toEntity() {
    final sorted = [...fields]..sort((a, b) => a.order.compareTo(b.order));
    return VerificationForm(
      canSubmit: canSubmit,
      submissionStatus: _status(submissionStatus),
      maxFileBytes: maxFileBytes,
      maxFilesPerSubmission: maxFilesPerSubmission,
      fields: [
        for (final field in sorted)
          if (_fieldType(field.type) case final type?)
            VerificationField(
              id: field.id,
              labelEn: field.labelEn,
              labelAr: field.labelAr,
              descriptionEn: field.descriptionEn,
              descriptionAr: field.descriptionAr,
              type: type,
              isRequired: field.isRequired,
              maxFiles: field.maxFiles,
              allowedExtensions: field.allowedExtensions
                  .map((extension) => extension.replaceFirst('.', '').toLowerCase())
                  .toList(),
              maxLength: field.maxLength,
              options: field.options.map((option) => option.toEntity()).toList(),
            ),
      ],
    );
  }
}

extension TaskSubmissionModelMapper on TaskSubmissionModel {
  TaskSubmission toEntity() {
    final sorted = [...answers]..sort((a, b) => a.order.compareTo(b.order));
    return TaskSubmission(
      status: _status(status) ?? TaskSubmissionStatus.pending,
      submittedAt: DateTime.parse(submittedAtUtc).toLocal(),
      reviewedAt: _localTime(reviewedAtUtc),
      rejectionReason: rejectionReason,
      creditedHours: creditedHours,
      answers: [
        for (final answer in sorted)
          if (_fieldType(answer.type) case final type?)
            SubmittedAnswer(
              fieldId: answer.fieldId,
              labelEn: answer.labelEn,
              labelAr: answer.labelAr,
              type: type,
              text: answer.text,
              yesNo: answer.yesNo,
              options: answer.options.map((option) => option.toEntity()).toList(),
              files: answer.files
                  .map(
                    (file) => SubmittedFile(
                      id: file.id,
                      fileName: file.fileName,
                      contentType: file.contentType,
                      sizeBytes: file.sizeBytes,
                    ),
                  )
                  .toList(),
            ),
      ],
    );
  }
}

extension on FieldOptionModel {
  FieldOption toEntity() => FieldOption(id: id, labelEn: labelEn, labelAr: labelAr);
}

TaskSubmissionStatus? _status(String? value) => switch (value) {
  'Pending' => TaskSubmissionStatus.pending,
  'Approved' => TaskSubmissionStatus.approved,
  'Rejected' => TaskSubmissionStatus.rejected,
  _ => null,
};

VerificationFieldType? _fieldType(String value) => switch (value) {
  'Image' => VerificationFieldType.image,
  'File' => VerificationFieldType.file,
  'Text' => VerificationFieldType.text,
  'LongText' => VerificationFieldType.longText,
  'SingleChoice' => VerificationFieldType.singleChoice,
  'MultipleChoice' => VerificationFieldType.multipleChoice,
  'YesNo' => VerificationFieldType.yesNo,
  _ => null,
};

DateTime? _localTime(String? value) => value == null ? null : DateTime.tryParse(value)?.toLocal();
