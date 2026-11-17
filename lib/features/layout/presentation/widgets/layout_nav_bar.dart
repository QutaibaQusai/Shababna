import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/config/app_assets.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_shadows.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../volunteering_opportunities/presentation/widgets/date_filter/volunteering_opportunities_date_filter_sheet.dart';
import '../cubit/layout_cubit.dart';
import '../cubit/layout_tab.dart';
import '../../../../core/shared/widgets/app_bottom_safe_area.dart';

class LayoutNavBar extends StatelessWidget {
  const LayoutNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.viewInsetsOf(context).bottom > 0) return const SizedBox.shrink();

    return AppBottomSafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          AppSpacing.screenMargin,
          AppSpacing.xs,
          AppSpacing.screenMargin,
          AppSpacing.xs,
        ),
        child: const Row(children: [_TabsPill(), Spacer(), _NavAction()]),
      ),
    );
  }
}

class _NavAction extends StatelessWidget {
  const _NavAction();

  static const _duration = Duration(milliseconds: 350);
  static const _startTurns = -0.25;

  @override
  Widget build(BuildContext context) {
    final action = context.select((LayoutCubit cubit) => cubit.state.navAction);

    return AnimatedSwitcher(
      duration: _duration,
      switchInCurve: Curves.easeOutBack,
      switchOutCurve: Curves.easeIn,
      transitionBuilder: (child, animation) => RotationTransition(
        turns: Tween(begin: _startTurns, end: 0.0).animate(animation),
        child: FadeTransition(opacity: animation, child: child),
      ),
      child: switch (action) {
        LayoutNavAction.assistant => const _AssistantButton(
          key: ValueKey(LayoutNavAction.assistant),
        ),
        LayoutNavAction.filter => const _FilterButton(key: ValueKey(LayoutNavAction.filter)),
        null => const SizedBox.shrink(),
      },
    );
  }
}

class _FilterButton extends StatelessWidget {
  const _FilterButton({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colorScheme;
    final label = context.l10n.volunteeringOpportunitiesPickDate;

    return Semantics(
      button: true,
      label: label,
      child: Tooltip(
        message: label,
        child: Material(
          color: colors.primary,
          elevation: AppShadows.low,
          shadowColor: colors.shadow,
          shape: const CircleBorder(),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: () {
              HapticFeedback.selectionClick();
              showVolunteeringOpportunitiesDateFilterSheet(context);
            },
            child: SizedBox.square(
              dimension: AppSizes.navBarHeight,
              child: Icon(
                LucideIcons.calendarSearch,
                size: AppSizes.iconMd,
                color: colors.onPrimary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _TabsPill extends StatelessWidget {
  const _TabsPill();

  @override
  Widget build(BuildContext context) {
    final selected = context.watch<LayoutCubit>().state;
    final colors = context.colorScheme;

    return Container(
      height: AppSizes.navBarHeight,
      padding: EdgeInsets.all(AppSpacing.xxs),
      decoration: BoxDecoration(color: colors.surface, borderRadius: AppRadius.pillRadius),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final tab in LayoutTab.values) _TabItem(tab: tab, isSelected: tab == selected),
        ],
      ),
    );
  }
}

class _TabItem extends StatelessWidget {
  const _TabItem({required this.tab, required this.isSelected});

  static const _duration = Duration(milliseconds: 200);

  final LayoutTab tab;
  final bool isSelected;

  void _select(BuildContext context) {
    if (isSelected) return;
    HapticFeedback.selectionClick();
    context.read<LayoutCubit>().goTo(tab);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colorScheme;
    final l10n = context.l10n;

    return Semantics(
      button: true,
      selected: isSelected,
      label: tab.label(l10n),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => _select(context),
        child: SizedBox(
          width: AppSizes.navItemWidth,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedContainer(
                duration: _duration,
                curve: Curves.easeOut,
                width: AppSizes.navIndicatorSize,
                height: AppSizes.navIndicatorSize,
                decoration: BoxDecoration(
                  color: isSelected ? colors.primary : Colors.transparent,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  tab.icon,
                  size: AppSizes.iconMd,
                  color: isSelected ? colors.onPrimary : colors.onSurface,
                ),
              ),
              SizedBox(height: AppSpacing.xxs),
              Flexible(
                child: ExcludeSemantics(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: AnimatedDefaultTextStyle(
                      duration: _duration,
                      curve: Curves.easeOut,
                      style: context.textTheme.labelSmall!.copyWith(
                        color: isSelected ? colors.primary : colors.onSurfaceVariant,
                        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                      ),
                      child: Text(tab.navLabel(l10n), maxLines: 1),
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

class _AssistantButton extends StatelessWidget {
  const _AssistantButton({super.key});

  static const _animationScale = 1.0;
  static const _accentLightness = 0.62;
  static const _shadowLayer = 'Layer 1 Outlines';

  LottieDelegates _delegates(ColorScheme colors) {
    final accent = Color.lerp(colors.primary, Colors.white, _accentLightness)!;

    return LottieDelegates(
      values: [
        ValueDelegate.color(
          const ['**'],
          callback: (frame) {
            final original = frame.startValue;
            if (original == null) return accent;
            return _isCyan(original) ? accent : original;
          },
        ),
        ValueDelegate.transformOpacity(const [_shadowLayer], value: 0),
      ],
    );
  }

  static bool _isCyan(Color color) => color.r < 0.3 && color.g > 0.7 && color.b > 0.9;

  void _open(BuildContext context) {
    HapticFeedback.selectionClick();
    context.push(AppRoutes.assistant);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colorScheme;
    final label = context.l10n.assistantTitle;
    final size = AppSizes.navBarHeight;

    return Semantics(
      button: true,
      label: label,
      child: Tooltip(
        message: label,
        child: Material(
          color: colors.primary,
          elevation: AppShadows.low,
          shadowColor: colors.shadow,
          shape: const CircleBorder(),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: () => _open(context),
            child: SizedBox.square(
              dimension: size,
              child: OverflowBox(
                maxWidth: size * _animationScale,
                maxHeight: size * _animationScale,
                child: Lottie.asset(
                  AppAssets.assistantAnimation,
                  width: size * _animationScale,
                  height: size * _animationScale,
                  fit: BoxFit.contain,
                  frameRate: FrameRate.max,
                  delegates: _delegates(colors),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
