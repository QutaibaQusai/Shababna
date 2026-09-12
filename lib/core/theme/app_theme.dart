import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_dimensions.dart';
import 'app_text_styles.dart';

class AppTheme {
  AppTheme._();

  static ThemeData light({required String fontFamily}) => ThemeData(
    useMaterial3: true,
    fontFamily: fontFamily,
    brightness: Brightness.light,
    colorScheme: _lightColorScheme,
    textTheme: _buildTextTheme(
      primary: AppColors.textPrimaryLight,
      secondary: AppColors.textSecondaryLight,
    ),
    scaffoldBackgroundColor: AppColors.backgroundLight,
    appBarTheme: _buildAppBarTheme(
      backgroundColor: AppColors.surfaceLight,
      foregroundColor: AppColors.textPrimaryLight,
    ),
    elevatedButtonTheme: _buildElevatedButtonTheme(
      background: AppColors.primaryLight,
      foreground: AppColors.surfaceLight,
    ),
    outlinedButtonTheme: _buildOutlinedButtonTheme(
      borderColor: AppColors.primaryLight,
      foreground: AppColors.primaryLight,
    ),
    textButtonTheme: _buildTextButtonTheme(AppColors.infoLight),
    inputDecorationTheme: _buildInputDecorationTheme(
      labelColor: AppColors.textSecondaryLight,
      fillColor: AppColors.surfaceLight,
      errorColor: AppColors.errorLight,
    ),
    cardTheme: _buildCardTheme(color: AppColors.surfaceLight),
    navigationBarTheme: _buildNavigationBarTheme(
      background: AppColors.surfaceLight,
      selected: AppColors.primaryLight,
      unselected: AppColors.neutralLight,
    ),
    switchTheme: _buildSwitchTheme(
      track: AppColors.primaryLight,
      unselectedTrack: AppColors.neutralLight,
    ),
    dialogTheme: _buildDialogTheme(
      backgroundColor: AppColors.surfaceLight,
      titleColor: AppColors.textPrimaryLight,
      contentColor: AppColors.textSecondaryLight,
    ),
    dividerTheme: DividerThemeData(
      color: AppColors.borderLight,
      thickness: 1,
      space: 1,
    ),
    progressIndicatorTheme: _buildProgressIndicatorTheme(
      color: AppColors.primaryLight,
      trackColor: AppColors.backgroundLight,
    ),
  );

  static ThemeData dark({required String fontFamily}) => ThemeData(
    useMaterial3: true,
    fontFamily: fontFamily,
    brightness: Brightness.dark,
    colorScheme: _darkColorScheme,
    textTheme: _buildTextTheme(
      primary: AppColors.textPrimaryDark,
      secondary: AppColors.textSecondaryDark,
    ),
    scaffoldBackgroundColor: AppColors.backgroundDark,
    appBarTheme: _buildAppBarTheme(
      backgroundColor: AppColors.backgroundDark,
      foregroundColor: AppColors.textPrimaryDark,
    ),
    elevatedButtonTheme: _buildElevatedButtonTheme(
      background: AppColors.primaryDark,
      foreground: AppColors.textPrimaryDark,
    ),
    outlinedButtonTheme: _buildOutlinedButtonTheme(
      borderColor: AppColors.primaryDark,
      foreground: AppColors.primaryDark,
    ),
    textButtonTheme: _buildTextButtonTheme(AppColors.infoDark),
    inputDecorationTheme: _buildInputDecorationTheme(
      labelColor: AppColors.textSecondaryDark,
      fillColor: AppColors.surfaceDark,
      errorColor: AppColors.errorDark,
    ),
    cardTheme: _buildCardTheme(color: AppColors.surfaceDark),
    navigationBarTheme: _buildNavigationBarTheme(
      background: AppColors.surfaceDark,
      selected: AppColors.primaryDark,
      unselected: AppColors.neutralDark,
    ),
    switchTheme: _buildSwitchTheme(
      track: AppColors.primaryDark,
      unselectedTrack: AppColors.neutralDark,
    ),
    dialogTheme: _buildDialogTheme(
      backgroundColor: AppColors.surfaceDark,
      titleColor: AppColors.textPrimaryDark,
      contentColor: AppColors.textSecondaryDark,
    ),
    dividerTheme: DividerThemeData(
      color: AppColors.borderDark,
      thickness: 1,
      space: 1,
    ),
    progressIndicatorTheme: _buildProgressIndicatorTheme(
      color: AppColors.primaryDark,
      trackColor: AppColors.surfaceDark,
    ),
  );

