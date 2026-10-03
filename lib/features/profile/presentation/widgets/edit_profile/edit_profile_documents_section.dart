import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../domain/repositories/profile_repository.dart';
import '../../cubit/profile/profile_cubit.dart';
import '../../cubit/profile_attachment/profile_attachment_cubit.dart';
import '../../utils/profile_attachment_picker.dart';
import 'profile_attachment_flow.dart';
import 'profile_document_tile.dart';

class EditProfileDocumentsSection extends StatelessWidget {
  const EditProfileDocumentsSection({super.key, this.isNationalIdMissing = false});

  final bool isNationalIdMissing;

  @override
  Widget build(BuildContext context) {
    final profile = context.select((ProfileCubit cubit) => cubit.state.profile);
    final attachmentState = context.watch<ProfileAttachmentCubit>().state;
    if (profile == null) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ProfileDocumentTile(
          label: context.l10n.cvLabel,
          isUploaded: profile.hasCv,
          status: profile.hasCv
              ? (profile.cvFileName ?? context.l10n.documentUploadedStatus)
              : context.l10n.documentNotUploadedStatus,
          hint: profile.hasCv ? null : context.l10n.cvFormatsHint(ProfileAttachment.cv.maxMegabytes),
          isBusy: attachmentState.isBusyWith(ProfileAttachment.cv),
          onTap: () => ProfileAttachmentFlow.start(
            context,
            ProfileAttachment.cv,
            exists: profile.hasCv,
          ),
        ),
        SizedBox(height: AppSpacing.sm),
        ProfileDocumentTile(
          label: context.l10n.nationalIdPictureLabel,
          isUploaded: profile.hasNationalIdPicture,
          status: profile.hasNationalIdPicture
              ? context.l10n.documentUploadedStatus
              : context.l10n.documentNotUploadedStatus,
          isBusy: attachmentState.isBusyWith(ProfileAttachment.nationalId),
          hasError: isNationalIdMissing,
          onTap: () => ProfileAttachmentFlow.start(
            context,
            ProfileAttachment.nationalId,
            exists: profile.hasNationalIdPicture,
          ),
        ),
      ],
    );
  }
}
