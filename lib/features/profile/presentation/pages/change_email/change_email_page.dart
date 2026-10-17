import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../../core/di/service_locator.dart';
import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../core/routes/app_routes.dart';
import '../../../../../core/shared/widgets/app_app_bar.dart';
import '../../../../../core/shared/widgets/app_button.dart';
import '../../../../../core/shared/widgets/app_loading_overlay.dart';
import '../../../../../core/shared/widgets/app_page_header.dart';
import '../../../../../core/shared/widgets/app_text_field.dart';
import '../../../../../core/shared/widgets/app_toast.dart';
import '../../../../../core/state/form_status.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/validators/app_validators.dart';
import '../../cubit/change_email/change_email_cubit.dart';
import '../../cubit/change_email/change_email_state.dart';
import '../../cubit/profile/profile_cubit.dart';
import '../../widgets/edit_profile/field_card.dart';
import '../../../../../core/shared/widgets/app_bottom_safe_area.dart';

class ChangeEmailPage extends StatelessWidget {
  const ChangeEmailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: sl<ProfileCubit>()),
        BlocProvider(create: (_) => sl<ChangeEmailCubit>()),
      ],
      child: const _ChangeEmailView(),
    );
  }
}

class _ChangeEmailView extends StatefulWidget {
  const _ChangeEmailView();

  @override
  State<_ChangeEmailView> createState() => _ChangeEmailViewState();
}

class _ChangeEmailViewState extends State<_ChangeEmailView> {
  final _formKey = GlobalKey<FormState>();
  final _newEmailController = TextEditingController();
  final _currentPasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _newEmailController.addListener(_onInputChanged);
    _currentPasswordController.addListener(_onInputChanged);
  }

  @override
  void dispose() {
    _newEmailController.dispose();
    _currentPasswordController.dispose();
    super.dispose();
  }

  void _onInputChanged() => setState(() {});

  bool get _canSubmit =>
      _newEmailController.text.trim().isNotEmpty && _currentPasswordController.text.isNotEmpty;

  String _normalize(String? email) => email?.trim().toLowerCase() ?? '';

  void _submit() {
    FocusManager.instance.primaryFocus?.unfocus();
    if (!(_formKey.currentState?.validate() ?? false)) return;
    context.read<ChangeEmailCubit>().submit(
          currentPassword: _currentPasswordController.text,
          newEmail: _newEmailController.text.trim(),
        );
  }

  Future<void> _onStatusChanged(BuildContext context, ChangeEmailState state) async {
    if (state.status == FormStatus.failure) {
      AppToast.error(context, state.errorMessage ?? context.l10n.somethingWentWrong);
      return;
    }
    if (state.status != FormStatus.success) return;

    if (!state.verificationRequired) {
      AppToast.success(context, context.l10n.changeEmailSuccessMessage);
      context.pop();
      return;
    }

    final verified = await context.push<bool>(AppRoutes.verifyEmailChange, extra: state.newEmail);
    if (verified == true && context.mounted) context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final currentEmail = context.select((ProfileCubit cubit) => cubit.state.profile?.email);
    final emailConfirmed =
        context.select((ProfileCubit cubit) => cubit.state.profile?.emailConfirmed ?? false);

    return BlocConsumer<ChangeEmailCubit, ChangeEmailState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: _onStatusChanged,
      builder: (context, state) {
        return AppLoadingOverlay(
          isLoading: state.isSubmitting,
          child: Scaffold(
            appBar: AppAppBar(
              title: context.l10n.changeEmailTitle,
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
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              AppPageHeader(
                                title: context.l10n.changeEmailTitle,
                                subtitle: context.l10n.changeEmailSubtitle,
                              ),
                              SizedBox(height: AppSpacing.md),
                              FieldCard(
                                label: context.l10n.currentEmailLabel,
                                icon: LucideIcons.mail,
                                value: currentEmail,
                                badge: VerificationBadge(isVerified: emailConfirmed),
                              ),
                              SizedBox(height: AppSpacing.md),
                              AppTextField(
                                label: context.l10n.newEmailLabel,
                                hint: context.l10n.emailHint,
                                controller: _newEmailController,
                                keyboardType: TextInputType.emailAddress,
                                prefixIcon: LucideIcons.atSign,
                                textInputAction: TextInputAction.next,
                                autofocus: true,
                                validator: AppValidators.combine([
                                  AppValidators.required(context.l10n.fieldRequiredError),
                                  AppValidators.email(context.l10n.invalidEmailError),
                                  (value) => _normalize(value) == _normalize(currentEmail)
                                      ? context.l10n.newEmailSameAsCurrentError
                                      : null,
                                ]),
                              ),
                              SizedBox(height: AppSpacing.sm),
                              AppTextField(
                                label: context.l10n.currentPasswordLabel,
                                controller: _currentPasswordController,
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
                    AppButton.primary(
                      label: context.l10n.confirmButton,
                      onPressed: _canSubmit && !state.isSubmitting ? _submit : null,
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
