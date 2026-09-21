import 'package:flutter/cupertino.dart';
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

    await tester.tap(_inNavBar(find.text('News')));
    await tester.pumpAndSettle();

    expect(_iconColor(tester, CupertinoIcons.news_solid), AppColors.infoColor);
    expect(
      _iconColor(tester, CupertinoIcons.house),
      AppColors.textPrimaryLight,
    );
  });

  testWidgets('the label color is the same for selected and unselected tabs', (
    tester,
  ) async {
    await tester.pumpWidget(_host());
    await tester.pumpAndSettle();

    expect(_labelColor(tester, 'Home'), AppColors.textPrimaryLight);
    expect(_labelColor(tester, 'News'), AppColors.textPrimaryLight);

    await tester.tap(_inNavBar(find.text('Events')));
    await tester.pumpAndSettle();

    expect(_labelColor(tester, 'Events'), AppColors.textPrimaryLight);
    expect(_labelColor(tester, 'Home'), AppColors.textPrimaryLight);
  });

  testWidgets('the icon color follows the selection', (tester) async {
    await tester.pumpWidget(_host());

    await tester.tap(_inNavBar(find.text('Events')));
    await tester.pumpAndSettle();

    expect(
      _iconColor(tester, CupertinoIcons.calendar_today),
      AppColors.infoColor,
    );
    expect(
      _iconColor(tester, CupertinoIcons.house),
      AppColors.textPrimaryLight,
    );
  });

  testWidgets('the selected tab has no indicator container', (tester) async {
    await tester.pumpWidget(_host());

    final theme = Theme.of(tester.element(find.byType(NavigationBar)));

    expect(theme.navigationBarTheme.indicatorColor, Colors.transparent);
  });

  testWidgets('unselected items use the app text color, not gray', (
    tester,
  ) async {
    await tester.pumpWidget(_host());
    await tester.pumpAndSettle();

    expect(
      _iconColor(tester, CupertinoIcons.calendar),
      AppColors.textPrimaryLight,
    );
    expect(_labelColor(tester, 'Events'), AppColors.textPrimaryLight);
    expect(AppColors.textPrimaryLight, isNot(AppColors.neutralColor));
  });

  testWidgets('every tab except Home uses a distinct filled Cupertino icon', (
    tester,
  ) async {
    await tester.pumpWidget(_host());

    final iconDestinations = tester
        .widgetList<NavigationDestination>(find.byType(NavigationDestination))
        .where((destination) => destination.selectedIcon is Icon)
        .toList();

    expect(iconDestinations, hasLength(3));

    for (final destination in iconDestinations) {
      final icon = (destination.icon as Icon).icon;
      final selectedIcon = (destination.selectedIcon! as Icon).icon;
      expect(selectedIcon, isNot(icon));
      expect(selectedIcon?.fontFamily, 'CupertinoIcons');
    }
  });

  testWidgets('the selected Home tab shows the app logo in a circle', (
    tester,
  ) async {
    await tester.pumpWidget(_host());
    await tester.pumpAndSettle();

    expect(_inNavBar(find.byType(ClipOval)), findsOneWidget);
    expect(_inNavBar(find.byType(Image)), findsOneWidget);
    expect(_inNavBar(find.byIcon(CupertinoIcons.house)), findsNothing);
  });

  testWidgets('leaving Home swaps the logo back to the house icon', (
    tester,
  ) async {
    await tester.pumpWidget(_host());

    await tester.tap(_inNavBar(find.text('Events')));
    await tester.pumpAndSettle();

    expect(_inNavBar(find.byType(Image)), findsNothing);
    expect(_inNavBar(find.byIcon(CupertinoIcons.house)), findsOneWidget);
  });
}
