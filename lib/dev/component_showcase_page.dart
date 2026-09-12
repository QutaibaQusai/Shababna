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
import '../core/theme/app_colors.dart';
import '../core/theme/app_radius.dart';
import '../core/theme/app_spacing.dart';
import '../core/utils/spacing.dart';

const _lorem =
    'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do '
    'eiusmod tempor incididunt ut labore et dolore magna aliqua.';

const _loremAr =
    'هذا نص تجريبي يستخدم لأغراض العرض والتصميم فقط، ويساعد على معاينة '
    'شكل الخط العربي وحجمه داخل التطبيق قبل إضافة المحتوى الحقيقي.';

class ComponentShowcasePage extends StatefulWidget {
  const ComponentShowcasePage({super.key});

  @override
  State<ComponentShowcasePage> createState() => _ComponentShowcasePageState();
}

class _ComponentShowcasePageState extends State<ComponentShowcasePage> {
  bool _overlayLoading = false;

  final _emailController = TextEditingController(
    text: 'sara.ahmad@example.com',
  );
  final _passwordController = TextEditingController(text: 'p@ssw0rd123');
  final _bioController = TextEditingController(text: _lorem);
  final _errorFieldController = TextEditingController(text: '12345');
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _formKey.currentState?.validate(),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _bioController.dispose();
    _errorFieldController.dispose();
    super.dispose();
  }

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
        body: Form(
          key: _formKey,
          child: ListView(
            padding: EdgeInsets.all(AppSpacing.screenMargin),
            children: [
              _SectionTitle('Colors'),
              Wrap(
                spacing: AppSpacing.xs,
                runSpacing: AppSpacing.xs,
                children: [
                  _ColorSwatch('Primary', AppColors.primaryColor),
                  _ColorSwatch('Success', AppColors.successColor),
                  _ColorSwatch('Error', AppColors.errorColor),
                  _ColorSwatch('Warning', AppColors.warningColor),
                  _ColorSwatch('Info', AppColors.infoColor),
                  _ColorSwatch('Neutral', AppColors.neutralColor),
                  _ColorSwatch(
                    'Background',
                    context.isDark
                        ? AppColors.backgroundDark
                        : AppColors.backgroundLight,
                  ),
                  _ColorSwatch(
                    'Surface',
                    context.isDark
                        ? AppColors.surfaceDark
                        : AppColors.surfaceLight,
                  ),
                  _ColorSwatch(
                    'Surface highest',
                    context.isDark
                        ? AppColors.surfaceHighestDark
                        : AppColors.surfaceHighestLight,
                  ),
                  _ColorSwatch(
                    'Border',
                    context.isDark
                        ? AppColors.borderDark
                        : AppColors.borderLight,
                  ),
                ],
              ),

              _SectionTitle('Typography'),
              Text('Display large', style: context.textTheme.displayLarge),
              Text('Display medium', style: context.textTheme.displayMedium),
              Text('Display small', style: context.textTheme.displaySmall),
              Text('Headline large', style: context.textTheme.headlineLarge),
              Text('Headline medium', style: context.textTheme.headlineMedium),
              Text('Headline small', style: context.textTheme.headlineSmall),
              Text('Title large', style: context.textTheme.titleLarge),
              Text('Title medium', style: context.textTheme.titleMedium),
              Text('Title small', style: context.textTheme.titleSmall),
              Text(_lorem, style: context.textTheme.bodyLarge),
              Text(_lorem, style: context.textTheme.bodyMedium),
              Text(_lorem, style: context.textTheme.bodySmall),
              Text('Label large', style: context.textTheme.labelLarge),
              Text('Label medium', style: context.textTheme.labelMedium),
              Text('Label small', style: context.textTheme.labelSmall),

              _SectionTitle('Arabic sample'),
              Directionality(
                textDirection: TextDirection.rtl,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text('عنوان كبير', style: context.textTheme.displayMedium),
                    Text(_loremAr, style: context.textTheme.bodyLarge),
                    verticalSpace(AppSpacing.sm),
                    const AppTextField(
                      label: 'الاسم الكامل',
                      hint: 'محمد أحمد',
                    ),
                  ],
                ),
              ),

              _SectionTitle('Buttons'),
              AppButton.primary(label: 'Primary', onPressed: () {}),
              verticalSpace(AppSpacing.sm),
              const AppButton.primary(
                label: 'Primary (disabled)',
                onPressed: null,
              ),
              verticalSpace(AppSpacing.sm),
              AppButton.secondary(label: 'Secondary', onPressed: () {}),
              verticalSpace(AppSpacing.sm),
              AppButton.text(label: 'Text button', onPressed: () {}),

              _SectionTitle('Text fields'),
              AppTextField(
                label: 'Email',
                hint: 'you@example.com',
                controller: _emailController,
                prefixIcon: LucideIcons.mail,
              ),
              verticalSpace(AppSpacing.sm),
              AppTextField(
                label: 'Password',
                obscureText: true,
                controller: _passwordController,
              ),
              verticalSpace(AppSpacing.sm),
              AppTextField(
                label: 'Bio',
                controller: _bioController,
                maxLines: 3,
              ),
              verticalSpace(AppSpacing.sm),
              AppTextField(
                label: 'Phone number',
                controller: _errorFieldController,
                validator: (_) => 'Enter a valid phone number',
                autofocus: false,
              ),
              verticalSpace(AppSpacing.sm),
              const AppTextField(
                label: 'Search',
                hint: 'Search services and institutions',
                prefixIcon: LucideIcons.search,
              ),
              verticalSpace(AppSpacing.sm),
              IgnorePointer(
                child: AppTextField(
                  label: 'Member since (read-only)',
                  controller: TextEditingController(text: 'January 2022'),
                ),
              ),

              _SectionTitle('Card'),
              Card(
                child: Padding(
                  padding: EdgeInsets.all(AppSpacing.sm),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: AppColors.infoColor.withValues(alpha: 0.12),
                          borderRadius: AppRadius.smRadius,
                        ),
                        child: Icon(
                          LucideIcons.fileText,
                          color: AppColors.infoColor,
                        ),
                      ),
                      horizontalSpace(AppSpacing.sm),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Application #48213',
                              style: context.textTheme.titleSmall,
                            ),
                            Text(
                              'Submitted 3 days ago',
                              style: context.textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                      const Icon(LucideIcons.chevronRight, size: 20),
                    ],
                  ),
                ),
              ),

              _SectionTitle('Loader'),
              const SizedBox(height: 60, child: AppLoader()),

              _SectionTitle('States'),
              AppErrorWidget(message: 'Something went wrong', onRetry: () {}),
              verticalSpace(AppSpacing.md),
              const AppEmptyWidget(message: 'No results for Lorem ipsum'),

              _SectionTitle('Network image'),
              Row(
                children: [
                  const SizedBox(
                    width: 64,
                    height: 64,
                    child: AppNetworkImage(size: 64),
                  ),
                  horizontalSpace(AppSpacing.sm),
                  const SizedBox(
                    width: 64,
                    height: 64,
                    child: AppNetworkImage(
                      url: 'https://broken.example/not-found.png',
                      size: 64,
                    ),
                  ),
                  horizontalSpace(AppSpacing.sm),
                  const SizedBox(
                    width: 64,
                    height: 64,
                    child: AppNetworkImage(
                      url: 'https://picsum.photos/seed/shababna/200',
                      size: 64,
                    ),
                  ),
                ],
              ),
              verticalSpace(AppSpacing.sm),
              AppButton.secondary(
                label: 'Toggle loading overlay',
                onPressed: () =>
                    setState(() => _overlayLoading = !_overlayLoading),
              ),

              _SectionTitle('Dialog'),
              AppButton.secondary(
                label: 'Show dialog',
                onPressed: () => AppDialog.confirm(
                  context,
                  title: 'Delete item?',
                  message: _lorem,
                  confirmText: 'Delete',
                  cancelText: 'Cancel',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: AppSpacing.md, bottom: AppSpacing.xs),
      child: Text(label, style: context.textTheme.titleLarge),
    );
  }
}

class _ColorSwatch extends StatelessWidget {
  const _ColorSwatch(this.label, this.color);

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: color,
            borderRadius: AppRadius.smRadius,
            border: Border.all(color: context.colorScheme.outline),
          ),
        ),
        verticalSpace(AppSpacing.xs / 2),
        SizedBox(
          width: 64,
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: context.textTheme.labelMedium,
          ),
        ),
      ],
    );
  }
}
