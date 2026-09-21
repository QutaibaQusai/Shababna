import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shababna/core/theme/app_colors.dart';
import 'package:shababna/core/theme/app_sizes.dart';
import 'package:shababna/core/theme/app_theme.dart';
import 'package:shababna/features/layout/presentation/pages/main_layout_page.dart';
import 'package:shababna/l10n/app_localizations.dart';

Widget _host() {
  return ScreenUtilPlusInit(
    designSize: AppSizes.designSize,
    builder: (_, _) => MaterialApp(
      theme: AppTheme.light(fontFamily: 'Roboto'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: const MainLayoutPage(),
    ),
  );
}

Finder _inNavBar(Finder matching) =>
    find.descendant(of: find.byType(NavigationBar), matching: matching);

Color? _labelColor(WidgetTester tester, String label) =>
    tester.widget<Text>(_inNavBar(find.text(label))).style?.color;

Color? _iconColor(WidgetTester tester, IconData icon) =>
    IconTheme.of(tester.element(_inNavBar(find.byIcon(icon)).first)).color;

void main() {
  testWidgets('only the icon color changes for the selected tab', (
    tester,
  ) async {
    await tester.pumpWidget(_host());
    await tester.pumpAndSettle();

    expect(_iconColor(tester, Icons.home), AppColors.infoColor);
    expect(
      _iconColor(tester, Icons.newspaper_outlined),
      AppColors.neutralColor,
    );
  });

  testWidgets('the label color is the same for selected and unselected tabs', (
    tester,
  ) async {
    await tester.pumpWidget(_host());
    await tester.pumpAndSettle();

    expect(_labelColor(tester, 'Home'), AppColors.neutralColor);
    expect(_labelColor(tester, 'News'), AppColors.neutralColor);

    await tester.tap(_inNavBar(find.text('Events')));
    await tester.pumpAndSettle();

    expect(_labelColor(tester, 'Events'), AppColors.neutralColor);
    expect(_labelColor(tester, 'Home'), AppColors.neutralColor);
  });

  testWidgets('the icon color follows the selection', (tester) async {
    await tester.pumpWidget(_host());

    await tester.tap(_inNavBar(find.text('Events')));
    await tester.pumpAndSettle();

    expect(_iconColor(tester, Icons.event), AppColors.infoColor);
    expect(_iconColor(tester, Icons.home_outlined), AppColors.neutralColor);
  });

  testWidgets('the selected tab has no indicator container', (tester) async {
    await tester.pumpWidget(_host());

    final theme = Theme.of(tester.element(find.byType(NavigationBar)));

    expect(theme.navigationBarTheme.indicatorColor, Colors.transparent);
  });
}
