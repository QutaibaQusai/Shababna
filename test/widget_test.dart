import 'package:flutter_test/flutter_test.dart';

import 'package:shababna/app.dart';

void main() {
  testWidgets('App builds without error', (WidgetTester tester) async {
    await tester.pumpWidget(const ShababnaApp());

    expect(find.text('Shababna'), findsOneWidget);
  });
}
