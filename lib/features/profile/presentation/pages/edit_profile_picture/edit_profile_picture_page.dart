import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../../core/di/service_locator.dart';
import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../core/shared/widgets/app_app_bar.dart';
import '../../../../../core/shared/widgets/app_button.dart';
import '../../../../../core/shared/widgets/app_loading_overlay.dart';
import '../../../../../core/shared/widgets/app_toast.dart';
import '../../../../../core/state/form_status.dart';
import '../../../../../core/storage/secure_storage.dart';
import '../../../../../core/storage/storage_keys.dart';
import '../../../../../core/theme/app_sizes.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../cubit/edit_profile_picture/edit_profile_picture_cubit.dart';
import '../../cubit/edit_profile_picture/edit_profile_picture_state.dart';

class EditProfilePicturePage extends StatelessWidget {
  const EditProfilePicturePage({super.key, required this.hasPicture, this.pictureUrl});

  final bool hasPicture;
  final String? pictureUrl;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<EditProfilePictureCubit>(),
      child: _EditProfilePictureView(hasPicture: hasPicture, pictureUrl: pictureUrl),
    );
  }
}

class _EditProfilePictureView extends StatefulWidget {
  const _EditProfilePictureView({required this.hasPicture, this.pictureUrl});

  final bool hasPicture;
  final String? pictureUrl;

  @override
  State<_EditProfilePictureView> createState() => _EditProfilePictureViewState();
}

class _EditProfilePictureViewState extends State<_EditProfilePictureView> {
  bool _hasPicture = false;
  String? _pictureUrl;
  String? _localPreviewPath;

  @override
  void initState() {
    super.initState();
    _hasPicture = widget.hasPicture;
    _pictureUrl = widget.pictureUrl;
  }

  Future<void> _pickImage(ImageSource source) async {
    Navigator.of(context).pop();
    final file = await ImagePicker().pickImage(source: source, imageQuality: 85);
    if (file == null || !mounted) return;

    setState(() => _localPreviewPath = file.path);
    context.read<EditProfilePictureCubit>().upload(file.path);
  }

  void _openSourceSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      builder: (sheetContext) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(LucideIcons.camera),
              title: Text(context.l10n.cameraOption),
              onTap: () => _pickImage(ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(LucideIcons.image),
              title: Text(context.l10n.galleryOption),
              onTap: () => _pickImage(ImageSource.gallery),
            ),
          ],
        ),
      ),
    );
  }

  void _remove(BuildContext context) {
    setState(() {
      _localPreviewPath = null;
      _hasPicture = false;
      _pictureUrl = null;
    });
    context.read<EditProfilePictureCubit>().remove();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<EditProfilePictureCubit, EditProfilePictureState>(
      listener: (context, state) {
        if (state.status == FormStatus.success) {
          AppToast.success(context, context.l10n.editProfilePictureSuccessMessage);
        } else if (state.status == FormStatus.failure) {
          AppToast.error(context, state.errorMessage ?? context.l10n.somethingWentWrong);
        }
      },
      child: BlocBuilder<EditProfilePictureCubit, EditProfilePictureState>(
        builder: (context, state) {
          return AppLoadingOverlay(
            isLoading: state.status == FormStatus.submitting,
            child: Scaffold(
              appBar: AppAppBar(
                title: context.l10n.profilePictureLabel,
                onBack: () => context.pop(true),
              ),
              body: SafeArea(
                child: Padding(
                  padding: EdgeInsets.all(AppSpacing.screenMargin),
                  child: Column(
                    children: [
                      SizedBox(height: AppSpacing.lg),
                      _buildPreview(context),
                      SizedBox(height: AppSpacing.md),
                      AppButton.primary(
                        label: context.l10n.choosePhotoButton,
                        onPressed: () => _openSourceSheet(context),
                      ),
                      if (_hasPicture) ...[
                        SizedBox(height: AppSpacing.sm),
                        AppButton.secondary(
                          label: context.l10n.removePhotoButton,
                          onPressed: () => _remove(context),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPreview(BuildContext context) {
    final size = AppSizes.avatarSize * 3;

    Widget child;
    if (_localPreviewPath != null) {
      child = Image.file(
        File(_localPreviewPath!),
        fit: BoxFit.cover,
        width: size,
        height: size,
      );
    } else if (_hasPicture && _pictureUrl != null) {
      child = FutureBuilder<String?>(
        future: sl<AppSecureStorage>().read(StorageKeys.accessToken),
        builder: (context, snapshot) {
          final token = snapshot.data;
          if (token == null) return Icon(LucideIcons.user, size: size / 2);

          return CachedNetworkImage(
            imageUrl: _pictureUrl!,
            httpHeaders: {'Authorization': 'Bearer $token'},
            fit: BoxFit.cover,
            width: size,
            height: size,
            placeholder: (context, url) => Icon(LucideIcons.user, size: size / 2),
            errorWidget: (context, url, error) => Icon(LucideIcons.user, size: size / 2),
          );
        },
      );
    } else {
      child = Icon(LucideIcons.user, size: size / 2, color: context.colorScheme.onSurfaceVariant);
    }

    return ClipOval(
      child: Container(
        width: size,
        height: size,
        color: context.colorScheme.surfaceContainerHighest,
        child: child,
      ),
    );
  }
}
