import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../core/shared/widgets/app_button.dart';
import '../../../../../core/shared/widgets/app_empty_widget.dart';
import '../../../../../core/shared/widgets/app_error_widget.dart';
import '../../../../../core/shared/widgets/app_loader.dart';
import '../../../../../core/shared/widgets/app_search_field.dart';
import '../../../../../core/shared/widgets/app_text_field.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/app_sizes.dart';
import '../../../../../core/theme/app_spacing.dart';

class MultiSelectField<T> extends StatefulWidget {
  const MultiSelectField({
    super.key,
    required this.label,
    required this.items,
    required this.itemLabel,
    required this.selectedItems,
    required this.onChanged,
    this.searchHint,
    this.prefixIcon,
    this.isLoading = false,
    this.errorMessage,
    this.onRetry,
  });

  final String label;
  final List<T> items;
  final String Function(T item) itemLabel;
  final List<T> selectedItems;
  final ValueChanged<List<T>> onChanged;
  final String? searchHint;
  final IconData? prefixIcon;
  final bool isLoading;
  final String? errorMessage;
  final VoidCallback? onRetry;

  @override
  State<MultiSelectField<T>> createState() => _MultiSelectFieldState<T>();
}

class _MultiSelectFieldState<T> extends State<MultiSelectField<T>> {
  late final _controller = TextEditingController(text: _displayText);

  String get _displayText =>
      widget.selectedItems.map(widget.itemLabel).join(', ');

  @override
  void didUpdateWidget(MultiSelectField<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedItems != widget.selectedItems) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _controller.text = _displayText;
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      label: widget.label,
      controller: _controller,
      readOnly: true,
      prefixIcon: widget.prefixIcon,
      suffix: Icon(LucideIcons.chevronDown, size: AppSizes.iconField),
      onTap: () => _openSheet(context),
    );
  }

  void _openSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (sheetContext) => _MultiSelectSheet<T>(
        items: widget.items,
        itemLabel: widget.itemLabel,
        selectedItems: widget.selectedItems,
        searchHint: widget.searchHint,
        isLoading: widget.isLoading,
        errorMessage: widget.errorMessage,
        onRetry: widget.onRetry,
        onDone: (items) {
          Navigator.of(sheetContext).pop();
          widget.onChanged(items);
        },
      ),
    );
  }
}

class _MultiSelectSheet<T> extends StatefulWidget {
  const _MultiSelectSheet({
    required this.items,
    required this.itemLabel,
    required this.selectedItems,
    required this.onDone,
    this.searchHint,
    this.isLoading = false,
    this.errorMessage,
    this.onRetry,
  });

  final List<T> items;
  final String Function(T item) itemLabel;
  final List<T> selectedItems;
  final ValueChanged<List<T>> onDone;
  final String? searchHint;
  final bool isLoading;
  final String? errorMessage;
  final VoidCallback? onRetry;

  @override
  State<_MultiSelectSheet<T>> createState() => _MultiSelectSheetState<T>();
}

class _MultiSelectSheetState<T> extends State<_MultiSelectSheet<T>> {
  late List<T> _filteredItems = widget.items;
  late final _selected = List<T>.of(widget.selectedItems);

  void _onSearchChanged(String query) {
    setState(() {
      _filteredItems = widget.items
          .where((item) =>
              widget.itemLabel(item).toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void _toggle(T item) {
    setState(() {
      if (_selected.contains(item)) {
        _selected.remove(item);
      } else {
        _selected.add(item);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        height: MediaQuery.sizeOf(context).height * 0.7,
        child: Padding(
          padding: EdgeInsets.only(
            left: AppSpacing.screenMargin,
            right: AppSpacing.screenMargin,
            bottom: AppSpacing.screenMargin,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppSearchField(hint: widget.searchHint, onChanged: _onSearchChanged),
              SizedBox(height: AppSpacing.sm),
              Expanded(child: _buildBody()),
              SizedBox(height: AppSpacing.sm),
              AppButton.primary(
                label: context.l10n.doneButton,
                onPressed: () => widget.onDone(_selected),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (widget.isLoading) return const AppLoader();
    if (widget.errorMessage != null) {
      return AppErrorWidget(message: widget.errorMessage!, onRetry: widget.onRetry);
    }
    if (_filteredItems.isEmpty) return const AppEmptyWidget();

    return ListView.separated(
      itemCount: _filteredItems.length,
      separatorBuilder: (context, index) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final item = _filteredItems[index];
        final isSelected = _selected.contains(item);
        return Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: AppRadius.mdRadius,
            onTap: () => _toggle(item),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: AppSpacing.sm, horizontal: AppSpacing.sm),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.itemLabel(item),
                      style: context.textTheme.bodyLarge?.copyWith(
                        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
                        color: isSelected ? context.colorScheme.primary : null,
                      ),
                    ),
                  ),
                  Checkbox(
                    value: isSelected,
                    onChanged: (_) => _toggle(item),
                    shape: const CircleBorder(),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    visualDensity: VisualDensity.compact,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
