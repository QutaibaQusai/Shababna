import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../../core/di/service_locator.dart';
import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../core/shared/widgets/app_app_bar.dart';
import '../../../../../core/shared/widgets/app_dialog.dart';
import '../../../../../core/shared/widgets/app_loading_overlay.dart';
import '../../../../../core/shared/widgets/app_page_header.dart';
import '../../../../../core/shared/widgets/app_text_field.dart';
import '../../../../../core/shared/widgets/app_toast.dart';
import '../../../../../core/state/form_status.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/app_sizes.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/validators/app_validators.dart';
import '../../cubit/delete_account/delete_account_cubit.dart';
import '../../cubit/delete_account/delete_account_state.dart';
import '../../../../../core/shared/widgets/app_bottom_safe_area.dart';

class DeleteAccountPage extends StatelessWidget {
  const DeleteAccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<DeleteAccountCubit>(),
      child: const _DeleteAccountView(),
    );
  }
}

class _DeleteAccountView extends StatefulWidget {
  const _DeleteAccountView();

  @override
  State<_DeleteAccountView> createState() => _DeleteAccountViewState();
}

class _DeleteAccountViewState extends State<_DeleteAccountView> {

  final _formKey = GlobalKey<FormState>();
  final _reasonController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _passwordController.addListener(_onPasswordChanged);
  }

  @override
  void dispose() {
    _reasonController.dispose();
    _passwordController
      ..removeListener(_onPasswordChanged)
      ..dispose();
    super.dispose();
  }

  void _onPasswordChanged() => setState(() {});

  Future<void> _submit() async {
    FocusManager.instance.primaryFocus?.unfocus();
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final confirmed = await AppDialog.confirm(
      context,
      title: context.l10n.deleteAccountConfirmTitle,
      message: context.l10n.deleteAccountConfirmMessage,
      confirmText: context.l10n.deleteAccountButton,
      cancelText: context.l10n.cancelButton,
      isDestructive: true,
    );
    if (!confirmed || !mounted) return;

    context.read<DeleteAccountCubit>().submit(
          currentPassword: _passwordController.text,
          reason: _reasonController.text,
        );
  }

  void _onStatusChanged(BuildContext context, DeleteAccountState state) {
    if (state.status == FormStatus.success) {
      AppToast.success(context, context.l10n.deleteAccountSuccessMessage);
    } else if (state.status == FormStatus.failure) {
      AppToast.error(context, state.errorMessage ?? context.l10n.somethingWentWrong);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DeleteAccountCubit, DeleteAccountState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: _onStatusChanged,
      builder: (context, state) {
        final canSubmit = _passwordController.text.isNotEmpty && !state.isSubmitting;

        return AppLoadingOverlay(
          isLoading: state.isSubmitting,
          child: Scaffold(
            appBar: AppAppBar(
              title: context.l10n.deleteAccountTitle,
              onBack: () => context.pop(),
            ),
            body: AppBottomSafeArea(
              top: true,
              child: Padding(
                padding: EdgeInsets.all(AppSpacing.screenMargin),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              AppPageHeader(
                                title: context.l10n.deleteAccountTitle,
                                subtitle: context.l10n.deleteAccountSubtitle,
                              ),
                              SizedBox(height: AppSpacing.md),
                              AppTextField(
                                label: context.l10n.deleteAccountReasonLabel,
                                controller: _reasonController,
                                textInputAction: TextInputAction.newline,
                                keyboardType: TextInputType.multiline,
                                minLines: 4,
                                maxLines: 8,
                              ),
                              SizedBox(height: AppSpacing.sm),
                              AppTextField(
                                label: context.l10n.currentPasswordLabel,
                                controller: _passwordController,
                                obscureText: true,
                                prefixIcon: LucideIcons.lock,
                                textInputAction: TextInputAction.done,
                                validator: AppValidators.required(context.l10n.fieldRequiredError),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: AppSpacing.sm),
                    SizedBox(
                      height: AppSizes.buttonHeight,
                      child: ElevatedButton(
                        onPressed: canSubmit ? _submit : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: context.colorScheme.error,
                          foregroundColor: context.colorScheme.onError,
                          disabledBackgroundColor: context.colorScheme.error.withValues(alpha: 0.4),
                          disabledForegroundColor: context.colorScheme.onError,
                          shape: RoundedRectangleBorder(borderRadius: AppRadius.mdRadius),
                        ),
                        child: Text(context.l10n.deleteAccountButton),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
