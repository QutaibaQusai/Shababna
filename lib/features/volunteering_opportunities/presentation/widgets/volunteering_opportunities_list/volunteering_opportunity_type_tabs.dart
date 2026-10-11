import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/app_sizes.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../cubit/volunteering_opportunity_types/volunteering_opportunity_types_cubit.dart';
import '../../cubit/volunteering_opportunities_list/volunteering_opportunities_list_cubit.dart';

class VolunteeringOpportunityTypeTabs extends StatelessWidget {
  const VolunteeringOpportunityTypeTabs({super.key});

  static const _skeletonLabels = ['All', 'Environment', 'Education', 'Community', 'Culture'];

  @override
  Widget build(BuildContext context) {
    final typesState = context.watch<VolunteeringOpportunityTypesCubit>().state;
    final selectedId = context.select(
      (VolunteeringOpportunitiesListCubit cubit) => cubit.state.typeId,
    );
    final visibleTypes = typesState.visibleTypes;

    if (typesState.isLoading) {
      return Skeletonizer(
        enabled: true,
        child: _TabsRow(
          children: [
            for (final label in _skeletonLabels)
              _TypeTab(label: label, isSelected: false, onTap: () {}),
          ],
        ),
      );
    }

    if (visibleTypes.isEmpty) return const SizedBox.shrink();

    final cubit = context.read<VolunteeringOpportunitiesListCubit>();
    final isArabic = context.isArabic;

    return _TabsRow(
      children: [
        _TypeTab(
          label: context.l10n.volunteeringOpportunitiesTypeAll,
          isSelected: selectedId == null,
          onTap: () => cubit.selectType(null),
        ),
        for (final type in visibleTypes)
          _TypeTab(
            label: type.name(isArabic),
            isSelected: selectedId == type.id,
            onTap: () => cubit.selectType(type.id),
          ),
      ],
    );
  }
}

class _TabsRow extends StatelessWidget {
  const _TabsRow({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.fromLTRB(
        AppSpacing.screenMargin,
        AppSpacing.xs,
        AppSpacing.screenMargin,
        0,
      ),
      child: Row(
        children: [
          for (var i = 0; i < children.length; i++) ...[
            if (i > 0) SizedBox(width: AppSpacing.xs),
            children[i],
          ],
        ],
      ),
    );
  }
}

class _TypeTab extends StatelessWidget {
  const _TypeTab({required this.label, required this.isSelected, required this.onTap});

  static const _duration = Duration(milliseconds: 200);

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  void _handleTap(BuildContext context) {
    Scrollable.ensureVisible(context, alignment: 0.5, duration: _duration);
    onTap();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colorScheme;

    return Semantics(
      button: true,
      selected: isSelected,
      child: InkWell(
        onTap: () => _handleTap(context),
        borderRadius: AppRadius.smRadius,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.xs, vertical: AppSpacing.xxs),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedDefaultTextStyle(
                duration: _duration,
                style: (context.textTheme.labelLarge ?? const TextStyle()).copyWith(
                  color: isSelected ? colors.primary : colors.onSurfaceVariant,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                ),
                child: Text(label),
              ),
              SizedBox(height: AppSpacing.xxs),
              AnimatedContainer(
                duration: _duration,
                width: AppSizes.tabIndicatorDotSize,
                height: AppSizes.tabIndicatorDotSize,
                decoration: BoxDecoration(
                  color: isSelected ? colors.primary : Colors.transparent,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
