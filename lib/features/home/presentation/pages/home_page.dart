import 'package:flutter/material.dart';

import '../../../../core/extensions/context_extensions.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        context.l10n.navHome,
        style: context.textTheme.headlineMedium,
      ),
    );
  }
}
