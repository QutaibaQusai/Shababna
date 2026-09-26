import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../core/shared/widgets/app_button.dart';
import '../../../../../core/shared/widgets/app_empty_widget.dart';
import '../../../../../core/shared/widgets/app_error_widget.dart';
import '../../../../../core/shared/widgets/app_search_field.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/app_sizes.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../domain/repositories/profile_repository.dart';
import '../../cubit/lookup/lookup_cubit.dart';
import '../../cubit/lookup/lookup_state.dart';
import 'field_card.dart';

class ProfileLookupField<T> extends StatelessWidget {
  const ProfileLookupField({
    super.key,
    required this.label,
    required this.icon,
    required this.selectedId,
    required this.selectedLabel,
    required this.loader,
    required this.idOf,
    required this.itemLabel,
    required this.onSelected,
  });

  final String label;
  final IconData icon;
  final String? selectedId;
  final String? selectedLabel;
  final LookupLoader<T> loader;
  final String Function(T item) idOf;
  final String Function(T item) itemLabel;
  final ValueChanged<T> onSelected;

  Future<void> _open(BuildContext context) async {
    final result = await showModalBottomSheet<_LookupSelection<T>>(
      context: context,
      isScrollControlled: true,
      builder: (_) => BlocProvider(
        create: (_) => LookupCubit<T>(loader)..load(),
        child: _ProfileLookupSheet<T>(
          title: label,
          idOf: idOf,
          itemLabel: itemLabel,
          initialSelectedIds: {?selectedId},
          multiSelect: false,
        ),
      ),
    );
    final items = result?.items;
    if (items != null && items.isNotEmpty) onSelected(items.first);
  }

  @override
  Widget build(BuildContext context) {
    return FieldCard(
      label: label,
      icon: icon,
      value: selectedLabel,
      onTap: () => _open(context),
    );
  }
}

class ProfileLookupMultiField<T> extends StatelessWidget {
  const ProfileLookupMultiField({
    super.key,
    required this.label,
    required this.icon,
    required this.selected,
    required this.loader,
    required this.idOf,
    required this.itemLabel,
    required this.onChanged,
  });

  final String label;
  final IconData icon;
  final List<ProfileReference> selected;
  final LookupLoader<T> loader;
  final String Function(T item) idOf;
  final String Function(T item) itemLabel;
  final ValueChanged<List<ProfileReference>> onChanged;

