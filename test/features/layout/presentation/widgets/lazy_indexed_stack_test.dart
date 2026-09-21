import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shababna/features/layout/presentation/widgets/lazy_indexed_stack.dart';

class _Probe extends StatelessWidget {
  const _Probe(this.onBuild);

  final VoidCallback onBuild;

  @override
  Widget build(BuildContext context) {
    onBuild();
    return const SizedBox();
  }
}

void main() {
  testWidgets('builds a child only once its tab is first selected', (
    tester,
  ) async {
    final index = ValueNotifier(0);
    final builds = [0, 0, 0];

    await tester.pumpWidget(
      MaterialApp(
        home: ValueListenableBuilder<int>(
          valueListenable: index,
          builder: (_, value, _) => LazyIndexedStack(
            index: value,
            children: [
              for (var i = 0; i < builds.length; i++) _Probe(() => builds[i]++),
            ],
          ),
        ),
      ),
    );

    expect(builds[0], greaterThan(0));
    expect(builds[1], 0);
    expect(builds[2], 0);

    index.value = 2;
    await tester.pump();

    expect(builds[2], greaterThan(0));
    expect(builds[1], 0);
  });

  testWidgets('keeps a visited child alive when another tab is selected', (
    tester,
  ) async {
    final index = ValueNotifier(0);

    await tester.pumpWidget(
      MaterialApp(
        home: ValueListenableBuilder<int>(
          valueListenable: index,
          builder: (_, value, _) => LazyIndexedStack(
            index: value,
            children: const [Text('first'), Text('second')],
          ),
        ),
      ),
    );

    index.value = 1;
    await tester.pump();
    index.value = 0;
    await tester.pump();

    expect(find.text('second', skipOffstage: false), findsOneWidget);
  });
}
