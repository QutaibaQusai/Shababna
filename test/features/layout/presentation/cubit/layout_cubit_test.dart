import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shababna/features/layout/presentation/cubit/layout_cubit.dart';
import 'package:shababna/features/layout/presentation/cubit/layout_tab.dart';

void main() {
  test('starts on the home tab', () {
    expect(LayoutCubit().state, LayoutTab.home);
  });

  blocTest<LayoutCubit, LayoutTab>(
    'goTo emits the selected tab',
    build: LayoutCubit.new,
    act: (cubit) => cubit.goTo(LayoutTab.events),
    expect: () => [LayoutTab.events],
  );

  blocTest<LayoutCubit, LayoutTab>(
    'goTo follows each selection in order',
    build: LayoutCubit.new,
    act: (cubit) => cubit
      ..goTo(LayoutTab.news)
      ..goTo(LayoutTab.profile),
    expect: () => [LayoutTab.news, LayoutTab.profile],
  );
}
