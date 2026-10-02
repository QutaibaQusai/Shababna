import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/service_locator.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../cubit/onboarding_cubit.dart';
import '../cubit/onboarding_step.dart';
import '../widgets/onboarding_language_pill.dart';
import '../../../../core/shared/widgets/app_button.dart';
import '../widgets/onboarding_notifications_action.dart';
import '../widgets/onboarding_page_dots.dart';
import '../widgets/onboarding_slide.dart';
import '../widgets/onboarding_theme_options.dart';

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

  final _pageController = PageController();
  bool _isFinishing = false;
  bool _didPrecache = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_didPrecache) return;
    _didPrecache = true;
    for (final step in OnboardingStep.values) {
      precacheImage(AssetImage(step.image), context);
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _next() {
    HapticFeedback.selectionClick();
    _pageController.nextPage(duration: _pageDuration, curve: Curves.easeOutCubic);
  }

  void _previous() {
    _pageController.previousPage(duration: _pageDuration, curve: Curves.easeOutCubic);
  }

  Future<void> _finish() async {
    if (_isFinishing) return;
    setState(() => _isFinishing = true);
    await context.read<OnboardingCubit>().complete();
    if (!mounted) return;
    context.go(AppRoutes.login);
  }

  Widget _slide(OnboardingStep step) => OnboardingSlide(
        step: step,
        child: switch (step) {
          OnboardingStep.theme => const OnboardingThemeOptions(),
          OnboardingStep.notifications => const OnboardingNotificationsAction(),
          _ => null,
        },
      );

  @override
  Widget build(BuildContext context) {
    final page = context.select((OnboardingCubit cubit) => cubit.state.page);
    final steps = OnboardingStep.values;
    final step = steps[page];
    final l10n = context.l10n;
    final margin = AppSpacing.screenMargin;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: PopScope(
        canPop: page == 0,
        onPopInvokedWithResult: (didPop, _) {
          if (!didPop) _previous();
        },
        child: Scaffold(
          backgroundColor: Colors.black,
          body: Stack(
            children: [
              PageView.builder(
                controller: _pageController,
                physics: const BouncingScrollPhysics(),
                itemCount: steps.length,
                onPageChanged: context.read<OnboardingCubit>().pageChanged,
                itemBuilder: (context, index) => _slide(steps[index]),
              ),
              PositionedDirectional(
                top: 0,
                start: 0,
                end: 0,
                child: SafeArea(
                  bottom: false,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(margin, AppSpacing.xs, margin, 0),
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
                child: SafeArea(
                  top: false,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(margin, 0, margin, AppSpacing.md),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        OnboardingPageDots(current: page, total: steps.length),
                        SizedBox(height: AppSpacing.md),
                        AppButton.primary(
                          label: step.isLast ? l10n.onboardingGetStarted : l10n.onboardingNext,
                          onPressed: _isFinishing ? null : (step.isLast ? _finish : _next),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
