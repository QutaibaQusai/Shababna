import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../core/di/service_locator.dart';
import '../core/extensions/context_extensions.dart';
import '../core/services/locale_service.dart';
import '../core/services/theme_service.dart';
import '../core/shared/widgets/app_button.dart';
import '../core/shared/widgets/app_dialog.dart';
import '../core/shared/widgets/app_empty_widget.dart';
import '../core/shared/widgets/app_error_widget.dart';
import '../core/shared/widgets/app_loader.dart';
import '../core/shared/widgets/app_loading_overlay.dart';
import '../core/shared/widgets/app_network_image.dart';
import '../core/shared/widgets/app_text_field.dart';
import '../core/theme/app_dimensions.dart';
import '../core/utils/spacing.dart';

class ComponentShowcasePage extends StatefulWidget {
  const ComponentShowcasePage({super.key});

  @override
  State<ComponentShowcasePage> createState() => _ComponentShowcasePageState();
}

class _ComponentShowcasePageState extends State<ComponentShowcasePage> {
  bool _overlayLoading = false;

  @override
  Widget build(BuildContext context) {
    return AppLoadingOverlay(
      isLoading: _overlayLoading,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Component Showcase'),
          actions: [
            IconButton(
              icon: const Icon(LucideIcons.languages),
              onPressed: () => sl<LocaleService>().toggleLocale(context.locale),
            ),
            IconButton(
              icon: Icon(context.isDark ? LucideIcons.sun : LucideIcons.moon),
              onPressed: () => sl<ThemeService>().toggleThemeMode(
                context.isDark ? Brightness.dark : Brightness.light,
              ),
            ),
          ],
        ),
        body: ListView(
          padding: EdgeInsets.all(AppDimensions.screenMargin),
          children: [
            AppButton.primary(label: 'Primary', onPressed: () {}),
            verticalSpace(AppDimensions.spacingSm),
            AppButton.secondary(label: 'Secondary', onPressed: () {}),
            verticalSpace(AppDimensions.spacingSm),
            AppButton.text(label: 'Text', onPressed: () {}),
            verticalSpace(AppDimensions.spacingMd),
            const AppTextField(label: 'Email', hint: 'you@example.com'),
            verticalSpace(AppDimensions.spacingSm),
            const AppTextField(label: 'Password', obscureText: true),
            verticalSpace(AppDimensions.spacingMd),
            const SizedBox(height: 60, child: AppLoader()),
            verticalSpace(AppDimensions.spacingMd),
            AppErrorWidget(message: 'Something went wrong', onRetry: () {}),
            verticalSpace(AppDimensions.spacingMd),
            const AppEmptyWidget(),
            verticalSpace(AppDimensions.spacingMd),
            Row(
              children: [
                const SizedBox(width: 64, height: 64, child: AppNetworkImage(size: 64)),
                horizontalSpace(AppDimensions.spacingSm),
                Expanded(
                  child: AppButton.secondary(
                    label: 'Toggle loading overlay',
                    onPressed: () => setState(() => _overlayLoading = !_overlayLoading),
                  ),
                ),
              ],
            ),
            verticalSpace(AppDimensions.spacingMd),
            AppButton.secondary(
              label: 'Show dialog',
              onPressed: () => AppDialog.confirm(
                context,
                title: 'Confirm',
                message: 'Are you sure?',
                confirmText: 'Yes',
                cancelText: 'No',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
