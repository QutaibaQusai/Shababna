import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/services/locale_service.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/spacing.dart';
import '../../data/onboarding_content.dart';
import '../../domain/entities/onboarding_item.dart';
import '../widgets/circular_navigation_button.dart';
import '../widgets/onboarding_curved_sheet.dart';
import '../widgets/onboarding_language_toggle_button.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return _OnboardingView(pages: OnboardingContent.items(context.l10n));
  }
}

class _OnboardingView extends StatefulWidget {
  const _OnboardingView({required this.pages});

  final List<OnboardingItem> pages;

  @override
  State<_OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<_OnboardingView> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _handleNext(int totalPages) {
    if (_currentPage < totalPages - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOutCubic,
      );
    } else {
      _completeOnboarding();
    }
  }

  void _completeOnboarding() {
    // Navigate to Home screen as default behavior
    context.go(AppRoutes.home);
  }

  @override
  Widget build(BuildContext context) {
    final pages = widget.pages;

    return Scaffold(
      body: Stack(
        children: [
          // Top Half - Images
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: MediaQuery.of(context).size.height * 0.6,
            child: PageView.builder(
              controller: _pageController,
              itemCount: pages.length,
              onPageChanged: (index) => setState(() => _currentPage = index),
              itemBuilder: (context, index) {
                return Image.asset(pages[index].imageUrl, fit: BoxFit.cover);
              },
            ),
          ),

          // Language toggle
          Positioned.directional(
            textDirection: Directionality.of(context),
            top: MediaQuery.paddingOf(context).top + AppSpacing.sm,
            end: AppSpacing.lg,
            child: OnboardingLanguageToggleButton(
              label: context.isArabic ? '?English' : 'عربي؟',
              onPressed: () =>
                  context.read<LocaleService>().toggleLocale(context.locale),
            ),
          ),

          // Bottom Half - Curved Sheet & Content
          Positioned(
            top: MediaQuery.of(context).size.height * 0.55,
            left: 0,
            right: 0,
            bottom: 0,
            child: OnboardingCurvedSheet(
              child: SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Title
                    SizedBox(
                      height: 70,
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Text(
                          pages[_currentPage].title,
                          style: context.textTheme.displayMedium,
                          textAlign: TextAlign.center,
                          maxLines: 2,
                        ),
                      ),
                    ),

                    // Decorative underline
                    Container(
                      margin: EdgeInsets.only(
                        top: AppSpacing.xs,
                        bottom: AppSpacing.md,
                      ),
                      width: 60,
                      height: 4,
                      decoration: BoxDecoration(
                        color: context.colorScheme.primary,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),

                    // Description
                    SizedBox(
                      height: 70,
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: Text(
                          pages[_currentPage].description,
                          style: context.textTheme.bodyLarge?.copyWith(
                            color: context.colorScheme.onSurface.withValues(
                              alpha: 0.8,
                            ),
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 3,
                        ),
                      ),
                    ),

                    verticalSpace(AppSpacing.lg),
                    // Navigation Button
                    CircularNavigationButton(
                      onPressed: () => _handleNext(pages.length),
                      progress: (_currentPage + 1) / pages.length,
                      isLastPage: _currentPage == pages.length - 1,
                    ),

                    verticalSpace(AppSpacing.xxl),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