  static const ColorScheme _lightColorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: AppColors.primaryLight,
    onPrimary: AppColors.surfaceLight,
    secondary: AppColors.infoLight,
    onSecondary: AppColors.surfaceLight,
    surface: AppColors.surfaceLight,
    onSurface: AppColors.textPrimaryLight,
    surfaceContainerHighest: AppColors.backgroundLight,
    onSurfaceVariant: AppColors.textSecondaryLight,
    error: AppColors.errorLight,
    onError: AppColors.surfaceLight,
    outline: AppColors.borderLight,
    outlineVariant: AppColors.backgroundLight,
    shadow: AppColors.textPrimaryLight,
    scrim: AppColors.textPrimaryLight,
    inverseSurface: AppColors.textPrimaryLight,
    onInverseSurface: AppColors.surfaceLight,
    inversePrimary: AppColors.infoLight,
  );

  static const ColorScheme _darkColorScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: AppColors.primaryDark,
    onPrimary: AppColors.textPrimaryDark,
    secondary: AppColors.infoDark,
    onSecondary: AppColors.textPrimaryDark,
    surface: AppColors.surfaceDark,
    onSurface: AppColors.textPrimaryDark,
    surfaceContainerHighest: AppColors.backgroundDark,
    onSurfaceVariant: AppColors.textSecondaryDark,
    error: AppColors.errorDark,
    onError: AppColors.textPrimaryDark,
    outline: AppColors.borderDark,
    outlineVariant: AppColors.backgroundDark,
    shadow: AppColors.textPrimaryLight,
    scrim: AppColors.textPrimaryLight,
    inverseSurface: AppColors.textPrimaryDark,
    onInverseSurface: AppColors.backgroundDark,
    inversePrimary: AppColors.primaryLight,
  );

  static TextTheme _buildTextTheme({
    required Color primary,
    required Color secondary,
  }) => TextTheme(
    displayLarge: AppTextStyles.largeTitle(color: primary),
    displayMedium: AppTextStyles.title1(color: primary),
    displaySmall: AppTextStyles.title2(color: primary),
    headlineLarge: AppTextStyles.title3(color: primary),
    headlineMedium: AppTextStyles.headline(color: primary),
    headlineSmall: AppTextStyles.headline(color: primary),
    titleLarge: AppTextStyles.headline(color: primary),
    titleMedium: AppTextStyles.callout(color: primary),
    titleSmall: AppTextStyles.subheadline(color: primary),
    bodyLarge: AppTextStyles.body(color: primary),
    bodyMedium: AppTextStyles.callout(color: primary),
    bodySmall: AppTextStyles.footnote(color: secondary),
    labelLarge: AppTextStyles.headline(color: primary),
    labelMedium: AppTextStyles.caption1(color: secondary),
    labelSmall: AppTextStyles.caption2(color: secondary),
  );

  static AppBarTheme _buildAppBarTheme({
    required Color backgroundColor,
    required Color foregroundColor,
  }) => AppBarTheme(
    backgroundColor: backgroundColor,
    foregroundColor: foregroundColor,
    elevation: AppDimensions.elevationNone,
    scrolledUnderElevation: 0,
    centerTitle: true,
    titleTextStyle: AppTextStyles.headline(color: foregroundColor),
  );

  static ElevatedButtonThemeData _buildElevatedButtonTheme({
    required Color background,
    required Color foreground,
  }) => ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: background,
      foregroundColor: foreground,
      disabledBackgroundColor: background.withValues(alpha: 0.4),
      minimumSize: Size(double.infinity, AppDimensions.buttonHeight),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
      ),
      elevation: AppDimensions.elevationNone,
      textStyle: AppTextStyles.headline(),
    ),
  );

  static OutlinedButtonThemeData _buildOutlinedButtonTheme({
    required Color borderColor,
    required Color foreground,
  }) => OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: foreground,
      minimumSize: Size(double.infinity, AppDimensions.buttonHeight),
      side: BorderSide(color: borderColor, width: 1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
      ),
      textStyle: AppTextStyles.headline(),
    ),
  );

  static TextButtonThemeData _buildTextButtonTheme(Color color) =>
      TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: color,
          textStyle: AppTextStyles.subheadline(),
        ),
      );

  static InputDecorationTheme _buildInputDecorationTheme({
    required Color labelColor,
    required Color fillColor,
    required Color errorColor,
  }) {
    final radius = BorderRadius.circular(AppDimensions.radiusMd);
    return InputDecorationTheme(
      filled: true,
      fillColor: fillColor,
      contentPadding: EdgeInsets.symmetric(
        horizontal: AppDimensions.spacingSm,
        vertical: AppDimensions.spacingXs,
      ),
      border: OutlineInputBorder(borderRadius: radius, borderSide: BorderSide.none),
      enabledBorder: OutlineInputBorder(borderRadius: radius, borderSide: BorderSide.none),
      focusedBorder: OutlineInputBorder(borderRadius: radius, borderSide: BorderSide.none),
      errorBorder: OutlineInputBorder(
        borderRadius: radius,
        borderSide: BorderSide(color: errorColor),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: radius,
        borderSide: BorderSide(color: errorColor, width: 1.5),
      ),
      disabledBorder: OutlineInputBorder(borderRadius: radius, borderSide: BorderSide.none),
      labelStyle: AppTextStyles.body(color: labelColor),
      hintStyle: AppTextStyles.body(color: labelColor),
      errorStyle: AppTextStyles.footnote(color: errorColor),
    );
  }

  static CardThemeData _buildCardTheme({required Color color}) => CardThemeData(
    color: color,
    elevation: AppDimensions.elevationNone,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
    ),
    margin: EdgeInsets.zero,
  );

  static NavigationBarThemeData _buildNavigationBarTheme({
    required Color background,
    required Color selected,
    required Color unselected,
  }) => NavigationBarThemeData(
    backgroundColor: background,
    height: AppDimensions.bottomNavHeight,
    iconTheme: WidgetStateProperty.resolveWith((states) {
      final isSelected = states.contains(WidgetState.selected);
      return IconThemeData(color: isSelected ? selected : unselected);
    }),
    labelTextStyle: WidgetStateProperty.resolveWith((states) {
      final isSelected = states.contains(WidgetState.selected);
      return AppTextStyles.caption2(color: isSelected ? selected : unselected);
    }),
    elevation: AppDimensions.elevationSm,
  );

  static SwitchThemeData _buildSwitchTheme({
    required Color track,
    required Color unselectedTrack,
  }) => SwitchThemeData(
    trackColor: WidgetStateProperty.resolveWith((states) {
      return states.contains(WidgetState.selected) ? track : unselectedTrack;
    }),
  );

  static DialogThemeData _buildDialogTheme({
    required Color backgroundColor,
    required Color titleColor,
    required Color contentColor,
  }) => DialogThemeData(
    backgroundColor: backgroundColor,
    elevation: AppDimensions.elevationMd,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
    ),
    titleTextStyle: AppTextStyles.headline(color: titleColor),
    contentTextStyle: AppTextStyles.subheadline(color: contentColor),
  );

  static ProgressIndicatorThemeData _buildProgressIndicatorTheme({
    required Color color,
    required Color trackColor,
  }) => ProgressIndicatorThemeData(color: color, circularTrackColor: trackColor);
}