  Future<void> _open(BuildContext context) async {
    final result = await showModalBottomSheet<_LookupSelection<T>>(
      context: context,
      isScrollControlled: true,
      builder: (_) => BlocProvider(
        create: (_) => LookupCubit<T>(loader)..load(),
        child: _ProfileLookupSheet<T>(
          title: label,
          idOf: idOf,
          itemLabel: itemLabel,
          initialSelectedIds: selected.map((item) => item.id).toSet(),
          multiSelect: true,
        ),
      ),
    );
    if (result == null) return;
    final pickedIds = result.items.map(idOf).toSet();
    onChanged([
      for (final item in result.items) ProfileReference(id: idOf(item), name: itemLabel(item)),
      for (final reference in selected)
        if (result.selectedIds.contains(reference.id) && !pickedIds.contains(reference.id))
          reference,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return FieldCard(
      label: label,
      icon: icon,
      value: selected.map((item) => item.name).join(context.isArabic ? '، ' : ', '),
      onTap: () => _open(context),
    );
  }
}

class _LookupSelection<T> {
  const _LookupSelection({required this.items, required this.selectedIds});

  final List<T> items;
  final Set<String> selectedIds;
}

class _ProfileLookupSheet<T> extends StatefulWidget {
  const _ProfileLookupSheet({
    required this.title,
    required this.idOf,
    required this.itemLabel,
    required this.initialSelectedIds,
    required this.multiSelect,
  });

  final String title;
  final String Function(T item) idOf;
  final String Function(T item) itemLabel;
  final Set<String> initialSelectedIds;
  final bool multiSelect;

  @override
  State<_ProfileLookupSheet<T>> createState() => _ProfileLookupSheetState<T>();
}

class _ProfileLookupSheetState<T> extends State<_ProfileLookupSheet<T>> {
  late final Set<String> _selectedIds = {...widget.initialSelectedIds};
  String _query = '';

  List<T> _filter(List<T> items) {
    final query = _query.trim().toLowerCase();
    if (query.isEmpty) return items;
    return items.where((item) => widget.itemLabel(item).toLowerCase().contains(query)).toList();
  }

  void _onTap(T item) {
    final id = widget.idOf(item);
    if (!widget.multiSelect) {
      Navigator.of(context).pop(_LookupSelection<T>(items: [item], selectedIds: {id}));
      return;
    }
    setState(() => _selectedIds.contains(id) ? _selectedIds.remove(id) : _selectedIds.add(id));
  }

  void _done(List<T> items) {
    Navigator.of(context).pop(
      _LookupSelection<T>(
        items: items.where((item) => _selectedIds.contains(widget.idOf(item))).toList(),
        selectedIds: _selectedIds,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        height: MediaQuery.sizeOf(context).height * 0.75,
        child: Padding(
          padding: EdgeInsetsDirectional.fromSTEB(
            AppSpacing.screenMargin,
            AppSpacing.xs,
            AppSpacing.screenMargin,
            AppSpacing.screenMargin,
          ),
          child: BlocBuilder<LookupCubit<T>, LookupState<T>>(
            builder: (context, state) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    widget.title,
                    style: context.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: AppSpacing.sm),
                  AppSearchField(
                    hint: context.l10n.actionSearch,
                    onChanged: (value) => setState(() => _query = value),
                  ),
                  SizedBox(height: AppSpacing.sm),
                  Expanded(child: _body(context, state)),
                  if (widget.multiSelect) ...[
                    SizedBox(height: AppSpacing.sm),
                    AppButton.primary(
                      label: context.l10n.doneButton,
                      onPressed: state.items.isEmpty ? null : () => _done(state.items),
                    ),
                  ],
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _body(BuildContext context, LookupState<T> state) {
    if (state.isLoading) return const _LookupSkeleton();
    if (state.hasError) {
      return AppErrorWidget(
        message: state.errorMessage ?? context.l10n.somethingWentWrong,
        onRetry: () => context.read<LookupCubit<T>>().load(),
      );
    }

    final items = _filter(state.items);
    if (items.isEmpty) return const AppEmptyWidget();

    return ListView.separated(
      itemCount: items.length,
      separatorBuilder: (context, index) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final item = items[index];
        return _LookupRow(
          label: widget.itemLabel(item),
          isSelected: _selectedIds.contains(widget.idOf(item)),
          multiSelect: widget.multiSelect,
          onTap: () => _onTap(item),
        );
      },
    );
  }
}

class _LookupRow extends StatelessWidget {
  const _LookupRow({
    required this.label,
    required this.isSelected,
    required this.multiSelect,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final bool multiSelect;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: AppRadius.mdRadius,
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: AppSpacing.sm, horizontal: AppSpacing.xs),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: context.textTheme.bodyLarge?.copyWith(
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
                  color: isSelected ? context.colorScheme.primary : null,
                ),
              ),
            ),
            if (multiSelect)
              Checkbox(
                value: isSelected,
                onChanged: (_) => onTap(),
                shape: const CircleBorder(),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                visualDensity: VisualDensity.compact,
              )
            else if (isSelected)
              Icon(
                LucideIcons.circleCheck,
                size: AppSizes.iconField,
                color: context.colorScheme.primary,
              ),
          ],
        ),
      ),
    );
  }
}

class _LookupSkeleton extends StatelessWidget {
  const _LookupSkeleton();

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: true,
      child: ListView.separated(
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 8,
        separatorBuilder: (context, index) => const Divider(height: 1),
        itemBuilder: (context, index) => Padding(
          padding: EdgeInsets.symmetric(vertical: AppSpacing.sm, horizontal: AppSpacing.xs),
          child: const Text('Lookup item placeholder'),
        ),
      ),
    );
  }
}
