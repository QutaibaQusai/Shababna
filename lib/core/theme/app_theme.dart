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
      primary: AppColors.labelLight,
      secondary: AppColors.secondaryLabelLight,
    ),
    scaffoldBackgroundColor: AppColors.secondarySystemBackgroundLight,
    appBarTheme: _buildAppBarTheme(
      backgroundColor: AppColors.systemBackgroundLight,
      foregroundColor: AppColors.labelLight,
    ),
    elevatedButtonTheme: _buildElevatedButtonTheme(
      background: AppColors.brandNavy,
      foreground: AppColors.systemBackgroundLight,
    ),
    outlinedButtonTheme: _buildOutlinedButtonTheme(
      borderColor: AppColors.brandNavy,
      foreground: AppColors.brandNavy,
    ),
    textButtonTheme: _buildTextButtonTheme(AppColors.systemBlueLight),
    inputDecorationTheme: _buildInputDecorationTheme(
      labelColor: AppColors.secondaryLabelLight,
      fillColor: AppColors.systemBackgroundLight,
      errorColor: AppColors.systemRedLight,
    ),
    cardTheme: _buildCardTheme(color: AppColors.systemBackgroundLight),
    navigationBarTheme: _buildNavigationBarTheme(
      background: AppColors.systemBackgroundLight,
      selected: AppColors.brandNavy,
      unselected: AppColors.systemGrayLight,
    ),
    switchTheme: _buildSwitchTheme(
      track: AppColors.brandNavy,
      unselectedTrack: AppColors.systemGrayLight,
    ),
    dialogTheme: _buildDialogTheme(
      backgroundColor: AppColors.systemBackgroundLight,
      titleColor: AppColors.labelLight,
      contentColor: AppColors.secondaryLabelLight,
    ),
    dividerTheme: DividerThemeData(
      color: AppColors.separatorLight,
      thickness: 1,
      space: 1,
    ),
    progressIndicatorTheme: _buildProgressIndicatorTheme(
      color: AppColors.brandNavy,
      trackColor: AppColors.secondarySystemBackgroundLight,
    ),
  );

  static ThemeData dark({required String fontFamily}) => ThemeData(
    useMaterial3: true,
    fontFamily: fontFamily,
    brightness: Brightness.dark,
    colorScheme: _darkColorScheme,
    textTheme: _buildTextTheme(
      primary: AppColors.labelDark,
      secondary: AppColors.secondaryLabelDark,
    ),
    scaffoldBackgroundColor: AppColors.systemBackgroundDark,
    appBarTheme: _buildAppBarTheme(
      backgroundColor: AppColors.systemBackgroundDark,
      foregroundColor: AppColors.labelDark,
    ),
    elevatedButtonTheme: _buildElevatedButtonTheme(
      background: AppColors.systemBlueDark,
      foreground: AppColors.labelDark,
    ),
    outlinedButtonTheme: _buildOutlinedButtonTheme(
      borderColor: AppColors.systemBlueDark,
      foreground: AppColors.systemBlueDark,
    ),
    textButtonTheme: _buildTextButtonTheme(AppColors.systemBlueDark),
    inputDecorationTheme: _buildInputDecorationTheme(
      labelColor: AppColors.secondaryLabelDark,
      fillColor: AppColors.secondarySystemBackgroundDark,
      errorColor: AppColors.systemRedDark,
    ),
    cardTheme: _buildCardTheme(
      color: AppColors.secondarySystemBackgroundDark,
    ),
    navigationBarTheme: _buildNavigationBarTheme(
      background: AppColors.secondarySystemBackgroundDark,
      selected: AppColors.systemBlueDark,
      unselected: AppColors.systemGrayDark,
    ),
    switchTheme: _buildSwitchTheme(
      track: AppColors.systemBlueDark,
      unselectedTrack: AppColors.systemGrayDark,
    ),
    dialogTheme: _buildDialogTheme(
      backgroundColor: AppColors.secondarySystemBackgroundDark,
      titleColor: AppColors.labelDark,
      contentColor: AppColors.secondaryLabelDark,
    ),
    dividerTheme: DividerThemeData(
      color: AppColors.separatorDark,
      thickness: 1,
      space: 1,
    ),
    progressIndicatorTheme: _buildProgressIndicatorTheme(
      color: AppColors.systemBlueDark,
      trackColor: AppColors.secondarySystemBackgroundDark,
    ),
  );

  static const ColorScheme _lightColorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: AppColors.brandNavy,
    onPrimary: AppColors.systemBackgroundLight,
    secondary: AppColors.systemBlueLight,
    onSecondary: AppColors.systemBackgroundLight,
    surface: AppColors.systemBackgroundLight,
    onSurface: AppColors.labelLight,
    surfaceContainerHighest: AppColors.secondarySystemBackgroundLight,
    onSurfaceVariant: AppColors.secondaryLabelLight,
    error: AppColors.systemRedLight,
    onError: AppColors.systemBackgroundLight,
    outline: AppColors.separatorLight,
    outlineVariant: AppColors.secondarySystemBackgroundLight,
    shadow: AppColors.labelLight,
    scrim: AppColors.labelLight,
    inverseSurface: AppColors.labelLight,
    onInverseSurface: AppColors.systemBackgroundLight,
    inversePrimary: AppColors.systemBlueLight,
  );

  static const ColorScheme _darkColorScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: AppColors.systemBlueDark,
    onPrimary: AppColors.labelDark,
    secondary: AppColors.systemBlueDark,
    onSecondary: AppColors.labelDark,
    surface: AppColors.systemBackgroundDark,
    onSurface: AppColors.labelDark,
    surfaceContainerHighest: AppColors.secondarySystemBackgroundDark,
    onSurfaceVariant: AppColors.secondaryLabelDark,
    error: AppColors.systemRedDark,
    onError: AppColors.labelDark,
    outline: AppColors.separatorDark,
    outlineVariant: AppColors.secondarySystemBackgroundDark,
    shadow: AppColors.labelLight,
    scrim: AppColors.labelLight,
    inverseSurface: AppColors.labelDark,
    onInverseSurface: AppColors.systemBackgroundDark,
    inversePrimary: AppColors.brandNavy,
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
