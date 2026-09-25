import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../../core/di/service_locator.dart';
import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../core/shared/widgets/app_app_bar.dart';
import '../../../../../core/shared/widgets/app_button.dart';
import '../../../../../core/shared/widgets/app_loading_overlay.dart';
import '../../../../../core/shared/widgets/app_page_header.dart';
import '../../../../../core/shared/widgets/app_text_field.dart';
import '../../../../../core/shared/widgets/app_toast.dart';
import '../../../../../core/state/form_status.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/validators/app_validators.dart';
import '../../cubit/change_phone_number/change_phone_number_cubit.dart';
import '../../cubit/change_phone_number/change_phone_number_state.dart';

class ChangePhoneNumberPage extends StatelessWidget {
  const ChangePhoneNumberPage({super.key, this.currentPhoneNumber});

  final String? currentPhoneNumber;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ChangePhoneNumberCubit>(),
      child: _ChangePhoneNumberView(currentPhoneNumber: currentPhoneNumber),
    );
  }
}

class _ChangePhoneNumberView extends StatefulWidget {
  const _ChangePhoneNumberView({this.currentPhoneNumber});

  final String? currentPhoneNumber;

  @override
  State<_ChangePhoneNumberView> createState() => _ChangePhoneNumberViewState();
}

class _ChangePhoneNumberViewState extends State<_ChangePhoneNumberView> {
  final _formKey = GlobalKey<FormState>();
  late final _phoneNumberController =
      TextEditingController(text: widget.currentPhoneNumber ?? '');

  @override
  void dispose() {
    _phoneNumberController.dispose();
    super.dispose();
  }

  void _submit(BuildContext context) {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    context.read<ChangePhoneNumberCubit>().submit(_phoneNumberController.text.trim());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ChangePhoneNumberCubit, ChangePhoneNumberState>(
      listener: (context, state) {
        if (state.status == FormStatus.success) {
          AppToast.success(context, context.l10n.changePhoneNumberSuccessMessage);
          context.pop(true);
        } else if (state.status == FormStatus.failure) {
          AppToast.error(context, state.errorMessage ?? context.l10n.somethingWentWrong);
        }
      },
      child: BlocBuilder<ChangePhoneNumberCubit, ChangePhoneNumberState>(
        builder: (context, state) {
          return AppLoadingOverlay(
            isLoading: state.status == FormStatus.submitting,
            child: Scaffold(
              appBar: AppAppBar(
                title: context.l10n.changePhoneNumberTitle,
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
                                  title: context.l10n.changePhoneNumberTitle,
                                  subtitle: context.l10n.changePhoneNumberSubtitle,
                                ),
                                SizedBox(height: AppSpacing.md),
                                AppTextField(
                                  label: context.l10n.phoneNumberLabel,
                                  controller: _phoneNumberController,
                                  keyboardType: TextInputType.phone,
                                  prefixIcon: LucideIcons.phone,
                                  textInputAction: TextInputAction.done,
                                  autofocus: true,
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
