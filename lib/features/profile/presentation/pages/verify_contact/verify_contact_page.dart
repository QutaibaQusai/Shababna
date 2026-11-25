import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/config/app_config.dart';
import '../../../../../core/di/service_locator.dart';
import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../core/shared/widgets/app_app_bar.dart';
import '../../../../../core/shared/widgets/app_bottom_safe_area.dart';
import '../../../../../core/shared/widgets/app_button.dart';
import '../../../../../core/shared/widgets/app_cooldown_timer.dart';
import '../../../../../core/shared/widgets/app_loading_overlay.dart';
import '../../../../../core/shared/widgets/app_otp_field.dart';
import '../../../../../core/shared/widgets/app_page_header.dart';
import '../../../../../core/shared/widgets/app_toast.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/validators/app_validators.dart';
import '../../../../auth/domain/verification_channel.dart';
import '../../cubit/profile/profile_cubit.dart';
import '../../cubit/verify_contact/verify_contact_cubit.dart';
import '../../cubit/verify_contact/verify_contact_state.dart';

class VerifyContactPage extends StatelessWidget {
  const VerifyContactPage({super.key, required this.channel});

  final VerificationChannel channel;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: sl<ProfileCubit>()),
        BlocProvider(create: (_) => sl<VerifyContactCubit>(param1: channel)..start()),
      ],
      child: const _VerifyContactView(),
    );
  }
}

class _VerifyContactView extends StatefulWidget {
  const _VerifyContactView();

  @override
  State<_VerifyContactView> createState() => _VerifyContactViewState();
}

class _VerifyContactViewState extends State<_VerifyContactView> {
  static const _leftToRightIsolate = '\u2066';
  static const _popDirectionalIsolate = '\u2069';

  final _formKey = GlobalKey<FormState>();
  final _codeController = TextEditingController();

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    context.read<VerifyContactCubit>().verify(_codeController.text.trim());
  }

  void _onStateChanged(BuildContext context, VerifyContactState state) {
    final error = state.errorMessage;
    if (error != null) {
      _codeController.clear();
      AppToast.error(context, error);
    }
    if (state.status == VerifyContactStatus.verified) {
      AppToast.success(context, state.message ?? context.l10n.contactVerifiedMessage);
      context.pop(true);
    }
  }

  String _destination(BuildContext context, VerificationChannel channel) {
    final profile = context.select((ProfileCubit cubit) => cubit.state.profile);
    return switch (channel) {
      VerificationChannel.email => profile?.email ?? '',
      VerificationChannel.phone =>
        '$_leftToRightIsolate${profile?.phoneNumber ?? ''}$_popDirectionalIsolate',
    };
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BlocConsumer<VerifyContactCubit, VerifyContactState>(
      listener: _onStateChanged,
      builder: (context, state) {
        final title = state.channel == VerificationChannel.phone
            ? l10n.verifyPhoneTitle
            : l10n.verifyEmailTitle;

        return AppLoadingOverlay(
          isLoading: state.isBusy,
          child: Scaffold(
            appBar: AppAppBar(title: title, onBack: () => context.pop()),
            body: AppBottomSafeArea(
              top: true,
              child: SingleChildScrollView(
                padding: EdgeInsets.all(AppSpacing.screenMargin),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      AppPageHeader(
                        title: title,
                        subtitle: l10n.verifyEmailSubtitle(_destination(context, state.channel)),
                      ),
                      SizedBox(height: AppSpacing.md),
                      AppOtpField(
                        controller: _codeController,
                        autofocus: true,
                        onCompleted: (_) => _submit(),
                        validator: AppValidators.exactLength(
                          AppConfig.otpLength,
                          l10n.invalidCodeError(AppConfig.otpLength),
                        ),
                      ),
                      SizedBox(height: AppSpacing.md),
                      AppButton.primary(label: l10n.verifyButton, onPressed: _submit),
                      SizedBox(height: AppSpacing.sm),
                      Center(child: Text(l10n.resendCodePrompt)),
                      Center(
                        child: AppCooldownTimer(
                          key: ValueKey(state.cooldownVersion),
                          label: l10n.resendCodeButton,
                          cooldownSeconds: state.cooldownSeconds,
                          onPressed: context.read<VerifyContactCubit>().resend,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
