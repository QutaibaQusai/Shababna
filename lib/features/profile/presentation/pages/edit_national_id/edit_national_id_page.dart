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
import '../../../../../core/theme/app_sizes.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../cubit/edit_national_id/edit_national_id_cubit.dart';
import '../../cubit/edit_national_id/edit_national_id_state.dart';

class EditNationalIdPage extends StatelessWidget {
  const EditNationalIdPage({super.key, required this.hasPicture});

  final bool hasPicture;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<EditNationalIdCubit>(),
      child: _EditNationalIdView(hasPicture: hasPicture),
    );
  }
}

class _EditNationalIdView extends StatefulWidget {
  const _EditNationalIdView({required this.hasPicture});

  final bool hasPicture;

  @override
  State<_EditNationalIdView> createState() => _EditNationalIdViewState();
}

class _EditNationalIdViewState extends State<_EditNationalIdView> {
  late bool _hasPicture = widget.hasPicture;

  Future<void> _pickImage(ImageSource source) async {
    Navigator.of(context).pop();
    final file = await ImagePicker().pickImage(source: source, imageQuality: 85);
    if (file == null || !mounted) return;

    setState(() => _hasPicture = true);
    context.read<EditNationalIdCubit>().upload(file.path);
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
    setState(() => _hasPicture = false);
    context.read<EditNationalIdCubit>().remove();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<EditNationalIdCubit, EditNationalIdState>(
      listener: (context, state) {
        if (state.status == FormStatus.success) {
          AppToast.success(context, context.l10n.editNationalIdSuccessMessage);
        } else if (state.status == FormStatus.failure) {
          AppToast.error(context, state.errorMessage ?? context.l10n.somethingWentWrong);
        }
      },
      child: BlocBuilder<EditNationalIdCubit, EditNationalIdState>(
        builder: (context, state) {
          return AppLoadingOverlay(
            isLoading: state.status == FormStatus.submitting,
            child: Scaffold(
              appBar: AppAppBar(
                title: context.l10n.nationalIdPictureLabel,
                onBack: () => context.pop(true),
              ),
              body: SafeArea(
                child: Padding(
                  padding: EdgeInsets.all(AppSpacing.screenMargin),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(height: AppSpacing.lg),
                      Center(
                        child: Icon(
                          LucideIcons.idCard,
                          size: AppSizes.iconLg * 2,
                          color: context.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      SizedBox(height: AppSpacing.sm),
                      Center(
                        child: Text(
                          _hasPicture
                              ? context.l10n.documentUploadedStatus
                              : context.l10n.documentNotUploadedStatus,
                          style: context.textTheme.bodyLarge,
                        ),
                      ),
                      SizedBox(height: AppSpacing.md),
                      AppButton.primary(
                        label: _hasPicture
                            ? context.l10n.replacePhotoButton
                            : context.l10n.choosePhotoButton,
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
}
