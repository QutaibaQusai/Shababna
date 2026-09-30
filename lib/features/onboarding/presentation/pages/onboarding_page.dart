import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/service_locator.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/shared/widgets/app_button.dart';
import '../../../../core/theme/app_spacing.dart';
import '../cubit/onboarding_cubit.dart';
import '../cubit/onboarding_step.dart';
import '../widgets/onboarding_language_step.dart';
import '../widgets/onboarding_notifications_step.dart';
import '../widgets/onboarding_progress_bar.dart';
import '../widgets/onboarding_step_layout.dart';
import '../widgets/onboarding_theme_step.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<OnboardingCubit>()..start(),
      child: const _OnboardingView(),
    );
  }
}

class _OnboardingView extends StatefulWidget {
  const _OnboardingView();

  @override
  State<_OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<_OnboardingView> {
  static const _pageDuration = Duration(milliseconds: 350);
  static const _fadeDuration = Duration(milliseconds: 200);

  final _pageController = PageController();
  bool _isFinishing = false;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _next() {
    HapticFeedback.selectionClick();
    _pageController.nextPage(duration: _pageDuration, curve: Curves.easeOutCubic);
  }

  Future<void> _finish() async {
    if (_isFinishing) return;
    setState(() => _isFinishing = true);
    await context.read<OnboardingCubit>().complete();
    if (!mounted) return;
    context.go(AppRoutes.login);
  }

  Widget _stepView(OnboardingStep step) => switch (step) {
        OnboardingStep.language => const OnboardingLanguageStep(),
        OnboardingStep.theme => const OnboardingThemeStep(),
        OnboardingStep.notifications => const OnboardingNotificationsStep(),
        _ => OnboardingStepLayout(step: step),
      };

  @override
  Widget build(BuildContext context) {
    final page = context.select((OnboardingCubit cubit) => cubit.state.page);
    final step = OnboardingStep.values[page];
    final l10n = context.l10n;
    final steps = OnboardingStep.values;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(
                AppSpacing.screenMargin,
                AppSpacing.xs,
                AppSpacing.xs,
                0,
              ),
              child: Row(
                children: [
                  Expanded(child: OnboardingProgressBar(current: page, total: steps.length)),
                  SizedBox(width: AppSpacing.xs),
                  AnimatedOpacity(
                    duration: _fadeDuration,
                    opacity: step.isLast ? 0 : 1,
                    child: IgnorePointer(
                      ignoring: step.isLast,
                      child: TextButton(
                        onPressed: _finish,
                        child: Text(l10n.onboardingSkip),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                physics: const BouncingScrollPhysics(),
                itemCount: steps.length,
                onPageChanged: context.read<OnboardingCubit>().pageChanged,
                itemBuilder: (context, index) => _stepView(steps[index]),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(
                AppSpacing.screenMargin,
                AppSpacing.xs,
                AppSpacing.screenMargin,
                AppSpacing.sm,
              ),
              child: SizedBox(
                width: double.infinity,
                child: AppButton.primary(
                  label: step.isLast ? l10n.onboardingGetStarted : l10n.onboardingNext,
                  onPressed: _isFinishing ? null : (step.isLast ? _finish : _next),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
