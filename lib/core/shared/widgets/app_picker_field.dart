import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../extensions/context_extensions.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_sizes.dart';
import '../../theme/app_spacing.dart';
import 'app_brand_loader.dart';
import 'app_empty_widget.dart';
import 'app_error_widget.dart';
import 'app_loader.dart';
import 'app_search_field.dart';
import 'app_text_field.dart';
import 'app_bottom_safe_area.dart';

class AppPickerField<T> extends StatefulWidget {
  const AppPickerField({
    super.key,
    required this.label,
    required this.items,
    required this.itemLabel,
    required this.onSelected,
    this.selectedItem,
    this.selectedLabel,
    this.searchHint,
    this.prefixIcon,
    this.isLoading = false,
    this.errorMessage,
    this.onRetry,
    this.validator,
  });

  final String label;
  final List<T> items;
  final String Function(T item) itemLabel;
  final ValueChanged<T> onSelected;
  final T? selectedItem;
  final String Function(T item)? selectedLabel;
  final String? searchHint;
  final IconData? prefixIcon;
  final bool isLoading;
  final String? errorMessage;
  final VoidCallback? onRetry;
  final FormFieldValidator<String>? validator;

  @override
  State<AppPickerField<T>> createState() => _AppPickerFieldState<T>();
}

class _AppPickerFieldState<T> extends State<AppPickerField<T>> {
  late final _controller = TextEditingController(text: _displayText);

  String get _displayText {
    final selected = widget.selectedItem;
    if (selected == null) return '';
    return (widget.selectedLabel ?? widget.itemLabel)(selected);
  }

  @override
  void didUpdateWidget(AppPickerField<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedItem != widget.selectedItem) {
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
    if (!widget.isLoading) {
      return AppTextField(
        label: widget.label,
        controller: _controller,
        readOnly: true,
        prefixIcon: widget.prefixIcon,
        suffix: Icon(LucideIcons.chevronDown, size: AppSizes.iconField),
        validator: widget.validator,
        onTap: () => _openSheet(context),
      );
    }

    final loadingField = Stack(
      children: [
        AppTextField(
          label: '',
          controller: _controller,
          readOnly: true,
          prefixIcon: widget.prefixIcon,
          suffix: const SizedBox.shrink(),
          validator: widget.validator,
        ),
        Positioned.fill(
          child: IgnorePointer(
            child: Center(child: AppBrandLoader(size: AppSizes.fieldLoaderSize, strokeWidth: 2)),
          ),
        ),
      ],
    );

    if (widget.label.isEmpty) return loadingField;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        AppFieldLabel(label: widget.label),
        SizedBox(height: AppSpacing.xs),
        loadingField,
      ],
    );
  }

  void _openSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (sheetContext) => _PickerSheet<T>(
        items: widget.items,
        itemLabel: widget.itemLabel,
        selectedItem: widget.selectedItem,
        searchHint: widget.searchHint,
        isLoading: widget.isLoading,
        errorMessage: widget.errorMessage,
        onRetry: widget.onRetry,
        onSelected: (item) {
          Navigator.of(sheetContext).pop();
          widget.onSelected(item);
        },
      ),
    );
  }
}

class _PickerSheet<T> extends StatefulWidget {
  const _PickerSheet({
    required this.items,
    required this.itemLabel,
    required this.onSelected,
    this.selectedItem,
    this.searchHint,
    this.isLoading = false,
    this.errorMessage,
    this.onRetry,
  });

  final List<T> items;
  final String Function(T item) itemLabel;
  final ValueChanged<T> onSelected;
  final T? selectedItem;
  final String? searchHint;
  final bool isLoading;
  final String? errorMessage;
  final VoidCallback? onRetry;

  @override
  State<_PickerSheet<T>> createState() => _PickerSheetState<T>();
}

class _PickerSheetState<T> extends State<_PickerSheet<T>> {
  late List<T> _filteredItems = widget.items;

  @override
  void didUpdateWidget(_PickerSheet<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.items != widget.items) {
      _filteredItems = widget.items;
    }
  }

  void _onSearchChanged(String query) {
    setState(() {
      _filteredItems = widget.items
          .where((item) => widget.itemLabel(item).toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppBottomSafeArea(
      top: true,
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
        final isSelected = item == widget.selectedItem;
        return Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: AppRadius.mdRadius,
            onTap: () => widget.onSelected(item),
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
                  if (isSelected)
                    Icon(
                      Icons.check_circle,
                      size: AppSizes.iconField,
                      color: context.colorScheme.primary,
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
