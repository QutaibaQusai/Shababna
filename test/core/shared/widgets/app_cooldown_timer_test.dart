import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shababna/core/shared/widgets/app_cooldown_timer.dart';
import 'package:shababna/core/theme/app_sizes.dart';

Widget _host({required VoidCallback onPressed, int cooldownSeconds = 3}) {
  return ScreenUtilPlusInit(
    designSize: AppSizes.designSize,
    builder: (_, _) => MaterialApp(
      home: Scaffold(
        body: Center(
          child: AppCooldownTimer(
            label: 'Resend',
            onPressed: onPressed,
            cooldownSeconds: cooldownSeconds,
          ),
        ),
      ),
    ),
  );
}

void main() {
  testWidgets('starts cooling down with the seconds left and no resend button', (tester) async {
    await tester.pumpWidget(_host(onPressed: () {}));

    expect(find.text('3'), findsOneWidget);
    expect(find.text('Resend'), findsNothing);
  });

  testWidgets('counts down each second', (tester) async {
    await tester.pumpWidget(_host(onPressed: () {}));

    await tester.pump(const Duration(seconds: 1));

    expect(find.text('2'), findsOneWidget);
  });

  testWidgets('shows the resend button once the cooldown ends', (tester) async {
    await tester.pumpWidget(_host(onPressed: () {}));

    await tester.pump(const Duration(seconds: 3));
    await tester.pumpAndSettle();

    expect(find.text('Resend'), findsOneWidget);
  });

  testWidgets('pressing resend fires the callback and restarts the cooldown', (tester) async {
    var presses = 0;
    await tester.pumpWidget(_host(onPressed: () => presses++));

    await tester.pump(const Duration(seconds: 3));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Resend'));
    await tester.pumpAndSettle(const Duration(milliseconds: 100));

    expect(presses, 1);
    expect(find.text('3'), findsOneWidget);
    expect(find.text('Resend'), findsNothing);
  });

  testWidgets('cancels its timer when removed from the tree', (tester) async {
    await tester.pumpWidget(_host(onPressed: () {}));
    await tester.pumpWidget(const SizedBox());

    await tester.pump(const Duration(seconds: 5));

    expect(tester.takeException(), isNull);
  });
}
