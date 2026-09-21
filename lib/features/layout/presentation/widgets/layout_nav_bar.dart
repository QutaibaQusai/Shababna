import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/config/app_assets.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_sizes.dart';
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
            icon: Icon(tab.icon),
            selectedIcon: tab.showsLogoWhenSelected
                ? _LogoIcon(label: tab.label(l10n))
                : Icon(tab.activeIcon),
            label: tab.label(l10n),
          ),
      ],
    );
  }
}

class _LogoIcon extends StatelessWidget {
  const _LogoIcon({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    const ringWidth = 2.0;
    const gap = 2.0;
    final size = AppSizes.iconMd;

    return Semantics(
      image: true,
      label: label,
      child: Container(
        padding: const EdgeInsets.all(gap),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: IconTheme.of(context).color ?? context.colorScheme.primary,
            width: ringWidth,
          ),
        ),
        child: ClipOval(
          child: Image.asset(
            AppAssets.logoIcon,
            width: size,
            height: size,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
