import 'package:equatable/equatable.dart';

import '../../../../../core/state/form_status.dart';
import '../../../domain/repositories/profile_repository.dart';

enum ProfileAttachmentOperation { upload, remove }

class ProfileAttachmentState extends Equatable {
  const ProfileAttachmentState({
    this.status = FormStatus.initial,
    this.attachment,
    this.operation,
    this.errorMessage,
    this.pendingPicturePath,
  });

  final FormStatus status;
  final ProfileAttachment? attachment;
  final ProfileAttachmentOperation? operation;
  final String? errorMessage;
  final String? pendingPicturePath;

  bool get isBusy => status == FormStatus.submitting;

  bool isBusyWith(ProfileAttachment value) => isBusy && attachment == value;

  @override
  List<Object?> get props => [status, attachment, operation, errorMessage, pendingPicturePath];
}
