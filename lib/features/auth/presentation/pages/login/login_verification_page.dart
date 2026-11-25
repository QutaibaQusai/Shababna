import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/di/service_locator.dart';
import '../../../../../core/shared/widgets/app_app_bar.dart';
import '../../../../../core/shared/widgets/app_bottom_safe_area.dart';
import '../../../../../core/shared/widgets/app_loading_overlay.dart';
import '../../../../../core/shared/widgets/app_toast.dart';
import '../../../domain/login_verification.dart';
import '../../cubit/login_verification/login_verification_cubit.dart';
import '../../cubit/login_verification/login_verification_state.dart';
import '../../widgets/login/verification/login_verification_form.dart';

class LoginVerificationPage extends StatelessWidget {
  const LoginVerificationPage({super.key, required this.pending});

  final PendingVerification pending;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<LoginVerificationCubit>(param1: pending)..start(),
      child: const _LoginVerificationView(),
    );
  }
}

class _LoginVerificationView extends StatelessWidget {
  const _LoginVerificationView();

  void _onStateChanged(BuildContext context, LoginVerificationState state) {
    final error = state.errorMessage;
    if (error != null) AppToast.error(context, error);

    switch (state.status) {
      case LoginVerificationStatus.verified:
        context.pop(true);
      case LoginVerificationStatus.expired:
        context.pop(false);
      case LoginVerificationStatus.idle || LoginVerificationStatus.verifying:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginVerificationCubit, LoginVerificationState>(
      listener: _onStateChanged,
      builder: (context, state) {
        return AppLoadingOverlay(
          isLoading: state.isBusy,
          child: Scaffold(
            appBar: AppAppBar(title: '', onBack: () => context.pop(false)),
            body: const AppBottomSafeArea(child: LoginVerificationForm()),
          ),
        );
      },
    );
  }
}
