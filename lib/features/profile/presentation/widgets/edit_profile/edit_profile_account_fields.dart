import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../core/routes/app_routes.dart';
import '../../../../../core/shared/widgets/app_button.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../auth/domain/verification_channel.dart';
import '../../../domain/repositories/profile_repository.dart';
import '../../cubit/profile/profile_cubit.dart';
import '../../cubit/profile/profile_state.dart';
import '../../cubit/profile_attachment/profile_attachment_cubit.dart';
import '../../cubit/profile_attachment/profile_attachment_state.dart';
import 'edit_profile_picture_field.dart';
import 'field_card.dart';
import 'profile_attachment_flow.dart';
import 'tier_progress_summary.dart';

class EditProfileAvatar extends StatelessWidget {
  const EditProfileAvatar({super.key});

  @override
  Widget build(BuildContext context) {
    final profileState = context.watch<ProfileCubit>().state;
    final profile = profileState.profile;
    if (profile == null) return const SizedBox.shrink();
    return Column(
      children: [
        _PictureField(profile: profile, profileState: profileState),
        SizedBox(height: AppSpacing.xs),
        TierProgressSummary(
          tier: profile.tier,
          nextTier: profile.nextTier,
          volunteeringHours: profile.volunteeringHours,
          percentage: profile.tierProgressPercentage,
        ),
      ],
    );
  }
}

class EditProfileContactFields extends StatelessWidget {
  const EditProfileContactFields({super.key});

  @override
  Widget build(BuildContext context) {
    final profile = context.select((ProfileCubit cubit) => cubit.state.profile);
    if (profile == null) return const SizedBox.shrink();

    final l10n = context.l10n;
    final phoneVerified = profile.phoneNumberVerified;
    final hasPhone = profile.phoneNumber?.trim().isNotEmpty ?? false;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        FieldCard(
          label: l10n.phoneNumberLabel,
          icon: LucideIcons.phone,
          value: profile.phoneNumber,
          valueDirection: TextDirection.ltr,
          badge: phoneVerified == null || !hasPhone
              ? null
              : VerificationBadge(isVerified: phoneVerified),
          opensPage: true,
          onTap: () => context.push(AppRoutes.changePhoneNumber),
        ),
        if (phoneVerified == false && hasPhone)
          _VerifyContactButton(label: l10n.verifyPhoneTitle, channel: VerificationChannel.phone),
        SizedBox(height: AppSpacing.sm),
        FieldCard(
          label: l10n.emailLabel,
          icon: LucideIcons.mail,
          value: profile.email,
          badge: VerificationBadge(isVerified: profile.emailConfirmed),
          opensPage: true,
          onTap: () => context.push(AppRoutes.changeEmail),
        ),
        if (!profile.emailConfirmed)
          _VerifyContactButton(label: l10n.verifyEmailTitle, channel: VerificationChannel.email),
      ],
    );
  }
}

class _VerifyContactButton extends StatelessWidget {
  const _VerifyContactButton({required this.label, required this.channel});

  final String label;
  final VerificationChannel channel;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional.centerEnd,
      child: AppButton.text(
        label: label,
        onPressed: () => context.push(AppRoutes.verifyContact, extra: channel),
      ),
    );
  }
}

class _PictureField extends StatelessWidget {
  const _PictureField({required this.profile, required this.profileState});

  final Profile profile;
  final ProfileState profileState;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileAttachmentCubit, ProfileAttachmentState>(
      buildWhen: (previous, current) =>
          previous.isBusyWith(ProfileAttachment.picture) !=
              current.isBusyWith(ProfileAttachment.picture) ||
          previous.pendingPicturePath != current.pendingPicturePath,
      builder: (context, state) {
        return EditProfilePictureField(
          name: profile.fullName(context.isArabic),
          imageUrl: profile.hasProfilePicture ? profile.profilePictureUrl : null,
          cacheKey: profileState.pictureCacheKey,
          localFilePath: state.isBusyWith(ProfileAttachment.picture)
              ? state.pendingPicturePath
              : null,
          isBusy: state.isBusyWith(ProfileAttachment.picture),
          tier: profile.tier,
          nextTier: profile.nextTier,
          tierPercentage: profile.tierProgressPercentage,
          onTap: () => ProfileAttachmentFlow.start(
            context,
            ProfileAttachment.picture,
            exists: profile.hasProfilePicture,
          ),
        );
      },
    );
  }
}
