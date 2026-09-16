import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class AppAppBar extends StatelessWidget implements PreferredSizeWidget {
  const AppAppBar({super.key, required this.title, this.onBack, this.actions});

  final String title;
  final VoidCallback? onBack;
  final List<Widget>? actions;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      leading: onBack != null
          ? IconButton(
              icon: const Icon(LucideIcons.arrowLeft),
              onPressed: onBack,
            )
          : null,
      title: Text(title),
      actions: actions,
    );
  }
}
