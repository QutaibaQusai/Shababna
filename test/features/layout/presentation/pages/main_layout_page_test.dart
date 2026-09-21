import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:shababna/core/theme/app_sizes.dart';
import 'package:shababna/features/events/presentation/pages/events_page.dart';
import 'package:shababna/features/layout/presentation/pages/main_layout_page.dart';
import 'package:shababna/features/layout/presentation/widgets/layout_app_bar.dart';
import 'package:shababna/features/layout/presentation/widgets/layout_nav_bar.dart';
import 'package:shababna/l10n/app_localizations.dart';

Widget _host({Locale locale = const Locale('en')}) {
  return ScreenUtilPlusInit(
    designSize: AppSizes.designSize,
    builder: (_, _) => MaterialApp(
      locale: locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: const MainLayoutPage(),
    ),
  );
}

Finder _inAppBar(String text) =>
    find.descendant(of: find.byType(LayoutAppBar), matching: find.text(text));

Finder _inNavBar(String text) =>
    find.descendant(of: find.byType(LayoutNavBar), matching: find.text(text));

int _selectedIndex(WidgetTester tester) =>
    tester.widget<NavigationBar>(find.byType(NavigationBar)).selectedIndex;

void main() {
  testWidgets('starts on Home with the Home title', (tester) async {
    await tester.pumpWidget(_host());

    expect(_inAppBar('Home'), findsOneWidget);
    expect(_selectedIndex(tester), 0);
  });

  testWidgets('shows a standard navigation bar with all four tabs', (
    tester,
  ) async {
    await tester.pumpWidget(_host());

    expect(find.byType(NavigationBar), findsOneWidget);
    expect(find.byType(NavigationDestination), findsNWidgets(4));
  });

  testWidgets('every tab has a distinct filled icon for its selected state', (
    tester,
  ) async {
    await tester.pumpWidget(_host());

    final destinations = tester.widgetList<NavigationDestination>(
      find.byType(NavigationDestination),
    );

    for (final destination in destinations) {
      final icon = (destination.icon as Icon).icon;
      final selectedIcon = (destination.selectedIcon! as Icon).icon;
      expect(selectedIcon, isNot(icon));
    }
  });

  testWidgets('tapping a tab changes the title and selection', (tester) async {
    await tester.pumpWidget(_host());

    await tester.tap(_inNavBar('Events'));
    await tester.pumpAndSettle();

    expect(_inAppBar('Events'), findsOneWidget);
    expect(_selectedIndex(tester), 2);
  });

  testWidgets('the profile tab is selectable', (tester) async {
    await tester.pumpWidget(_host());

    await tester.tap(_inNavBar('Profile'));
    await tester.pumpAndSettle();

    expect(_inAppBar('Profile'), findsOneWidget);
    expect(_selectedIndex(tester), 3);
  });

  testWidgets('a tab is built lazily and kept alive after leaving it', (
    tester,
  ) async {
    await tester.pumpWidget(_host());

    expect(find.byType(EventsPage, skipOffstage: false), findsNothing);

    await tester.tap(_inNavBar('Events'));
    await tester.pumpAndSettle();
    await tester.tap(_inNavBar('Home'));
    await tester.pumpAndSettle();

    expect(find.byType(EventsPage, skipOffstage: false), findsOneWidget);
  });

  testWidgets('system back on another tab returns to Home', (tester) async {
    await tester.pumpWidget(_host());

    await tester.tap(_inNavBar('News'));
    await tester.pumpAndSettle();
    expect(_inAppBar('News'), findsOneWidget);

    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();

    expect(_inAppBar('Home'), findsOneWidget);
  });

  testWidgets('the app bar shows search and notifications on content tabs', (
    tester,
  ) async {
    await tester.pumpWidget(_host());

    expect(find.byIcon(LucideIcons.search), findsOneWidget);
    expect(find.byIcon(LucideIcons.bell), findsOneWidget);
  });

  testWidgets('the profile tab hides search but keeps notifications', (
    tester,
  ) async {
    await tester.pumpWidget(_host());

    await tester.tap(_inNavBar('Profile'));
    await tester.pumpAndSettle();

    expect(find.byIcon(LucideIcons.search), findsNothing);
    expect(find.byIcon(LucideIcons.bell), findsOneWidget);
  });

  testWidgets('the app bar buttons tell the user the feature is coming', (
    tester,
  ) async {
    await tester.pumpWidget(_host());

    await tester.tap(find.byIcon(LucideIcons.bell));
    await tester.pump();

    expect(find.text('Coming soon'), findsOneWidget);

    await tester.pumpAndSettle(const Duration(seconds: 5));
  });

  testWidgets('shows Arabic labels', (tester) async {
    await tester.pumpWidget(_host(locale: const Locale('ar')));

    expect(_inAppBar('الرئيسية'), findsOneWidget);
    expect(_inNavBar('الفعاليات'), findsOneWidget);
  });
}
