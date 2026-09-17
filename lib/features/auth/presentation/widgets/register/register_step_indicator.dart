import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_sizes.dart';
import '../../../../../core/theme/app_spacing.dart';

const _kStepTransitionDuration = Duration(milliseconds: 500);
const _kStepTransitionCurve = Curves.easeInOut;

class RegisterStepIndicator extends StatelessWidget {
  const RegisterStepIndicator({
    super.key,
    required this.currentStep,
    required this.stepCount,
  });

  final int currentStep;
  final int stepCount;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (var i = 0; i < stepCount; i++) ...[
          _StepCircle(state: _stateFor(i), stepNumber: i + 1),
          if (i != stepCount - 1) Expanded(child: _StepConnector(filled: i < currentStep)),
        ],
      ],
    );
  }

  _StepState _stateFor(int index) {
    if (index < currentStep) return _StepState.done;
    if (index == currentStep) return _StepState.active;
    return _StepState.upcoming;
  }
}

enum _StepState { done, active, upcoming }

class _StepConnector extends StatelessWidget {
  const _StepConnector({required this.filled});

  final bool filled;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 2,
      margin: EdgeInsetsDirectional.symmetric(horizontal: AppSpacing.xs),
      child: Stack(
        alignment: AlignmentDirectional.centerStart,
        children: [
          Container(color: context.colorScheme.outlineVariant),
          AnimatedFractionallySizedBox(
            duration: _kStepTransitionDuration,
            curve: _kStepTransitionCurve,
            alignment: AlignmentDirectional.centerStart,
            widthFactor: filled ? 1 : 0,
            child: Container(color: AppColors.primaryColor),
          ),
        ],
      ),
    );
  }
}

class _StepCircle extends StatelessWidget {
  const _StepCircle({required this.state, required this.stepNumber});

  final _StepState state;
  final int stepNumber;

  @override
  Widget build(BuildContext context) {
    final isFilled = state == _StepState.done || state == _StepState.active;

    return AnimatedContainer(
      duration: _kStepTransitionDuration,
      curve: _kStepTransitionCurve,
      width: AppSizes.iconLg,
      height: AppSizes.iconLg,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isFilled ? AppColors.primaryColor : Colors.transparent,
        border: isFilled
            ? null
            : Border.all(color: context.colorScheme.outlineVariant, width: 1.5),
      ),
      child: Center(
        child: AnimatedSwitcher(
          duration: _kStepTransitionDuration,
          child: state == _StepState.done
              ? Icon(
                  LucideIcons.check,
                  key: const ValueKey('done'),
                  size: AppSizes.iconSm,
                  color: context.colorScheme.onPrimary,
                )
              : Text(
                  '$stepNumber',
                  key: ValueKey(stepNumber),
                  style: context.textTheme.labelMedium?.copyWith(
                    color: state == _StepState.active
                        ? context.colorScheme.onPrimary
                        : context.colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w600,
                  ),
                ),
        ),
      ),
    );
  }
}
