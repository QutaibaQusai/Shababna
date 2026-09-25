import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../events/presentation/pages/events_page.dart';
import '../../../home/presentation/pages/home_page.dart';
import '../../../news/presentation/pages/news_page.dart';
import '../../../profile/presentation/pages/profile/profile_page.dart';
import '../cubit/layout_cubit.dart';
import '../cubit/layout_tab.dart';
import '../widgets/layout_app_bar.dart';
import '../widgets/layout_nav_bar.dart';
import '../widgets/lazy_indexed_stack.dart';

class MainLayoutPage extends StatelessWidget {
  const MainLayoutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LayoutCubit(),
      child: const _MainLayoutView(),
    );
  }
}

class _MainLayoutView extends StatelessWidget {
  const _MainLayoutView();

  static Widget _pageFor(LayoutTab tab) => switch (tab) {
    LayoutTab.home => const HomePage(),
    LayoutTab.news => const NewsPage(),
    LayoutTab.events => const EventsPage(),
    LayoutTab.profile => const ProfilePage(),
  };

  @override
  Widget build(BuildContext context) {
    final tab = context.watch<LayoutCubit>().state;

    return PopScope(
      canPop: tab == LayoutTab.home,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) context.read<LayoutCubit>().goTo(LayoutTab.home);
      },
      child: Scaffold(
        appBar: const LayoutAppBar(),
        body: LazyIndexedStack(
          index: tab.index,
          children: [for (final value in LayoutTab.values) _pageFor(value)],
        ),
        bottomNavigationBar: const LayoutNavBar(),
      ),
    );
  }
}
