import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/di/service_locator.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/shared/widgets/app_app_bar.dart';
import '../../../../core/shared/widgets/app_button.dart';
import '../../../../core/shared/widgets/app_loading_overlay.dart';
import '../../../../core/shared/widgets/app_page_header.dart';
import '../../../../core/shared/widgets/app_text_field.dart';
import '../../../../core/shared/widgets/app_toast.dart';
import '../../../../core/state/form_status.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/validators/app_validators.dart';
import '../cubit/contact_form_cubit.dart';
import '../cubit/contact_form_state.dart';

class ContactFormPage extends StatelessWidget {
  const ContactFormPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ContactFormCubit>(),
      child: const _ContactFormView(),
    );
  }
}

class _ContactFormView extends StatefulWidget {
  const _ContactFormView();

  @override
  State<_ContactFormView> createState() => _ContactFormViewState();
}

class _ContactFormViewState extends State<_ContactFormView> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _subjectController = TextEditingController();
  final _messageController = TextEditingController();

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _subjectController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  void _submit(BuildContext context) {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    context.read<ContactFormCubit>().submit(
          fullName: _fullNameController.text.trim(),
          email: _emailController.text.trim(),
          subject: _subjectController.text.trim(),
          body: _messageController.text.trim(),
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ContactFormCubit, ContactFormState>(
      listener: (context, state) {
        if (state.status == FormStatus.success) {
          AppToast.success(context, context.l10n.contactSubmitSuccessMessage);
          context.pop();
        } else if (state.status == FormStatus.failure) {
          AppToast.error(context, state.errorMessage ?? context.l10n.somethingWentWrong);
        }
      },
      child: BlocBuilder<ContactFormCubit, ContactFormState>(
        builder: (context, state) {
          return AppLoadingOverlay(
            isLoading: state.status == FormStatus.submitting,
            child: Scaffold(
              appBar: AppAppBar(
                title: context.l10n.profileMenuContactUs,
                onBack: () => context.pop(),
              ),
              body: SafeArea(
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
                                  title: context.l10n.contactFormTitle,
                                  subtitle: context.l10n.contactFormSubtitle,
                                ),
                                SizedBox(height: AppSpacing.md),
                                AppTextField(
                                  label: context.l10n.fullNameLabel,
                                  controller: _fullNameController,
                                  textInputAction: TextInputAction.next,
                                  prefixIcon: LucideIcons.user,
                                  validator: AppValidators.required(context.l10n.fieldRequiredError),
                                ),
                                SizedBox(height: AppSpacing.sm),
                                AppTextField(
                                  label: context.l10n.emailLabel,
                                  controller: _emailController,
                                  keyboardType: TextInputType.emailAddress,
                                  textInputAction: TextInputAction.next,
                                  prefixIcon: LucideIcons.mail,
                                  validator: AppValidators.combine([
                                    AppValidators.required(context.l10n.fieldRequiredError),
                                    AppValidators.email(context.l10n.invalidEmailError),
                                  ]),
                                ),
                                SizedBox(height: AppSpacing.sm),
                                AppTextField(
                                  label: context.l10n.subjectLabel,
                                  controller: _subjectController,
                                  textInputAction: TextInputAction.next,
                                  prefixIcon: LucideIcons.tag,
                                  validator: AppValidators.required(context.l10n.fieldRequiredError),
                                ),
                                SizedBox(height: AppSpacing.sm),
                                AppTextField(
                                  label: context.l10n.messageLabel,
                                  controller: _messageController,
                                  textInputAction: TextInputAction.newline,
                                  maxLines: 6,
                                  minLines: 4,
                                  validator: AppValidators.required(context.l10n.fieldRequiredError),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: AppSpacing.sm),
                      AppButton.primary(
                        label: context.l10n.contactSendButton,
                        onPressed: () => _submit(context),
                      ),
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
