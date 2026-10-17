import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/config/app_assets.dart';
import '../../../../core/di/service_locator.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/shared/widgets/app_button.dart';
import '../../../../core/theme/app_spacing.dart';
import '../cubit/onboarding_cubit.dart';
import '../widgets/onboarding_language_pill.dart';
import '../../../../core/shared/widgets/app_bottom_safe_area.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<OnboardingCubit>(),
      child: const _OnboardingView(),
    );
  }
}

class _OnboardingView extends StatelessWidget {
  const _OnboardingView();

  Future<void> _getStarted(BuildContext context) async {
    await context.read<OnboardingCubit>().complete();
    if (context.mounted) context.go(AppRoutes.login);
  }

  @override
  Widget build(BuildContext context) {
    final isCompleting = context.watch<OnboardingCubit>().state;
    final margin = AppSpacing.screenMargin;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(AppAssets.onboardingBackground, fit: BoxFit.contain),
            PositionedDirectional(
              top: 0,
              start: 0,
              end: 0,
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                    margin,
                    AppSpacing.xs,
                    margin,
                    0,
                  ),
                  child: const Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: OnboardingLanguagePill(),
                  ),
                ),
              ),
            ),
            PositionedDirectional(
              start: 0,
              end: 0,
              bottom: 0,
              child: AppBottomSafeArea(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                    margin,
                    0,
                    margin,
                    AppSpacing.md,
                  ),
                  child: AppButton.primary(
                    label: context.l10n.onboardingGetStarted,
                    onPressed: isCompleting ? null : () => _getStarted(context),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
