import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
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
import '../../cubit/edit_cv/edit_cv_cubit.dart';
import '../../cubit/edit_cv/edit_cv_state.dart';

class EditCvPage extends StatelessWidget {
  const EditCvPage({super.key, required this.hasCv, this.cvFileName});

  final bool hasCv;
  final String? cvFileName;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<EditCvCubit>(),
      child: _EditCvView(hasCv: hasCv, cvFileName: cvFileName),
    );
  }
}

class _EditCvView extends StatefulWidget {
  const _EditCvView({required this.hasCv, this.cvFileName});

  final bool hasCv;
  final String? cvFileName;

  @override
  State<_EditCvView> createState() => _EditCvViewState();
}

class _EditCvViewState extends State<_EditCvView> {
  late bool _hasCv = widget.hasCv;
  late String? _fileName = widget.cvFileName;

  Future<void> _pickFile(BuildContext context) async {
    final file = await FilePickerPlatform.instance.pickFile(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx'],
    );
    final path = file?.path;
    if (path == null || !context.mounted) return;

    setState(() {
      _hasCv = true;
      _fileName = file!.name;
    });
    context.read<EditCvCubit>().upload(path);
  }

  void _remove(BuildContext context) {
    setState(() {
      _hasCv = false;
      _fileName = null;
    });
    context.read<EditCvCubit>().remove();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<EditCvCubit, EditCvState>(
      listener: (context, state) {
        if (state.status == FormStatus.success) {
          AppToast.success(context, context.l10n.editCvSuccessMessage);
        } else if (state.status == FormStatus.failure) {
          AppToast.error(context, state.errorMessage ?? context.l10n.somethingWentWrong);
        }
      },
      child: BlocBuilder<EditCvCubit, EditCvState>(
        builder: (context, state) {
          return AppLoadingOverlay(
            isLoading: state.status == FormStatus.submitting,
            child: Scaffold(
              appBar: AppAppBar(
                title: context.l10n.cvLabel,
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
                          LucideIcons.fileText,
                          size: AppSizes.iconLg * 2,
                          color: context.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      SizedBox(height: AppSpacing.sm),
                      Center(
                        child: Text(
                          _hasCv
                              ? (_fileName ?? context.l10n.documentUploadedStatus)
                              : context.l10n.documentNotUploadedStatus,
                          style: context.textTheme.bodyLarge,
                        ),
                      ),
                      SizedBox(height: AppSpacing.md),
                      AppButton.primary(
                        label: _hasCv ? context.l10n.replaceCvButton : context.l10n.uploadCvButton,
                        onPressed: () => _pickFile(context),
                      ),
                      if (_hasCv) ...[
                        SizedBox(height: AppSpacing.sm),
                        AppButton.secondary(
                          label: context.l10n.removeCvButton,
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
