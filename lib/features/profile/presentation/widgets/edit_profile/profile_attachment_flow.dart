import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../core/shared/widgets/app_dialog.dart';
import '../../../../../core/shared/widgets/app_toast.dart';
import '../../../../../core/state/form_status.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../domain/repositories/profile_repository.dart';
import '../../cubit/profile_attachment/profile_attachment_cubit.dart';
import '../../cubit/profile_attachment/profile_attachment_state.dart';
import '../../utils/profile_attachment_picker.dart';
import '../shared/profile_action_sheet.dart';

enum _AttachmentAction { camera, gallery, file, remove }

abstract final class ProfileAttachmentFlow {
  static const _picker = ProfileAttachmentPicker();

  static Future<void> start(
    BuildContext context,
    ProfileAttachment attachment, {
    required bool exists,
  }) async {
    final cubit = context.read<ProfileAttachmentCubit>();
    if (cubit.state.isBusy) return;

    final action = await ProfileActionSheet.show<_AttachmentAction>(
      context,
      title: attachment.title(context.l10n),
      subtitle: attachment == ProfileAttachment.cv
          ? context.l10n.cvFormatsHint(attachment.maxMegabytes)
          : null,
      actions: _actionsFor(context.l10n, attachment, exists: exists),
    );
    if (action == null || !context.mounted) return;

    if (action == _AttachmentAction.remove) {
      final confirmed = await AppDialog.confirm(
        context,
        title: attachment.removeConfirmTitle(context.l10n),
        message: attachment.removeConfirmMessage(context.l10n),
        confirmText: context.l10n.removeButton,
        cancelText: context.l10n.cancelButton,
      );
      if (confirmed) cubit.remove(attachment);
      return;
    }

    final PickedAttachment? picked;
    try {
      picked = switch (action) {
        _AttachmentAction.camera => await _picker.pickImage(attachment, ImageSource.camera),
        _AttachmentAction.gallery => await _picker.pickImage(attachment, ImageSource.gallery),
        _ => await _picker.pickDocument(),
      };
    } catch (_) {
      if (context.mounted) AppToast.error(context, context.l10n.somethingWentWrong);
      return;
    }
    if (picked == null || !context.mounted) return;

    if (picked.exceeds(attachment.maxMegabytes)) {
      AppToast.error(context, context.l10n.fileTooLargeError(attachment.maxMegabytes));
      return;
    }
    cubit.upload(attachment, picked.path);
  }

  static void showResult(BuildContext context, ProfileAttachmentState state) {
    final attachment = state.attachment;
    if (attachment == null) return;

    if (state.status == FormStatus.failure) {
      AppToast.error(context, state.errorMessage ?? context.l10n.somethingWentWrong);
    } else if (state.status == FormStatus.success) {
      AppToast.success(
        context,
        state.operation == ProfileAttachmentOperation.remove
            ? attachment.removedMessage(context.l10n)
            : attachment.uploadedMessage(context.l10n),
      );
    }
  }

  static List<ProfileSheetAction<_AttachmentAction>> _actionsFor(
    AppLocalizations l10n,
    ProfileAttachment attachment, {
    required bool exists,
  }) {
    return [
      if (attachment == ProfileAttachment.cv)
        ProfileSheetAction(
          value: _AttachmentAction.file,
          icon: LucideIcons.fileUp,
          label: exists ? l10n.replaceCvButton : l10n.uploadCvButton,
        )
      else ...[
        ProfileSheetAction(
          value: _AttachmentAction.camera,
          icon: LucideIcons.camera,
          label: l10n.cameraOption,
        ),
        ProfileSheetAction(
          value: _AttachmentAction.gallery,
          icon: LucideIcons.images,
          label: l10n.galleryOption,
        ),
      ],
      if (exists)
        ProfileSheetAction(
          value: _AttachmentAction.remove,
          icon: LucideIcons.trash2,
          label: attachment.removeLabel(l10n),
          isDestructive: true,
        ),
    ];
  }
}

extension on ProfileAttachment {
  String title(AppLocalizations l10n) => switch (this) {
        ProfileAttachment.picture => l10n.profilePictureLabel,
        ProfileAttachment.cv => l10n.cvLabel,
        ProfileAttachment.nationalId => l10n.nationalIdPictureLabel,
      };

  String removeLabel(AppLocalizations l10n) => switch (this) {
        ProfileAttachment.picture => l10n.removePhotoButton,
        ProfileAttachment.cv => l10n.removeCvButton,
        ProfileAttachment.nationalId => l10n.removeNationalIdButton,
      };

  String removeConfirmTitle(AppLocalizations l10n) => switch (this) {
        ProfileAttachment.picture => l10n.removePhotoConfirmTitle,
        ProfileAttachment.cv => l10n.removeCvConfirmTitle,
        ProfileAttachment.nationalId => l10n.removeNationalIdConfirmTitle,
      };

  String removeConfirmMessage(AppLocalizations l10n) => switch (this) {
        ProfileAttachment.picture => l10n.removePhotoConfirmMessage,
        ProfileAttachment.cv => l10n.removeCvConfirmMessage,
        ProfileAttachment.nationalId => l10n.removeNationalIdConfirmMessage,
      };

  String uploadedMessage(AppLocalizations l10n) => switch (this) {
        ProfileAttachment.picture => l10n.editProfilePictureSuccessMessage,
        ProfileAttachment.cv => l10n.editCvSuccessMessage,
        ProfileAttachment.nationalId => l10n.editNationalIdSuccessMessage,
      };

  String removedMessage(AppLocalizations l10n) => switch (this) {
        ProfileAttachment.picture => l10n.profilePictureRemovedMessage,
        ProfileAttachment.cv => l10n.cvRemovedMessage,
        ProfileAttachment.nationalId => l10n.nationalIdRemovedMessage,
      };
}
