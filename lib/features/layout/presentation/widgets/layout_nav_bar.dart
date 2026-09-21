import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/shared/widgets/app_svg_icon.dart';
import '../cubit/layout_cubit.dart';
import '../cubit/layout_tab.dart';

class LayoutNavBar extends StatelessWidget {
  const LayoutNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    final selected = context.watch<LayoutCubit>().state;
    final l10n = context.l10n;

    return NavigationBar(
      selectedIndex: selected.index,
      onDestinationSelected: (index) =>
          context.read<LayoutCubit>().goTo(LayoutTab.values[index]),
      destinations: [
        for (final tab in LayoutTab.values)
          NavigationDestination(
            icon: AppSvgIcon(asset: tab.iconAsset),
            label: tab.label(l10n),
          ),
      ],
    );
  }
}
