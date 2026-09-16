import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../extensions/context_extensions.dart';
import '../../theme/app_sizes.dart';
import '../../theme/app_spacing.dart';
import 'app_empty_widget.dart';
import 'app_error_widget.dart';
import 'app_loader.dart';
import 'app_text_field.dart';

class AppPickerField<T> extends StatefulWidget {
  const AppPickerField({
    super.key,
    required this.label,
    required this.items,
    required this.itemLabel,
    required this.onSelected,
    this.selectedItem,
    this.selectedLabel,
    this.sheetTitle,
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
  final String? sheetTitle;
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
      _controller.text = _displayText;
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
      validator: widget.validator,
      onTap: () => _openSheet(context),
    );
  }

  void _openSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (sheetContext) => _PickerSheet<T>(
        items: widget.items,
        itemLabel: widget.itemLabel,
        title: widget.sheetTitle,
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
    this.title,
    this.searchHint,
    this.isLoading = false,
    this.errorMessage,
    this.onRetry,
  });

  final List<T> items;
  final String Function(T item) itemLabel;
  final ValueChanged<T> onSelected;
  final String? title;
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
          .where((item) =>
              widget.itemLabel(item).toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        height: MediaQuery.sizeOf(context).height * 0.7,
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.screenMargin),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (widget.title != null) ...[
                Text(widget.title!, style: context.textTheme.titleLarge),
                SizedBox(height: AppSpacing.sm),
              ],
              AppTextField(
                label: widget.searchHint ?? '',
                prefixIcon: LucideIcons.search,
                onChanged: _onSearchChanged,
              ),
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

    return ListView.builder(
      itemCount: _filteredItems.length,
      itemBuilder: (context, index) {
        final item = _filteredItems[index];
        return ListTile(
          title: Text(widget.itemLabel(item)),
          onTap: () => widget.onSelected(item),
        );
      },
    );
  }
}
