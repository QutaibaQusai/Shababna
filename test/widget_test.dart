import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:shababna/app.dart';
import 'package:shababna/core/di/service_locator.dart';
import 'package:shababna/features/auth/presentation/pages/login/login_page.dart';

void main() {
  const secureStorageChannel = MethodChannel(
    'plugins.it_nomads.com/flutter_secure_storage',
  );

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(secureStorageChannel, (call) async {
      switch (call.method) {
        case 'readAll':
          return <String, String>{};
        default:
          return null;
      }
    });

    await setupServiceLocator();
  });

  tearDown(() async {
    await sl.reset();
  });

  testWidgets('App builds without error', (WidgetTester tester) async {
    await tester.pumpWidget(const ShababnaApp());
    await tester.pumpAndSettle();

    expect(find.byType(LoginPage), findsOneWidget);
  });
}
