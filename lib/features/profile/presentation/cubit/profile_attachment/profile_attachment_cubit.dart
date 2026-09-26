import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/state/form_status.dart';
import '../../../domain/repositories/profile_repository.dart';
import '../../utils/failure_message.dart';
import '../profile/profile_cubit.dart';
import 'profile_attachment_state.dart';

class ProfileAttachmentCubit extends Cubit<ProfileAttachmentState> {
  ProfileAttachmentCubit(this._repository, this._profileCubit)
      : super(const ProfileAttachmentState());

  final ProfileRepository _repository;
  final ProfileCubit _profileCubit;

  Future<void> upload(ProfileAttachment attachment, String filePath) async {
    if (state.isBusy) return;
    emit(ProfileAttachmentState(
      status: FormStatus.submitting,
      attachment: attachment,
      operation: ProfileAttachmentOperation.upload,
      pendingPicturePath: attachment == ProfileAttachment.picture ? filePath : null,
    ));

    final result = await _repository.uploadAttachment(attachment, filePath);
    if (isClosed) return;

    result.fold(
      (failure) => _emitFailure(attachment, ProfileAttachmentOperation.upload, failure.userMessage),
      (profile) {
        _profileCubit.replace(profile, pictureChanged: attachment == ProfileAttachment.picture);
        _emitSuccess(attachment, ProfileAttachmentOperation.upload);
      },
    );
  }

  Future<void> remove(ProfileAttachment attachment) async {
    if (state.isBusy) return;
    emit(ProfileAttachmentState(
      status: FormStatus.submitting,
      attachment: attachment,
      operation: ProfileAttachmentOperation.remove,
    ));

    final result = await _repository.deleteAttachment(attachment);
    if (isClosed) return;

    await result.fold(
      (failure) async =>
          _emitFailure(attachment, ProfileAttachmentOperation.remove, failure.userMessage),
      (_) async {
        await _profileCubit.refresh(silent: true);
        if (isClosed) return;
        _emitSuccess(attachment, ProfileAttachmentOperation.remove);
      },
    );
  }

  void _emitSuccess(ProfileAttachment attachment, ProfileAttachmentOperation operation) {
    emit(ProfileAttachmentState(
      status: FormStatus.success,
      attachment: attachment,
      operation: operation,
    ));
  }

  void _emitFailure(
    ProfileAttachment attachment,
    ProfileAttachmentOperation operation,
    String? message,
  ) {
    emit(ProfileAttachmentState(
      status: FormStatus.failure,
      attachment: attachment,
      operation: operation,
      errorMessage: message,
    ));
  }
}
